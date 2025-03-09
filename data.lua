--constants for labeling
require("defines")

--Load some common functions used by the mod
require("prototypes.functions")

--Load the data for all the mod stuff except for the replications themselves
require("prototypes.raw-resources")
require("prototypes.intermediate-products")
require("prototypes.replicators")
require("prototypes.replication-lab")

--Load the table of replication types
require("prototypes.repltypes")
--Extend the game's data with the replication type data
require("prototypes.repltypes-data")
--Create the replication table and establish the functions for editing it
require("prototypes.repltable.table-creation")

--Create the replication recipes
require("prototypes.replications.vanilla")
require("prototypes.replications.dark-matter-replicators")

require("prototypes.replications.many_mods") --trying to add stuff that can come from multiple places

if mods["elevated-rails"] then
	require("prototypes.replications.elevated-rails")
end

if mods["quality"] then
	require("prototypes.replications.quality")
end

if mods["space-age"] then
    require("prototypes.replications.space-age")
end

if bobmods then
	--bobmods is a global table added by boblibrary
	require("prototypes.replications.bob")
end
if angelsmods then
	--angelsmods is a global table added by a bunch of angels mods
	require("prototypes.replications.angel")
end

if mods["aai-industry"] then
	require("prototypes.replications.aai-industry")
end

if mods["Krastorio2"] then
	require("prototypes.replications.krastorio2")
end

--if data.raw.item["factory-1"] then
if mods["Factorissimo2"] then
	require("prototypes.replications.factorissimo2")
end
if mods["factorissimo-2-notnotmelon"] then
	require("prototypes.replications.factorissimo-2-notnotmelon")
end

--if data.raw.item["y-raw-fuelnium"] then
if mods["Yuoki"] then
	require("prototypes.replications.yuoki")
end
--if data.raw.item["bi_bio_farm"] then
if mods["Bio_Industries"] then
	require("prototypes.replications.bio")
end

if mods["bzgold"] then
	--Noble Metals
	require("prototypes.replications.bzgold")
end

if mods["space-exploration"] then
	require("prototypes.replications.space-exploration")

	se_prodecural_tech_exclusions = se_prodecural_tech_exclusions or {}
	table.insert(se_prodecural_tech_exclusions, "dmrsa")
end

if mods["omnimatter"] then
	--omnimatter compat, instructions from https://github.com/OmnissiahZelos/omnimatter/
	local ore_result = "dmrsa-tenemut"
	--mining time ratio is 2.5 : 1 -> 5:2 LCM's -> 2:5 production/consumption
	--omnimatter omnite:vanilla ore scaling is 7:1 as of 4.1.17 (HT version installed at the time)
	local initial_produced = 1
	local omnite_needed = 15
	omni.matter.add_initial(ore_result, initial_produced, omnite_needed)
	omni.matter.add_resource("dmrsa-tenemut", 1)
end

if mods["lane-balancers"] then
	require("prototypes.replications.lane-balancers")
end

if mods["AdvancedBeltsSA"] then
	require("prototypes.replications.advancedbeltssa")
end

if mods["lane-balancers-advancedbelts"] then
	require("prototypes.replications.lane-balancers-advancedbelts")
end