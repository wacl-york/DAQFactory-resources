#' Get Instrument Table
#'
#' Returns a tibble containing name, ip, port, type and serial for all the instruments supported by the logger
#' Right now this downloads the cozi_instruments spreadsheet from Google Drive.
#' The user needs have "cozi_instruments_id" as the sheets_id in {{keyring}} such that
#' \code{keyring::key_get("cozi_instruments_id")} returns the sheet id.
#' This will certainly change when the instrument data finds a better home
#'
#' @param keyName string default cozi_instruments_id. lets the user override the name of their stored key
#' @param force boolean default false. When true re-download the instrument table even if it is cached in the package environment
#'
#' @author W. S. Drysdale
#'
#' @export

get_instrument_table = function(keyName = "cozi_instruments_id",
                                force = F){

  if(is.null(the$allInstruments) | force){
    sheetID = keyring::key_get(keyName)

    sheet = googlesheets4::read_sheet(sheetID, "Sheet1")

    allInstruments = sheet |>
      dplyr::select(
        name = Katie_simple_name,
        serial = Serial_number,
        ip = IP_Address,
        port = Port,
        measurement = Measurement,
        type = `Instrument DAQ ID`) |>
      dplyr::filter(dplyr::if_all(dplyr::everything(), ~!is.na(.x))) |>  # only support instruments that have all variables present
      dplyr::mutate(uidName = paste0("uid", name))

    the$allInstruments = allInstruments
  }

  allInstruments

}
