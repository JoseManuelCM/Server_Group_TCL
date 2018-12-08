
proc Group_Client {host port} {
    set s [socket $host $port]
    fconfigure $s -buffering line
    fileevent $s readable [list Update $s]
    return $s
}

proc sesion {host port} \
{
	global sock
 	set sock [Group_Client $host $port]	
 	gets $sock space
 	#GUI_conect_server $space
 	GUI_draw_client $space
}

proc send_request {space} \
{
	global sock
	puts $sock $space
	gets $sock answer
	puts $answer
	return $answer
}

proc get_list {lugares} \
{
    global n_place
    global n_group
    global aux
    for {set i 0} {$i < $n_group} {incr i} {
        set grupo [lindex $lugares $i]
        for {set j 0} {$j < $n_place} {incr j} {
            set aux($i,$j) [lindex $grupo $j]
        }
    }
}

proc Update {sock} \
{
	global spaces
	global mine
	gets $sock l
	if {$l != ""} {
		set i [lindex $l 0]
		set j [lindex $l 1]
		set st [lindex $l 2]
		if {$st == 1} {
			.place($i,$j) configure -foreground orange -background green
			.place($i,$j) configure -state normal
		} else {
			.place($i,$j) configure -foreground orange -background red
			.place($i,$j) configure -state disabled
		} 
	} else {
		exit 0
	}
}

proc liberar {} \
{
	global n_group
	global n_place
	global mine

	for {set i 0} {$i < $n_group} {incr i} {
		for {set j 0} {$j < $n_place} {incr j} {
			if {$mine($i,$j) == 1} {
				toggle_place $i $j
			}
		}
	}
}