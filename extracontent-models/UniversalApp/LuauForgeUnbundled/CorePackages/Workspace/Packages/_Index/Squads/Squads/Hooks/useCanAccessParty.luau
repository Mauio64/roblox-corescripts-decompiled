local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy").useAppPolicy

return function()
	return useAppPolicy(function(p2)
		return p2.getCanAccessParty()
	end)
end
