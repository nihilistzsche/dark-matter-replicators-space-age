
local fluids = data.raw.fluid
local items = {}
for class in pairs(defines.prototypes.item) do
	for name in pairs(data.raw[class] or {}) do
		items[name] = true
	end
end
local recipes = data.raw.recipe

local function item_recipe_if_exists(name, tier)
	if items[name] and recipes[name] then
		repltech_recipe(name, tier)
	end
end

local function fluid_recipe_if_exists(name, tier)
	if fluids[name] and recipes[name] then
		repltech_recipe(name, tier)
	end
end


fluid_recipe_if_exists("oxygen", "chemical")

if items["silver-ore"] then
	repltech_ore("silver-ore", 0.625, 4, {internal_name = gprefix.."47-ore-silver"})
	repltech_element(47, "silver", {replsub_recipe("silver-plate")}, nil, "silver-plate")
end

item_recipe_if_exists("silver-brazing-alloy", "chemical")
item_recipe_if_exists("silver-wire", "chemical")

if items["gold-ore"] then
	repltech_ore("gold-ore", 0.75, 4, {internal_name = gprefix.."79-ore-gold"})
end
item_recipe_if_exists("gold-ingot", "device4")
