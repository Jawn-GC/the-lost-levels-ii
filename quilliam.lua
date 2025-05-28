local checkpoints = require("Checkpoints/checkpoints")

local level_var = {
    identifier = "quilliam",
    title = "Quilliam [Redux]",
    theme = THEME.DWELLING,
    world = 1,
	level = 3,
	width = 4,
    height = 4,
    file_name = "quilliam.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level_var.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	replace_drop(DROP.QUILLBACK_BOMBBAG, ENT_TYPE.ITEM_BLOOD)
	replace_drop(DROP.QUILLBACK_COOKEDTURKEY, ENT_TYPE.ITEM_BLOOD)

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
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.DECORATION_HANGING_HIDE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HORNEDLIZARD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity.flags = set_flag(entity.flags, 17)
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_CAVEMAN_BOSS)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_CONVEYORBELT_LEFT)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_CONVEYORBELT_RIGHT)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
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
	
	replace_drop(DROP.QUILLBACK_BOMBBAG, ENT_TYPE.ITEM_PICKUP_BOMBBAG)
	replace_drop(DROP.QUILLBACK_COOKEDTURKEY, ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY)
	
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level_var
