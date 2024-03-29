#' Make pollAll
#'
#' Creates the daq sequence(s) "Poll_Instrument". \cr
#' This sequence triggers the various poll_instrument sequences every 10 seconds
#'
#' @inheritParams make_sequences
#'
#' @author W. S. Drysdale
#'
#' @export


make_pollAll = function(instrumentNames){

  instruments = get_instrument_table() |>
    dplyr::filter(name %in% instrumentNames)

  c("waituntil(floor(SysTime() / 10) * 10 + 10)",
    paste0("beginseq(poll_",instruments$name,")"))

}
