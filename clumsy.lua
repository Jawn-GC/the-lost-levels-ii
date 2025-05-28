local checkpoints = require("Checkpoints/checkpoints")

local level_var = {
    identifier = "clumsy",
    title = "Clumsy",
    theme = THEME.DWELLING,
    world = 1,
	level = 3,
	width = 3,
    height = 2,
    file_name = "clumsy.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level_var.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.DECORATION_HANGING_HIDE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	local cavemen = {}
	local caveman_callbacks = {}
	local curse_particles = {}
	local caveman_dead = {}
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		cavemen[#cavemen + 1] = entity.uid
		caveman_dead[#caveman_dead + 1] = false
		entity.more_flags = set_flag(entity.more_flags, ENT_MORE_FLAG.CURSED_EFFECT)
		curse_particles[#curse_particles + 1] = generate_world_particles(PARTICLEEMITTER.CURSEDEFFECT_PIECES, entity.uid)
		caveman_callbacks[#caveman_callbacks + 1] = entity:set_pre_damage(function()
			entity:kill(false, nil)
		end)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_CAVEMAN)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		for i = 1,#cavemen do
			if get_entity(cavemen[i]) ~= nil and get_entity(cavemen[i]).health == 0 and caveman_dead[i] == false then
				extinguish_particles(curse_particles[i])
				caveman_dead[i] = true
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
	cavemen = {}
	caveman_callbacks = {}
	curse_particles = {}
	caveman_dead = {}
	
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level_var
