#' Make Init
#'
#' Creates the daq sequence "init". \cr
#' This sequence sets up global variables for graphing and channels for logging via the wacl_cozi.ddp
#'
#' @inheritParams make_sequences
#'
#' @author W. S. Drysdale
#'
#' @export


make_init = function(instrumentNames,
                     fpRoot,
                     filePrefix,
                     historyLength = 21600){

  instruments = get_instrument_table() |>
    dplyr::filter(name %in% instrumentNames)

  measureands = instruments$measurement |>
    stringr::str_split("/") |>
    unlist()

  if("NO" %in% measureands & "NO2" %in% measureands & !"NOx" %in% measureands){
    measureands = append(measureands, "NOx")
  }

  graphScales = graph_scale_defaults() |>
    dplyr::filter(measurement %in% measureands)

  sequence = c("endseq(pollAll)",
               "endseq(logging)",
               "// wait 10 secs to allow poll to finish",
               "wait(10)",
               "channel.ClearAll()",
               "",
               "// ids") |>
    append(paste0("global string ",instruments$uidName,' = "',instruments$serial,'"')) |>
    append(c("",
             "// file path")) |>
    append(paste0('global string fpRoot = "', fpRoot,'"')) |>
    append(paste0('global string filePrefix = "', filePrefix,'"')) |>
    append(c("",
             "// graph controls")) |>
    append(paste0("global scale",graphScales$measurement," = ",graphScales$yscale)) |>
    append(paste0("global scaleX",graphScales$measurement," = ",graphScales$xscale)) |>
    append(c("",
             "// Create Channels")) |>
    append(paste0("device.",
                  instruments$name,
                  '.createChannels("',
                  instruments$type,
                  '", ',
                  instruments$uidName,
                  ', ',
                  historyLength,
                  ' ,"',
                  instruments$name,
                  '")'
    )) |>
    append(c("",
             "// start logging at nearest minute",
             'waituntil(floor(SysTime() / 60) * 60 + 60)',
             "beginseq(pollAll)",
             "beginseq(logging)"))


}
