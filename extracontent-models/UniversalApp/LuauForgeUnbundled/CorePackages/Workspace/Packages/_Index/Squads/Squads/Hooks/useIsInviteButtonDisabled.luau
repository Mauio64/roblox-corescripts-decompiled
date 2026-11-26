local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local cryo = dependencies.Cryo
local react = dependencies.React

return function(p2, items, list)
	return react.useMemo(function(): boolean
		if list == nil then
			return p2 == 0
		end

		local set = cryo.List.toSet(list)

		if p2 < #list then
			return false
		end

		for k, item in items do
			if not set[tostring(k)] then
				return false
			end
		end

		return true
	end, { p2, items, list })
end
