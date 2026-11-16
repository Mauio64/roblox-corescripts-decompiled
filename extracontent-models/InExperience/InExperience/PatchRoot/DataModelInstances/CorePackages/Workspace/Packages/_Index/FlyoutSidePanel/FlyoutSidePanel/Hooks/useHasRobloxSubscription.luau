local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local function useHasRobloxSubscription()
	if FFlagEnableBlackbirdCheck then
		return useSelector(function(p)
			local user = p.Users[p.LocalUserId]
			return user and user.hasRobloxSubscription == true and true or false
		end)
	end

	return false
end

return useHasRobloxSubscription
