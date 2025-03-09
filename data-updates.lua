require("defines")

--[[
--The table to string function from http://lua-users.org/wiki/TableUtils
--Very useful for debugging

function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end
--]]

--Go through the tables of replications and calculate the numerical costs of all item replications
require("prototypes.repltable.process-costs")
--Go through the tables of replication technologies and sort out their prerequisite technologies
require("prototypes.repltable.process-prereqs")
--Parse the replication table and make the replications and their unlock technologies via the table's data
require("prototypes.repltable.process-actual-creation")

local default_planet = string.lower(settings.startup["tenemut-spawning-planet"].value);
if data.raw.planet[default_planet] then
	data.raw.planet[default_planet].map_gen_settings.autoplace_controls[gprefix.."tenemut"] = {}
	data.raw.planet[default_planet].map_gen_settings.autoplace_settings.entity.settings[gprefix.."tenemut"] = {}
else -- How?
	log("Unknown planet selected as starting planet: "..default_planet)
end

if mods["space-age"] then
	if settings.startup["tenemut-other-planets"].value ~= "None" then
		for planet, ptbl in pairs(data.raw.planet) do
			if planet ~= "nauvis" or settings.startup["tenemut-other-planets"].value == "All" then
				if ptbl.map_gen_settings and ptbl.map_gen_settings.autoplace_controls and ptbl.map_gen_settings.autoplace_settings then
					ptbl.map_gen_settings.autoplace_controls[gprefix.."tenemut"] = {}
					ptbl.map_gen_settings.autoplace_settings.entity.settings[gprefix.."tenemut"] = {}
				end
			end
		end
	end
end