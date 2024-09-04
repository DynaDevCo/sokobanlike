@tool
extends Sprite2D

@export var anti = false:
	set(new_val):
		anti = new_val
		update_sprite()
@export var turns = -1:
	set(new_val):
		turns = new_val
		update_sprite()

var grabbed = false

func _ready():
	$Left.mouse_entered.connect(_attempt_push.bind(Vector2.LEFT))
	$Right.mouse_entered.connect(_attempt_push.bind(Vector2.RIGHT))
	$Up.mouse_entered.connect(_attempt_push.bind(Vector2.UP))
	$Down.mouse_entered.connect(_attempt_push.bind(Vector2.DOWN))

func update_sprite() -> void:
	region_rect = Rect2(16*(turns+1),(16*0)+(16 if anti else 0),16,16)

func _on_mouse_entered() -> void:
	self_modulate = Color(1,1,0)

func _on_mouse_exited() -> void:
	self_modulate = Color(1,0.5,0)

func _attempt_push(direction:Vector2):
	if grabbed and not turns == 0:
		if await GlobalEventBus.submit_push_attempt(direction,self):
			if turns > 0: turns -= 1
	grabbed = false

func _on_input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	if event is InputEventMouseButton:
		grabbed = event.pressed

func _process(_delta) -> void:
	if not Engine.is_editor_hint():
		visible = not Input.is_action_pressed("peek")
