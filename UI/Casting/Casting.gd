extends Control

var add
var spell = ""
var e
var r
var t
var i
var o
var a
var s
var h
var n

var connections = []

func _ready():
	e = $GridContainer/E
	r = $GridContainer/R
	t = $GridContainer/T
	i = $GridContainer/I
	o = $GridContainer/O
	a = $GridContainer/A
	s = $GridContainer/S
	h = $GridContainer/H
	n = $GridContainer/N


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(spell)
	queue_redraw()

func _draw():
	for i in connections.size()-1:
		draw_line(connections[i]+Vector2(9,9), connections[i+1]+Vector2(9,9), Color.WHITE, 1 )

func _on_e_pressed():
	if connections.has(e.position):
		connections.erase(e.position)
	else:
		connections.append(e.position)
		spell += "e"

func _on_r_pressed():
	if connections.has(r.position):
		connections.erase(r.position)
	else:
		connections.append(r.position)
		spell += "r"

func _on_t_pressed():
	if connections.has(t.position):
		connections.erase(t.position)
	else:
		connections.append(t.position)
		spell += "t"

func _on_i_pressed():
	if connections.has(i.position):
		connections.erase(i.position)
	else:
		connections.append(i.position)
		spell += "i"

func _on_o_pressed():
	if connections.has(o.position):
		connections.erase(o.position)
	else:
		connections.append(o.position)
		spell += "o"

func _on_a_pressed():
	if connections.has(a.position):
		connections.erase(a.position)
	else:
		connections.append(a.position)
		spell += "a"

func _on_s_pressed():
	spell += "s"
	if connections.has(s.position):
		connections.erase(s.position)
	else:
		connections.append(s.position)
		spell += "a"

func _on_h_pressed():
	spell += "h"
	if connections.has(h.position):
		connections.erase(h.position)
	else:
		connections.append(h.position)
		spell += "h"

func _on_n_pressed():
	if connections.has(n.position):
		connections.erase(n.position)
	else:
		connections.append(n.position)
		spell += "n"
