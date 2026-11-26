local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppHooks/useLocalUserId")

return function()
	local v5 = useLocalUserId()
	return useSelector(function(p2)
		return p2.UserRobux[v5]
	end)
end
