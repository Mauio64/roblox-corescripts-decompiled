local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dFs")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local routeInfo = AvatarExperienceNavigation.AvatarRoute.RouteInfo
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.rn.route")
local module3 = require("@luauforge/bundled/dXh")

local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableProfileTab

local v5 = if fFlagAXEnableProfileTab then AvatarExperienceNavigation.AvatarRoute.getActiveAvatarScreen else nil

local function makeRouteInfo(data)
	return routeInfo.new(data.routeName, data.key, data.params)
end

if not fFlagAXEnableProfileTab then
	v5 = module3.getActiveScreenNavigationState
end

local function findRoute(state, p2, p3)
	if state.routeName == p2 then
		return state, p3
	end

	local routes = state.routes or {}
	local index = state.index or 0

	for k, route in routes do
		local v6, v7 = findRoute(route, p2, k == index)

		if v6 then
			return v6, p3 and v7
		end
	end

	return nil, false
end

local function findNavigationRoute(p2, avatarExperienceMainStackNavigator)
	local v6, v7 = findRoute(p2.state or {}, avatarExperienceMainStackNavigator, true)

	if v6 == nil then
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(avatarExperienceMainStackNavigator .. " not found in current navigation state")
		end

		v6 = {}
	end

	return v6, v7
end

local function makeAvatarRoute(p2, p3)
	local v6 = nil
	local v7 = {}

	local navigationRoute, v8 = findNavigationRoute(p2, avatarScreen.AvatarExperienceMainStackNavigator)
	local routes = navigationRoute.routes
	local v9

	if routes and navigationRoute.index then
		local v10 = v5(routes[navigationRoute.index])
		v9 = routeInfo.new(v10.routeName, v10.key, v10.params)

		for i = navigationRoute.index, 1, -1 do
			local v11 = v5(routes[i])

			if #v7 < avatarRoute.maxPreviousCount and i < navigationRoute.index then
				table.insert(v7, makeRouteInfo(v11))
			end

			if not avatarScreenProperties[v11.routeName] then
				module("AvatarScreenProperties does not exist for: " .. HttpService:JSONEncode(v11))
			end

			if
				avatarScreenProperties[v11.routeName]
				and not avatarScreenProperties[v11.routeName].isTransparent
			then
				v6 = routeInfo.new(v11.routeName, v11.key, v11.params)
				break
			end
		end
	end

	local avatarRoute2 = avatarRoute.new({
		isVisible = p3,
		isOverlayVisible = not v8,
		current = v9,
		previousPages = v7,
		opaque = v6
	})

	logger:debug("makeAvatarRoute: {}", avatarRoute2)
	return avatarRoute2
end

return makeAvatarRoute
