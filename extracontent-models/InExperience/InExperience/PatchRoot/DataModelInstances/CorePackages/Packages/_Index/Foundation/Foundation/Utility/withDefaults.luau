local parent = script:FindFirstAncestor("Foundation").Parent

local Dash = require(parent.Dash)
local ReactIs = require(parent.ReactIs)

local function isTableNotBinding(p): boolean -- 2 equivalent calls inferred from this helper
	return type(p) == "table" and not ReactIs.isBinding(p)
end

local function deepJoin(items, items2)
	local clone = table.clone(items)

	for k, item in items2 do
		if isTableNotBinding(item) and isTableNotBinding(clone[k]) then -- inferred equivalent call
			clone[k] = deepJoin(clone[k], item)
			continue
		end

		clone[k] = item
	end

	return clone
end

local function withDefaults(p, items)
	local v = {}

	if type(p) == "table" and type(items) == "table" then
		for k, _ in items do
			v[k] = p[k]
		end
	end

	local v2 = deepJoin(items, v)

	return (Dash.union(p, v2))
end

return withDefaults
