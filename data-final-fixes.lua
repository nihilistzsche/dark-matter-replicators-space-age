--[[
2022-08-05
space exploration ~version 0.6.82 ignores se_prodecural_tech_exclusions when recursively moving tech paths
--]]
local technologies = data.raw.technology
local recipes = data.raw.recipe

local function add_prereq_if_missing(difficulty, prereq)
	difficulty.prerequisites = difficulty.prerequisites or {}
	for k,v in pairs(difficulty.prerequisites) do
		if v == prereq then return end
	end
	table.insert(difficulty.prerequisites, prereq)
end

local function foreach_difficulty(prototype, f, ...)
	if prototype.normal or prototype.expensive then
		if prototype.normal then
			f(prototype.normal, ...)
		end
		if prototype.expensive then
			f(prototype.expensive, ...)
		end
	else
			f(prototype, ...)
	end
end


if mods["space-exploration"] then
	local replaced_production_science_pack = false
	local replaced_utility_science_pack = false

	for name, tech in pairs(technologies) do
		if string.find(name, "^dmrsa") then
			--log("found one of ours: "..name)
			for _, difficulty in pairs({tech, tech.normal, tech.expensive}) do
				if type(difficulty) == "table" then
					local unit = difficulty.unit
					if unit then
						local ingredients = unit.ingredients
						if ingredients then
							local k_previous = nil
							while (true) do
								local k, v = next(ingredients, k_previous)
								if not k then break end
								local pack = v[1] or v.name
								if (pack == "se-rocket-science-pack")
									or ((k ~= 1) and (pack == "space-science-pack"))
									then
									--log("removing: "..pack.." from "..name)
									if type(k) == "number" and k <= #ingredients then
										table.remove(ingredients, k)
									else
										ingredients[k] = nil
									end

								elseif (pack == "production-science-pack") then
									ingredients[k] = {"se-rocket-science-pack", 1}
									k_previous = k

									for i,p in pairs(difficulty.prerequisites or {}) do
										if p == "production-science-pack" then
											difficulty.prerequisites[i] = "se-rocket-science-pack"
											break
										end
									end
								elseif (pack == "utility-science-pack") then
									ingredients[k] = {"space-science-pack", 1}
									k_previous = k

									for i,p in pairs(difficulty.prerequisites or {}) do
										if p == "utility-science-pack" then
											difficulty.prerequisites[i] = "space-science-pack"
											break
										end
									end

								else
									k_previous = k
								end
							end
						end
					end -- end if unit

					if string.find(name, "production%-science%-pack") and technologies["production-science-pack"] then
						add_prereq_if_missing(difficulty, "production-science-pack")
						replaced_production_science_pack = true
					end

					if string.find(name, "utility%-science%-pack") and technologies["utility-science-pack"] then
						add_prereq_if_missing(difficulty, "utility-science-pack")
						replaced_utility_science_pack = true
					end
				end -- end type difficulty == table
			end
		end
	end

	if not recipes["dmrsa-repl-production-science-pack"]
		and not recipes["dmrsa-repl-production-science-pack"]
		and not recipes["dmrsa-repl-utility-science-pack"]
	then
		log("SE extra patches: production, utility, space science packs cannot be replicated, skipping adjustments")
	else
		if replaced_production_science_pack then
			recipes["dmrsa-repl-production-science-pack"].energy_required = recipes["dmrsa-repl-production-science-pack"].energy_required * 75
		end
		if replaced_utility_science_pack then
			recipes["dmrsa-repl-utility-science-pack"].energy_required = recipes["dmrsa-repl-utility-science-pack"].energy_required * 75
		end
		--this can be removed somehow, so let it go I guess.
		if recipes["dmrsa-repl-space-science-pack"] then
			recipes["dmrsa-repl-space-science-pack"].energy_required = recipes["dmrsa-repl-space-science-pack"].energy_required * 40
		end
	end
end
::end_se::


local techs = data.raw.technology
for _, tech in pairs(techs) do
	if string.find(tech.name, "^dmrsa") then
		local difficulties = {tech, tech.normal or nil, tech.expensive or nil}
		for _, difficulty in pairs(difficulties) do
			local prerequisites = difficulty.prerequisites
			if prerequisites then
				for k, prereq in pairs(prerequisites) do
					if not techs[prereq] then
						prerequisites[k] = nil
						log("removed prereq "..prereq.." from "..tech.name)
					end
				end
			end
		end
	end
end

local item_classes = defines.prototypes.item
local item_prototype_names = {}
for class in pairs(item_classes) do
	for k in pairs(data.raw[class] or {}) do
		item_prototype_names[k] = true
	end
end

--we produce recipes of 0 ingredients!
local function check_for_invalid_recipe_ingredients(difficulty, remove_by_ingredients)
	local ingredients = difficulty.ingredients
	local removed_something = false
	if ingredients then
		local k, ingredient = next(ingredients)
		local knext
		while(k) do
			knext = next(ingredients, k)
			if ingredient.type ~= "fluid" then
				if not item_prototype_names[ingredient.name or ingredient[1]] then
					log("removing ingredient: "..(ingredient.name or ingredient[1]))
					if type(k) == "number" then
						table.remove(ingredients, k)
					else
						ingredients[k] = nil
					end
					removed_something = true
				end
			end
			k, ingredient = knext, ingredients[knext]
		end
	end
	if removed_something and (not next(ingredients)) then
		remove_by_ingredients[1] = true
	end
end

local function check_for_invalid_recipe_results(difficulty, remove_by_products)
	local results = difficulty.results
	local removed_anything = false
	if results then
		local k, result = next(results)
		local knext
		while(k) do
			knext = next(results, k)
			if result.type ~= "fluid" then
				if not item_prototype_names[result.name or result[1]] then
					log("removing result: "..(result.name or result[1]))
					if type(k) == "number" then
						table.remove(results, k)
						removed_anything = true
					else
						results[k] = nil
						removed_anything = true
					end
				end
			end
			k, result = knext, results[knext]
		end
		if removed_anything and (not next(results)) then
			remove_by_products[1] = true
		end
	end
end

for rname, recipe in pairs(recipes) do
	if string.find(rname, "^dmrsa") then
		local has_none = {}
		--removing invalid item ingredients and item products, does not handle fluid
		foreach_difficulty(recipe, check_for_invalid_recipe_results, has_none)
		if next(has_none) then
			log(recipe.name.." had results, and after invalid items, now has none")
			--recipes[rname] = nil
		end
	end
end









