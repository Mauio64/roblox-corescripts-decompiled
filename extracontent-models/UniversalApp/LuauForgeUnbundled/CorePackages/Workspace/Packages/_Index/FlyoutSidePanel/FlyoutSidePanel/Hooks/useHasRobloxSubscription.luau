local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagEnableBlackbirdCheck

local function useHasRobloxSubscription()
	if fFlagEnableBlackbirdCheck then
		return useSelector(function(p2)
			local user = p2.Users[p2.LocalUserId]
			return user and user.hasRobloxSubscription == true and true or false
		end)
	end

	return false
end

return useHasRobloxSubscription
