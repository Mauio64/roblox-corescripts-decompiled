local module = require("@luauforge/bundled/fXv")

local function collectUniverseIdsFromState(p2)
	local set = {}
	local universeIdsFromState = {}

	local function addUniverseId(value)
		if type(value) == "string" and value ~= "" and not set[value] then
			set[value] = true
			table.insert(universeIdsFromState, value)
		end
	end

	if p2.GameDetailsV2 then
		for k in pairs(p2.GameDetailsV2) do
			if type(k) ~= "string" or k == "" or set[k] then
				continue
			end

			set[k] = true
			table.insert(universeIdsFromState, k)
		end
	end

	if not p2.GameDetails then
		return universeIdsFromState
	end

	for k in pairs(p2.GameDetails) do
		if type(k) ~= "string" or k == "" or set[k] then
			continue
		end

		set[k] = true
		table.insert(universeIdsFromState, k)
	end

	return universeIdsFromState
end

return function(p2)
	return function(object)
		local v5 = collectUniverseIdsFromState(object:getState())

		for i, v6 in ipairs(v5) do
			object:dispatch(module(p2, v6))
		end
	end
end
