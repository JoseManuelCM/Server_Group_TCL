proc GUI_init_server {} \
{
  wm title . {Iniciar Space Server}
  . configure -height 60
  . configure -width 250
  . configure -background white
  label .nPort -foreground blue -text "-Número de puerto-" -justify left
  button .activar -text "Activar" -font {times -15 bold} -foreground orange -background black -command Link_init_server
  entry .puerto -font {Helvetica -12 } -width 10 -textvariable n_puerto -justify right
  place .activar -x 150 -y 10 
  place .puerto -x 30 -y 30 
  place .nPort -x 10 -y 10
}

proc GUI_Connect_Server {} {
	. configure -width 470
	. configure -height 570
	canvas .lienzo -background black -width 510 -height 570
	place .lienzo -x 0 -y 0
	global space
	global place
	global n_place
	global n_group
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
		set xb0 [expr $x0 + 10]
		set yb0 [expr $y0 + 10]
		for {set j 0} {$j < $n_place} {incr j} {
			.lienzo create rectangle $xb0 $yb0 [expr $xb0 + 130] [expr $yb0 + 30] -fill green -tags place($i,$j)
			set space($i,$j) 1
			.lienzo create text [expr $xb0 + 60] [expr $yb0 + 15] \
	     		-fill yellow -justify center -text "Lugar Nu. $j" -font {Helvetica -12}
			set yb0 [expr $yb0 + 40]
		}

		set x0 [expr $x0+150]
		set xf [expr $xf+150]
	}
}

proc toggle_place {i j} \
{
	global space
	if {$space($i,$j) == 1} {
		.lienzo itemconfigure place($i,$j) -fill red
		set space($i,$j) 0
	} else {
		.lienzo itemconfigure place($i,$j) -fill green
		set space($i,$j) 1
	}
}

proc  hide {} \
{
  wm title . {Space Server}
  .activar configure -background blue
  .activar configure -foreground blue
  place .activar -x 505 -y 500
  place .puerto -x 505 -y 500
  place .nPort -x 505 -y 500
  place .lienzo -x 25 -y 25 
  . configure -background blue
}

proc GUI_get_port {} \
{
  global n_puerto
  return $n_puerto
}


wm protocol . WM_DELETE_WINDOW {
    if {[tk_messageBox -message "¿Apagar Servidor?" -type yesno] eq "yes"} {
       exit 1
    }
}