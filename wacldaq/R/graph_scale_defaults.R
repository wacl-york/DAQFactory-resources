#' Graph Scale Defaults
#'
#' Returns a table of x and y scales that can be used as global variables to control graphing
#'
#' @author W. S. Drysdale
#'
#' @export

graph_scale_defaults = function(){

  dplyr::tribble(
    ~measurement, ~xscale,~yscale,
    "O3", 60, 36000,
    "CO", 1, 36000,
    "NO", 20, 36000,
    "NO2", 20, 36000,
    "NOx", 40, 36000,
    "SO2", 20, 36000,
  )

}

