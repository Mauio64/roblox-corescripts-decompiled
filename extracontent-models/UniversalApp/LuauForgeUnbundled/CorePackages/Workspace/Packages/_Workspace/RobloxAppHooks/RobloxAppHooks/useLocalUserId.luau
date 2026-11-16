local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactUtils").Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p2)
		return p2.LocalUserId
	end)
end
