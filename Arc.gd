extends Sprite2D

var positionA = Vector2(200, 500)
var positionB = Vector2(500, 200)
var positionC = Vector2(200, 200)

var t = 0.0
var duration = 2.0

func _draw():
	draw_circle(positionA - position, 20, Color(255, 0,0, 0.7))
	draw_circle(positionB - position, 20, Color(0, 255,0, 0.7))
	draw_circle(positionC - position, 20, Color(0, 0,255, 0.7))

func _process(delta):
	t += delta / duration
	
	var q0 = positionA.lerp(positionC, min(t, 1.0))
	var q1 = positionC.lerp(positionB, min(t, 1.0))
	#position = q0.lerp(q1, min(t, 1.0))
