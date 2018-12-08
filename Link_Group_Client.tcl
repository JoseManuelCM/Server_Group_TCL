source Group_Client.tcl
source GUI_Group_Client.tcl

GUI_init_client

proc Link_init_client {} \
{
	set port [GUI_get_port]
	set host [GUI_get_host]

	if {1 == [catch {sesion $host $port} fid]} {
    	tk_messageBox -message "Error al conectar con el servidor: \n$fid" -title "Start Server" -icon error
	} else {
		global sock
		tk_messageBox -message "Se conectó al servidor $sock" -title "Cliente conectado" -icon info
	}
}