data:extend({
	{ --Recipe
		type = "recipe",
		name = gprefix.."replication-lab",
		enabled = false,
		ingredients = {
			{ name = gprefix.."dark-matter-scoop", amount = 5, type = "item" },
			{ name = "electronic-circuit", amount = 10, type = "item" },
			{ name = "copper-plate", amount = 10, type = "item" }
		},
		results = {
			{name = gprefix.."replication-lab", amount = 1, type = "item"}
		},
		subgroup = gprefix.."replicators",
		order = "a"
	}, { --Item
		type = "item",
		name = gprefix.."replication-lab",
		icon = "__dark-matter-replicators-space-age__/graphics/icons/replication-lab.png",
		icon_size = 64,
		subgroup = gprefix.."replicators",
		order = "a",
		place_result = gprefix.."replication-lab",
		stack_size = 50
	}, { --Entity
		type = "lab",
		name = gprefix.."replication-lab",
		icon = "__dark-matter-replicators-space-age__/graphics/icons/replication-lab.png",
		icon_size = 64,
		flags = {"placeable-player", "player-creation"},
		minable = {mining_time = 1, result = gprefix.."replication-lab"},
		max_health = 150,
		corpse = "big-remnants",
		dying_explosion = "big-explosion",
		collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
		selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
		light = {intensity = 0.75, size = 8},
		on_animation = {
			filename = "__dark-matter-replicators-space-age__/graphics/entity/replication-lab.png",
			width = 113,
			height = 91,
			frame_count = 33,
			line_length = 11,
			animation_speed = 1/3,
			shift = {0.2, 0.15}
		},
		off_animation = {
			filename = "__dark-matter-replicators-space-age__/graphics/entity/replication-lab.png",
			width = 113,
			height = 91,
			frame_count = 1,
			shift = {0.2, 0.15}
		},
		working_sound = {
			sound = {
				filename = "__base__/sound/lab.ogg",
				volume = 0.7
			},
			apparent_volume = 1.5
		},
		energy_source = {
			type = "electric",
			usage_priority = "secondary-input"
		},
		energy_usage = "60kW",
		inputs = {
			gprefix.."tenemut",
			gprefix.."dark-matter-scoop",
			gprefix.."dark-matter-transducer",
			gprefix.."matter-conduit"
		},
		module_slots = 2,
		allowed_module_categories = {"efficiency", "speed", "productivity"}
	}
})
