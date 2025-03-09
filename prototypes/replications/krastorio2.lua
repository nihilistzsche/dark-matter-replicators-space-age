
--gear level is 2 / element
repltech_recipe("iron-beam", "element") -- 2 energy and 2 iron plates

repltech_recipe("coke", "element") -- 2 energy and 2 iron plates

repltech_recipe("quartz", "element")
repltech_recipe("silicon", "element")


repltech_recipe("automation-core", "chemical")
repltech_recipe("inserter-parts", "chemical")
repltech_recipe("electronic-components", "chemical")

repltech_recipe("steel-beam", "chemical")
repltech_recipe("steel-gear-wheel", "chemical")

repltech_recipe("kr-water-electrolysis", "element", nil, {look_result = "chlorine"})

repltech_item("raw-rare-metals", "device3",
	{
		{target = "chlorine", type = "item", multiplier = 1},
		--{target = "chlorine", type = "fluid", multiplier = 1/2},
		--{target = "water", type = "item", multiplier = 1},
	}
)

repltech_recipe("rare-metals", "element")