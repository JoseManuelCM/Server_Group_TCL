
# Echo_Server --
#	Open the server listening socket
#	and enter the Tcl event loop
#
# Arguments:
#	port	The server's port number
proc Group_Server {port} {
    set s [socket -server Connection_Accept $port] 
}

proc waiting {} {
    vwait forever    
}

# Echo_Accept --
#	Accept a connection from a new client.
#	This is called after a new socket connection
#	has been created by Tcl.
#
# Arguments:
#	sock	The new socket connection to the client
#	addr	The client's IP address
#	port	The client's port number
	
proc Connection_Accept {sock addr port} {
    global clients
    # Record the client's information

    #set status_echo "Accept $sock from $addr port $port"
    #set clients(addr,$sock) $sock
    #puts "guardar $clients(addr,$sock)"
    set clients(addr,$sock) [list $addr $port $sock]

    #puts $status_echo

    # Ensure that each "puts" by the server
    # results in a network transmission

    fconfigure $sock -buffering line

    # Set up a callback for when the client sends data

    fileevent $sock readable [list recive_client_message $sock]
    puts $sock [get_list]
}

# Echo --
#	This procedure is called when the server
#	can read data from the client
#
# Arguments:
#	sock	The socket connection to the client

proc recive_client_message {sock} {
    # Check end of file or abnormal connection drop,
    # then echo data back to the client.
    global clients
    if {[eof $sock] || [catch {gets $sock line}]} {
    	close $sock
    	unset clients(addr,$sock)
    } else {
        puts $sock [asignar $line $sock]
    }
}

proc asignar {place sock} \
{
    global space
    if {[llength $place] != 0} {
         set g [lindex $place 0]
        set s [lindex $place 1]
        set r $space($g,$s)
        toggle_place $g $s
        lappend place $space($g,$s)
        puts "llamar a update"
        Update $sock $place
        return $r
     } 
}

proc get_list {} \
{
    global space
    global n_place
    global n_group
    set lgrupo {}
    for {set i 0} {$i < $n_group} {incr i} {
        set lplace {}
        for {set j 0} {$j < $n_place} {incr j} {
            lappend lplace $space($i,$j)
        }
        lappend lgrupo $lplace
    }
    return $lgrupo

}

proc Update {s p} \
{
    global clients
    foreach x [array get clients] {
        set sock [lindex $x 2]
        puts "-----> $sock"
        if {$sock != ""} {
            if {$s != $sock} {
                puts "recibi"
                puts [lindex $p 0]
                puts [lindex $p 1]
                puts $sock $p
            }
        }
    }
}