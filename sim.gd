extends Node2D


# Declare member variables here.
export var G = 6.67e-11
export var n = 3
export var t = 0.1
export var do_trace = false
export var steps = 5
export var lims = 80

var Ms = [10.0, 8.0, 2.0]
var Ps = [Vector2(-20.0, 0.0), Vector2(20.0, 0.0), Vector2(15.0, 30.0)]
var Vs = [Vector2(0.0, 0.3), Vector2(0.0, -0.3), Vector2(0.0, 0.0)]
var As = [Vector2(), Vector2(), Vector2()]
var trace = [[], [], []]

func s(a, b):
	var distance = 0.0
	for d in [0, 1]:
		distance += pow(a[d] - b[d], 2)
	return sqrt(distance)

func _input(event):
	if event.as_text() == "R" and event.is_pressed():
		reset()

# Randomly generate new positions.
func reset():
	trace = []
	Ms = []
	Ps = []
	Vs = []
	for _i in range(0, n):
		Ms.append(exp(rand_range(0, 3)))
		Ps.append(Vector2(rand_range(-lims, lims), rand_range(-lims, lims)))
		Vs.append(Vector2(rand_range(-0.3, 0.3), rand_range(-0.3, 0.3)))
		trace.append([])

# Fill up open spaces on run.
func _ready():
	for _i in range(0, n-len(Ps)):
		Ms.append(exp(rand_range(0, 3)))
		Ps.append(Vector2(rand_range(-lims, lims), rand_range(-lims, lims)))
		Vs.append(Vector2(rand_range(-0.3, 0.3), rand_range(-0.3, 0.3)))
		As.append(Vector2())
		trace.append([])

# Gravitate yada yada
func _process(_delta):
	var adjusted_t = t / steps
	for _step in range(0,steps):
		for i in range(0, len(As)):
			As[i] = Vector2(0.0, 0.0)
		
		for i in range(0, len(Ms)):
			for j in range(0, len(Ps)):
				if Ps[j] != Ps[i]:
					As[i] -= Vector2(G, G) * Ms[j] * (Ps[i] - Ps[j]) / pow(s(Ps[i], Ps[j]), 3)
		
		for i in range(0, len(Vs)):
			Vs[i] += As[i] * adjusted_t
			Ps[i] += Vs[i] * adjusted_t
	
	if do_trace:
		for i in range(0, len(Ps)):
			trace[i].append(Ps[i])
	
	update()

func _draw():
	if do_trace:
		for i in range(0, len(Ps)):
			draw_polyline(trace[i], Color(0.3, 0.3, 0.3))
	
	for i in range(0, len(Ps)):
		draw_circle(Ps[i], log(abs(Ms[i]))+1.0, Color(1.0, 1.0, 1.0))
		draw_line(Ps[i], Ps[i]+As[i]*50, Color(1.0, 0.0, 0.0))
		draw_line(Ps[i], Ps[i]+Vs[i]*(50^2), Color(0.0, 1.0, 0.0))

