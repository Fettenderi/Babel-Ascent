extends WorldEnvironment

@export var enabled := true:
	set(value):
		enabled = value
		
		for effect : CompositorEffect in compositor.compositor_effects:
			effect.set_deferred("enabled", value)
