local checkpoints = require("Checkpoints/checkpoints")

local level_var = {
    identifier = "tubular",
    title = "Tubular [Redux]",
    theme = THEME.SUNKEN_CITY,
    world = 2,
	level = 10,
	width = 4,
    height = 4,
    file_name = "tubular.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level_var.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	replace_drop(DROP.EGGSAC_GRUB_1, ENT_TYPE.ITEM_BLOOD)
	replace_drop(DROP.EGGSAC_GRUB_2, ENT_TYPE.ITEM_BLOOD)
	replace_drop(DROP.EGGSAC_GRUB_3, ENT_TYPE.ITEM_BLOOD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SKELETON)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_BONES)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_SUNKEN)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	--Indicator for rope
	local rope_xy = {}
	define_tile_code("unrolled_rope")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		rope_xy[#rope_xy + 1] = {x,y}
	end, "unrolled_rope")

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			for i = 1,#rope_xy do
				local rope_uid = spawn_unrolled_player_rope(rope_xy[i][1], rope_xy[i][2], 0, players[1]:get_texture(), 0)
				get_entity(rope_uid).color:set_rgba(100, 100, 100, 235)
				get_entity(rope_uid).flags = clr_flag(get_entity(rope_uid).flags, 9)
			end
		end
        frames = frames + 1
    end, ON.FRAME)
	
	if not options.checkpoints_disabled then
		checkpoints.activate()
	end
	
	toast(level_var.title)
	
end

level_var.unload_level = function()
    if not level_state.loaded then return end
    
	checkpoints.deactivate()
	replace_drop(DROP.EGGSAC_GRUB_1, ENT_TYPE.MONS_GRUB)
	replace_drop(DROP.EGGSAC_GRUB_2, ENT_TYPE.MONS_GRUB)
	replace_drop(DROP.EGGSAC_GRUB_3, ENT_TYPE.MONS_GRUB)
	
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level_var
