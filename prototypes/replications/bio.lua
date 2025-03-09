--Bio Industries
--patched 2022-11-12
replvar("biofarm-mod-smelting", 1/3) --Cokery
replvar("biofarm-mod-crushing", 5/27) --Stone crusher

--Energy
repltech_recipe("bi-bio-solar-farm", "device4")
repltech_recipe("bi-solar-mat", "device4")
repltech_recipe("bi-bio-accumulator", "device4")
repladd_recipe("small-electric-pole", "bi-wooden-pole-big")

--Bio cannon ammo (if it exists)
--NOT checked 2022-11-12
if BI.Settings.Bio_Cannon then
	repltech_recipe("Bio_Cannon_Basic_Ammo", "device4")
	repltech_recipe("Bio_Cannon_Poison_Ammo", "device4")
end

--Materials
repladd_recipe("stone", "bi-crushed-stone-1")
replvar("wood", {target = "wood", type = "item", multiplier = 2})
--repladd_recipe("wood", "bi-wood-from-pulp")
--repltech_item("bi-ash", "ore", "bi-ash-1", "wood")
--repltech_item("bi-ash", "ore", "bi-ash-1", gprefix.."repl-".."wood") --recipe doesn't exist yet...
repltech_item("bi-ash", "ore", "bi-ash-1")--, "bi-ash-1")
repltech_item("liquid-air", "ore", "bi-liquid-air")
repltech_element(7, "nitrogen", {replsub_recipe("bi-nitrogen")}, "liquid-air")

--Garden
--[[
repltech_recipe("bi-Bio_Garden", "life")
repltech_recipe("bi-fertiliser", "chemical")
repltech_recipe("bi-adv-fertiliser", "chemical")
--]]
repltech_recipe("bi-bio-garden", "life")
repltech_recipe("bi-fertilizer-1", "chemical")

repltech_recipe("bi-woodpulp", "ore")
repltech_recipe("bi-biomass-1", "chemical")
repltech_recipe("bi-adv-fertilizer-2", "chemical")

--Other
repltech_item("seedling", "life", 20)
repltech_recipe("bi-wooden-fence", "shape")
repltech_recipe("bi-coke-coal", "ore")
--[[
if repl_table["006-carbon"] then
	repl_table["006-carbon"].prerequisites[1].target = "bi-coke-coal"
	repl_table["006-carbon"].prerequisites[1].type = "item"
end
]]