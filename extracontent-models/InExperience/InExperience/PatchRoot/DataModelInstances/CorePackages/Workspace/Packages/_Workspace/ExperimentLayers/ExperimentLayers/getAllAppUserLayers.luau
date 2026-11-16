local parent = script:FindFirstAncestor("ExperimentLayers").Parent
local Dash = require(parent.Dash)
local AppUserLayers = require(script.Parent.AppUserLayers)

local defineFastString = game:DefineFastString("IxpNewLayersForRegistration", "")

local function findNextKey(set, p: string)
	if not set[p] then
		set[p] = true
		return p
	end

	for i = 2, 100 do
		local v = p .. "_" .. i

		if not set[v] then
			set[v] = true
			return v
		end
	end

	error("Exceeded max index for next key search: " .. p)
end

local function getAllAppUserLayers(p: string?)
	local v = p or defineFastString

	if #v == 0 then
		return AppUserLayers
	end

	local copy = Dash.copy(AppUserLayers)

	local set = {}
	local set2 = {}

	for k, v2 in copy do
		set[k] = true
		set2[v2] = true
	end

	local v2 = string.split(v, ",")
	local mapped = Dash.map(v2, Dash.trim)

	for _, v3 in mapped do
		if set2[v3] then
			continue
		end

		set2[v3] = true
		copy[findNextKey(set, v3)] = v3
	end

	return copy
end

return getAllAppUserLayers
