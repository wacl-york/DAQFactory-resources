#' Make Sequences
#'
#' Creates init, logging, pollAll and various poll_instrument seqences and saves as .txt files
#'
#' @param instrumentNames vector of instrument names matching those in the table defined by \code{get_instrument_table()}
#' @param fpRoot path to the folder in which to save data
#' @param filePrefix name to prefix to file ahead of the start date.
#' @param historyLength numeric default 21600 - DAQFactory \code{channelName.HistoryLength} - how long (in seconds) should the channel keep in memory
#' @param outputPath path to folder where sequeces should be saved
#'
#' @author W. S. Drysdale
#'
#' @export


make_sequences = function(instrumentNames,
                          fpRoot,
                          filePrefix,
                          historyLength = 21600,
                          outputPath){

  sequences = list(
    init = make_init(instrumentNames,
                     fpRoot,
                     filePrefix,
                     historyLength),
    logging = make_logging(),
    pollAll = make_pollAll(instrumentNames)
  ) |>
    append(make_poll(instrumentNames))

  purrr::walk2(sequences, paste0(names(sequences),".txt"), ~writeLines(.x, con = file.path(outputPath,.y)))


}
