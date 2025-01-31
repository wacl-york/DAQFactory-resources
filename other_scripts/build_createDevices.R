library(googlesheets4)
library(dplyr)

sheetID = keyring::key_get("cozi_instruments_id")


cozi = googlesheets4::read_sheet(sheetID, "Sheet1") |> 
  filter(!is.na(IP_Address),
         !is.na(Port),
         !is.na(Katie_simple_name),
         !is.na(Serial_number),
         !is.na(`Instrument DAQ ID`))

lines = c()
for(i in 1:nrow(cozi)){
  
    sname = cozi$Katie_simple_name[i]
    port = paste0("port_",sname)
    
    lines = append(lines, paste0("// ",sname))
    lines = append(lines, paste0("global ",port," = new(CCommEthernet)"))
    lines = append(lines, paste0(port,".Address = ",'"',cozi$IP_Address[i],'"'))
    lines = append(lines, paste0(port,".Port = ",cozi$Port[i]))
    
    lines = append(lines, paste0("global ",sname," = new(CCommDevice)"))
    
    lines = append(lines, paste0(sname,".PortObject = ",port))
    lines = append(lines, paste0(sname,'.ProtocolName = "wacl_cozi"'))
    lines = append(lines, "\n")
}

writeLines(lines, "createDevices.txt")
