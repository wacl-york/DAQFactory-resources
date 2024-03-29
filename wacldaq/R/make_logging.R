#' Make Logging
#'
#' Creates the daq sequence "logging". \cr
#'
#'@author W. S. Drysdale
#'
#'@export


make_logging = function(){

  c("// On First Setup",
    "// Make an empty logging set in the UI called 'allChannels'",
    "// Set to fixed interval and define averaging period",
    "",
    "private string allChannelNames = channel.ListAll()",
    "",
    "for(private i = 0, i < numRows(allChannelNames), i++)",
    "  logging.allChannels.AddChannel(allChannelNames[i])",
    "endfor",
    "",
    'logging.allChannels.strLoggingMethod = "ASCII Delimited"',
    'logging.allChannels.strDelimiter = ","',
    'logging.allChannels.strFileName = fp+FormatDateTime("%y%m%d_%H%M%S.csv",SysTime())',
    "",
    "logging.allChannels.Start()",
    "",
    "while(1)",
    "",
    " waituntil(0h+86395) // at 5 seconds to midnight",
    " nowPlus10 = SysTime()+10 // work 10 seconds into the future",
    "",
    ' private string myYear = FormatDateTime("%Y, nowPlus10)',
    ' private string myMonth = FormatDateTime("%m, nowPlus10)',
    ' global string folder = fpRoot+myYear+"/"+myMonth',
    "",
    " if(!File.GetFileExists(folder)) // if the month folder doesn't exist",
    "  if(!File.GetFileExists(fpRoot+myYear)) // check if year folder exists",
    "   File.MakeDirectory(fpRoot+myYear))",
    "  endif",
    " File.MakeDirectory(folder)",
    " endif",
    " waituntil(0h+86400) // should create a new file at midnight",
    " endlogging(allChannels)",
    ' logging.allChannels.strFileName = folder+FormatDateTime(filePrefix+"_%y%m%d_%H%M%S.csv",SysTime())',
    " beginlogging(allChannels)",
    "endwhile")
}
