--Generate the "unit" value for a new regular technology
function research(
	count,
	automation,
	logistic,
	military,
	chemical,
	production,
	utility,
	space,
	metallurgic,
	electromagnetic,
	agricultural,
	cryogenic,
	researchTime
)
	local ingredients = {}
	if automation > 0 then
		ingredients[#ingredients + 1] = { "automation-science-pack", automation }
	end
	if logistic > 0 then
		ingredients[#ingredients + 1] = { "logistic-science-pack", logistic }
	end
	if military > 0 then
		ingredients[#ingredients + 1] = { "military-science-pack", military }
	end
	if chemical > 0 then
		ingredients[#ingredients + 1] = { "chemical-science-pack", chemical }
	end
	if production > 0 then
		ingredients[#ingredients + 1] = { "production-science-pack", production }
	end
	if utility > 0 then
		ingredients[#ingredients + 1] = { "utility-science-pack", utility }
	end
	if space > 0 then
		ingredients[#ingredients + 1] = { "space-science-pack", space }
	end
	if metallurgic > 0 then
		ingredients[#ingredients + 1] = { "metallurgic-science-pack", metallurgic }
	end
	if electromagnetic > 0 then
		ingredients[#ingredients + 1] = { "electromagnetic-science-pack", electromagnetic }
	end
	if agricultural > 0 then
		ingredients[#ingredients + 1] = { "agricultural-science-pack", agricultural }
	end
	if cryogenic > 0 then
		ingredients[#ingredients + 1] = { "cryogenic-science-pack", cryogenic }
	end
	return {
		count = count,
		ingredients = ingredients,
		time = researchTime,
	}
end

--Generate the "unit" value for a new replication technology
function repl_research(research, multiplier, researchTime, reps_override)
	--Calculate the base number of research repetitions
	local reps = reps_override or -1
	if reps == -1 then
		reps = research.tier
		--Because tiers 1 and 5 only have one item each, their repetitions are doubled
		if research.tier == 1 or research.tier == 5 then
			reps = reps * 2
		end
	end

	--Create a list of required research materialss
	local ingredients = {}
	if research.tier == 1 or research.tier == 2 then
		ingredients[#ingredients + 1] = { gprefix .. "tenemut", 1 }
	end
	if research.tier == 2 or research.tier == 3 then
		ingredients[#ingredients + 1] = { gprefix .. "dark-matter-scoop", 1 }
	end
	if research.tier == 3 or research.tier == 4 then
		ingredients[#ingredients + 1] = { gprefix .. "dark-matter-transducer", 1 }
	end
	if research.tier == 4 or research.tier == 5 then
		ingredients[#ingredients + 1] = { gprefix .. "matter-conduit", 1 }
	end

	dmrsa_research_units[research.name] = ingredients
	--Create and return the research cost table
	return {
		count = reps * multiplier,
		ingredients = ingredients,
		time = researchTime,
	}
end

local function get_first_thing_from_results(results, lookfor)
	for k, v in pairs(results) do
		if (not lookfor) or ((lookfor == v.name) or (lookfor == v[1])) then
			if v.type == "item" then
				local amount = v.amount and (v.amount * (v.probability or 1))
				amount = amount or ((v.probability or 1) * 0.5 * (math.max(v.amount_max, v.amount_min) + v.amount_min))
				--[[
				--there will be an error if amount_max or amount_min is missing
				if not amount then
					log("missing amount requirements, returning 0")
					amount = 0
				end
				--]]
				amount = (amount - (v.catalyst_amount or 0))
				return v.name, amount
			elseif not v.type then
				if v.name then
					local amount = v.amount and (v.amount * (v.probability or 1))
					amount = amount
						or ((v.probability or 1) * 0.5 * (math.max(v.amount_max, v.amount_min) + v.amount_min))
					amount = (amount - (v.catalyst_amount or 0))
					return v.name, amount
				else
					return v[1], v[2]
				end
			else
				--fluid
				local amount = v.amount and (v.amount * (v.probability or 1))
				amount = amount or ((v.probability or 1) * 0.5 * (math.max(v.amount_max, v.amount_min) + v.amount_min))
				amount = (amount - (v.catalyst_amount or 0))
				return v.name, amount
			end
		end
	end
	log("wanted item from recipe, found nothing")
	return nil, nil
end

--Get a field from a recipe result regardless of how that field is stored
function get_recipe_result_part(recipe, difficulty, result_overrides)
	--ay yai yai recipe results...
	local difficulties = (difficulty and { recipe[difficulty] or nil })
		or { recipe.normal or nil, recipe.expensive or nil, recipe }
	--[[
	if recipe.name == "bi-wooden-fence" then
		log(serpent.block(recipe))
		log(serpent.block(difficulties))
	end
--]]
	for _, difficulty in pairs(difficulties) do
		if type(difficulty) ~= "table" then
			log(recipe.name .. " difficulty was not false, but is not a table??")
			return nil, nil
		end

		--	multiple_value = multiple_value or single_value
		--	difficulty = difficulty or "normal"

		local needed_result = result_overrides and result_overrides.look_result

		if difficulty.results then
			local main_product = needed_result or difficulty.main_product
			if main_product == "" then
				main_product = nil
			end

			local result, amount = get_first_thing_from_results(difficulty.results, main_product)
			if not result then
				if needed_result then
					log(
						recipe.name .. " had a specific result but it was not in results, can't be used for replication"
					)
					return nil, nil
				elseif main_product then
					log(recipe.name .. " had a main product but it was not in results, can't be used for replication")
					return nil, nil
				else
					log(recipe.name .. " had no result in results, returning nil, nil")
					return nil, nil
				end
			else
				return result, amount
			end
		elseif difficulty.result then
			if needed_result and (recipe.result ~= needed_result) then
				log(
					recipe.name
						.. " was looking for "
						.. needed_result
						.. " but result: "
						.. difficulty.result
						.. " doesn't match"
				)
				return nil, nil
			end

			if (type(difficulty.main_product) == "string") and (difficulty.main_product ~= "") then
				log(
					recipe.name
						.. " had a main_product but only had result - this is unnecessary and may error other mods"
				)
			end

			--result can only be an item
			return difficulty.result, difficulty.result_count or 1
		end
		log(recipe.name .. " had no results at all?")
		return nil, nil
	end
end

--Table to string functions, for debugging purposes
--The following functions were copied and pasted from http://lua-users.org/wiki/TableUtils
function table.val_to_str(v)
	if "string" == type(v) then
		v = string.gsub(v, "\n", "\\n")
		if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
			return "'" .. v .. "'"
		end
		return '"' .. string.gsub(v, '"', '\\"') .. '"'
	else
		return "table" == type(v) and table.tostring(v) or tostring(v)
	end
end

function table.key_to_str(k)
	if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
		return k
	else
		return "[" .. table.val_to_str(k) .. "]"
	end
end

function table.tostring(tbl)
	local result, done = {}, {}
	for k, v in ipairs(tbl) do
		table.insert(result, table.val_to_str(v))
		done[k] = true
	end
	for k, v in pairs(tbl) do
		if not done[k] then
			table.insert(result, table.key_to_str(k) .. "=" .. table.val_to_str(v))
		end
	end
	return "{" .. table.concat(result, ",") .. "}"
end

function table.deepest_copy(tablein)
	-- copies a non-self-referential table, will break to shit for infinitely referential tables
	local tableout = {}
	local key = nil
	local thing = nil

	for key, thing in pairs(tablein) do
		if type(thing) == "table" then
			tableout[key] = table.deepest_copy(thing)
		else
			tableout[key] = thing
		end
	end

	return tableout
end
