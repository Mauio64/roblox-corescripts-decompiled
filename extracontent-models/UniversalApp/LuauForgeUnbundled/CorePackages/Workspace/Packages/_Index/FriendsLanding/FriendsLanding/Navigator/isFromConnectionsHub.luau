local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppEnums").AppPage

local function getLuaAppsNavigator(p2): boolean
	local dangerouslyGetParent = p2._dangerouslyGetParent()

	local v5 = dangerouslyGetParent and dangerouslyGetParent._dangerouslyGetParent()

	if v5 then
		return v5.state.routeName == appPage.CoHubMyConnections
	end

	return false
end

return getLuaAppsNavigator
