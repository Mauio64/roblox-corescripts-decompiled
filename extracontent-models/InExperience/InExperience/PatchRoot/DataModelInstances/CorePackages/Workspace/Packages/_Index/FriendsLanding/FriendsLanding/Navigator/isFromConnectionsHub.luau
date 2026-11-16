local parent = script:FindFirstAncestor("FriendsLanding").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local function getLuaAppsNavigator(p): boolean
	local dangerouslyGetParent = p._dangerouslyGetParent()

	local v = dangerouslyGetParent and dangerouslyGetParent._dangerouslyGetParent()

	if v then
		return v.state.routeName == AppPage.CoHubMyConnections
	end

	return false
end

return getLuaAppsNavigator
