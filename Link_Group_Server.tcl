source GUI_Group_Server.tcl
source Group_Server.tcl

GUI_init_server

proc Link_init_server {} \
{
	set port [GUI_get_port]
	if {1 == [catch {Group_Server $port} fid]} {
    	tk_messageBox -message "Error al iniciar el Servdor: \n$fid" -title "Start Server" -icon error
	} else {
		tk_messageBox -message "El servidor se encendio en el puerto $port" -title "Start Server" -icon info
		GUI_Connect_Server
		waiting
	}
}