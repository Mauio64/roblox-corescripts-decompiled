local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagEnableBlackbirdCheck = require(Parent.SharedFlags).FFlagEnableBlackbirdCheck

local function useHasRobloxSubscription() -- line: 9
	-- upvalues: FFlagEnableBlackbirdCheck (copy), useSelector (copy)
	if not FFlagEnableBlackbirdCheck then
		return false
	end

	return useSelector(function(p1) -- line: 13
		local v6 = p1.Users[p1.LocalUserId]

		return not not v6 and (v6.hasRobloxSubscription == true or false)
	end)
end

return useHasRobloxSubscription
