local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentLayers/Dash")
local AppUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperimentLayers/ExperimentLayers/AppUserLayers")

local defineFastString = game:DefineFastString("IxpNewLayersForRegistration", "")

local function findNextKey(set, p2)
	if not set[p2] then
		set[p2] = true
		return p2
	end

	for i = 2, 100 do
		local v5 = p2 .. "_" .. i

		if not set[v5] then
			set[v5] = true
			return v5
		end
	end

	error("Exceeded max index for next key search: " .. p2)
end

local function getAllAppUserLayers(p2)
	local v5 = p2 or defineFastString

	if #v5 == 0 then
		return AppUserLayers
	end

	local copy = Dash.copy(AppUserLayers)

	local set = {}
	local set2 = {}

	for k, v6 in copy do
		set[k] = true
		set2[v6] = true
	end

	local v6 = string.split(v5, ",")
	local mapped = Dash.map(v6, Dash.trim)

	for k, v7 in mapped do
		if set2[v7] then
			continue
		end

		set2[v7] = true
		copy[findNextKey(set, v7)] = v7
	end

	return copy
end

return getAllAppUserLayers
