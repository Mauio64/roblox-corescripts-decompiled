local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)

local cryo = dependencies.Cryo
local react = dependencies.React

return function(p: number, items, list)
	return react.useMemo(function(): boolean
		if list == nil then
			return p == 0
		end

		local set = cryo.List.toSet(list)

		if p < #list then
			return false
		end

		for k, _ in items do
			if not set[tostring(k)] then
				return false
			end
		end

		return true
	end, { p, items, list })
end
