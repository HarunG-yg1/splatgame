extends MarginContainer # textbox


@onready var label : Label = $MarginContainer/Label
@onready var timer  : Timer = $Timer


@onready var MAX_WIDTH = get_viewport_rect().size.x
@onready var MAX_HEIGHT = get_viewport_rect().size.y /3.5
@onready var tween_sprite = create_tween()
var text = ""
var letter_index = 0

var letter_time = 0.01
var space_time = 0.01
var punctuation_time = 0.01


signal finished_displaying()


func display_text(text_to_display: String):
	
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = MAX_WIDTH #min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x resize
		await resized # wait for y resize

		

	custom_minimum_size.y = MAX_HEIGHT

		

	
	label.text = ""
	_display_letter()
	
	
func _display_letter():
	
	#print(letter_index)
	#print(text.length())

	if letter_index >= text.length():
		
		finished_displaying.emit()
		
		return
	label.text += text[letter_index]
	
	
	match text[letter_index]:
		"!",".",",","?":
			
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
	letter_index += 1


func _on_timer_timeout() -> void:
	
	_display_letter()
	
