#' Make poll
#'
#' Creates the daq sequence(s) "Poll_Instrument". \cr
#' Returns a list of strings as each needs to be written as a separate sequence
#'
#' @inheritParams make_sequences
#'
#' @author W. S. Drysdale


make_poll = function(instrumentNames){

  instruments = get_instrument_table() |>
    dplyr::filter(name %in% instrumentNames)

  poll = paste0("device.",instruments$name,".getAll(",instruments$type,",",instruments$uidName,",",instruments$command_prefix,")") |>
    as.list()

  names(poll) = paste0("poll_", instruments$name)

  poll

}
