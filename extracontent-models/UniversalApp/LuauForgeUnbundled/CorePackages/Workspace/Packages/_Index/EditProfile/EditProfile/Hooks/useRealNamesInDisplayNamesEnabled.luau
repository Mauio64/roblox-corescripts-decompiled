local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UniversalAppPolicy").useAppPolicy

return function()
	return useAppPolicy(function(p2)
		return p2.getRealNamesInDisplayNamesEnabled()
	end)
end
