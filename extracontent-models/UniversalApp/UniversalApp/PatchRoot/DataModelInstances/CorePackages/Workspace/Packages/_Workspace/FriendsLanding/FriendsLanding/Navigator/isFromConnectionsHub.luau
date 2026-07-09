local Parent = script:FindFirstAncestor("FriendsLanding").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

local function getLuaAppsNavigator(p1) -- line: 7
	-- upvalues: AppPage (copy)
	local v5 = p1._dangerouslyGetParent()

	if v5 then
		local v6 = v5._dangerouslyGetParent()

		if v6 then
			return v6.state.routeName == AppPage.CoHubMyConnections
		end
	end

	return false
end

return getLuaAppsNavigator
