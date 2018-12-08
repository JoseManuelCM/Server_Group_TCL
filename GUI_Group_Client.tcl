proc GUI_init_client {} \
{
	wm title . {Iniciar Space Client}
	. configure -height 100
	. configure -width 300
	. configure -background white

	label .title -foreground white -background blue -font {Helvetica -20 bold} -text "Lugares en el Server" -justify left
	label .dHost -foreground blue -text "-Dirección del Server-" -justify left
	label .nPort -foreground blue -text "-Número de puerto-" -justify left
	button .conectar -text "Conectar" -font {times -15 bold} -foreground orange -background black -command Link_init_client
	entry .puerto -font {Helvetica -12 } -width 10 -textvariable n_puerto -justify right
	entry .host -font {Helvetica -15 } -width 10 -textvariable d_host -justify right
	place .conectar -x 110 -y 60
	place .puerto -x 30 -y 30 
	place .nPort -x 10 -y 10
	place .dHost -x 150 -y 10 
	place .host -x 170 -y 30
}

proc GUI_draw_client {lugares} {
	global n_place
	global n_group
	set n_place 10
	set n_group 3
	global mine
	global aux
	get_list $lugares
	global status
	. configure -width 470
	. configure -height 570
	canvas .lienzo -background black -width 510 -height 570
	place .lienzo -x 0 -y 0
	global space
	global place
	set n_place 10
	set n_group 3
	set x0 10
	set y0 150
	set xf 160
	set yf 560
	.lienzo create text 250 75 -fill blue  -justify center -text "Group Space Server" -font {Helvetica -30 bold}
	for {set i 0} {$i < $n_group} {incr i} {
		.lienzo create text [expr $x0 + 70] [expr $y0 - 15] \
	     		-fill white  -justify center -text "Grupo $i" -font {Helvetica -15 bold}
		.lienzo create rectangle $x0 $y0 $xf $yf -fill blue -outline white -tags group($i)
		set xb0 [expr $x0 + 30]
		set yb0 [expr $y0 + 10]
		for {set j 0} {$j < $n_place} {incr j} {
			button .place($i,$j) -text "Space $j" -font {times -15} -foreground orange -background green -command "toggle_place $i $j"
			if {$aux($i,$j) == 1} {
				.place($i,$j) configure -foreground orange -background green
			} else {
				.place($i,$j) configure -foreground orange -background red
				.place($i,$j) configure -state disabled	
			}
			set mine($i,$j) 0
			place .place($i,$j) -x $xb0 -y $yb0
			set yb0 [expr $yb0 + 40]
		}
		set x0 [expr $x0+150]
		set xf [expr $xf+150]
	}
}

proc toggle_place {i j} \
{
	global mine
	set res [send_request [list $i $j]]
	if {$res == 1} {
		#.place($i,$j) configure -state disabled	
		.place($i,$j) configure -foreground orange -background red
		set mine($i,$j) 1
	} else {
		#.place($i,$j) configure -state normal
		.place($i,$j) configure -foreground orange -background green
		set mine($i,$j) 0
	}
}

proc GUI_get_port {} \
{
  global n_puerto
  return $n_puerto
}

proc GUI_get_host {} \
{
  global d_host
  return $d_host
}

wm protocol . WM_DELETE_WINDOW {
    if {[tk_messageBox -message "¿Desconectar Cliente?" -type yesno] eq "yes"} {
    	liberar
       exit 1
    }
}