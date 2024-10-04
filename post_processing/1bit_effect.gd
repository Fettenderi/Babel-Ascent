@tool
class_name BitEffect extends AbstractEffect

func _render_callback(_effect_callback_type: int, render_data: RenderData) -> void:
	if not rd or not _check_shader(): return

	var scene_buffers : RenderSceneBuffersRD = render_data.get_render_scene_buffers()
	var scene_data : RenderSceneDataRD = render_data.get_render_scene_data()
	if not scene_buffers or not scene_data: return
	
	var size : Vector2i = scene_buffers.get_internal_size()
	if size.x == 0 or size.y == 0: return
	
	@warning_ignore("integer_division")
	var x_group : int = size.x / 16 + 1
	@warning_ignore("integer_division")
	var y_group : int = size.y / 16 + 1
	
	var inv_proj_mat : Projection = scene_data.get_cam_projection().inverse()
	
	var push_constants : PackedFloat32Array = PackedFloat32Array()
	push_constants.append(size.x)
	push_constants.append(size.y)
	push_constants.append(inv_proj_mat[2].w)
	push_constants.append(inv_proj_mat[3].w)
	
	for view in scene_buffers.get_view_count():
		var screen_texture : RID = scene_buffers.get_color_layer(view)
		
		var uniform : RDUniform = get_uniform([screen_texture], RenderingDevice.UNIFORM_TYPE_IMAGE, 0)
		var image_uniform_set : RID = UniformSetCacheRD.get_cache(shader, 0, [uniform])
		
		var depth_texture : RID = scene_buffers.get_depth_layer(view)
		var linear_sampler : RID = get_sampler(RenderingDevice.SAMPLER_FILTER_LINEAR)
		uniform = get_uniform([linear_sampler, depth_texture], RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE, 0)
		var depth_uniform_set : RID = UniformSetCacheRD.get_cache(shader, 1, [uniform])
		
		var compute_list : int = rd.compute_list_begin()
		rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
		rd.compute_list_bind_uniform_set(compute_list, image_uniform_set, 0)
		rd.compute_list_bind_uniform_set(compute_list, depth_uniform_set, 1)
		rd.compute_list_set_push_constant(compute_list, push_constants.to_byte_array(), push_constants.size() * 4)
		rd.compute_list_dispatch(compute_list, x_group, y_group, 1)
		rd.compute_list_end()
