local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local RouteInfo = AvatarExperienceNavigation.AvatarRoute.RouteInfo
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local v11 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.rn.route")
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v13 = game:DefineFastFlag("AXFixEmptyAvatarRoute", false)
local FFlagAXEnableProfileTab = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableProfileTab
local v15 = if not FFlagAXEnableProfileTab then nil else AvatarExperienceNavigation.AvatarRoute.getActiveAvatarScreen

local function makeRouteInfo(p1) -- line: 26
	-- upvalues: RouteInfo (copy)
	return RouteInfo.new(p1.routeName, p1.key, p1.params)
end

local v17 = if not FFlagAXEnableProfileTab then NavigationUtils.getActiveScreenNavigationState else v15

local function findRoute(p2, p3, p4) -- line: 39
	-- upvalues: findRoute (copy)
	if p3 == p2.routeName then
		return p2, p4
	end

	local v25 = p2.routes or {}
	local v26 = p2.index or 0

	for v27, v28 in v25 do
		local v29, v30 = findRoute(v28, p3, v27 == v26)

		if v29 then
			return v29, p4 and v30
		end
	end

	return nil, false
end
local function findNavigationRoute(p5, p6) -- line: 61
	-- upvalues: findRoute (copy)
	local v33, v34 = findRoute(p5.state or {}, p6, true)

	if v33 == nil then
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(p6 .. " not found in current navigation state")
		end

		v33 = {}
	end

	return v33, v34
end
local function makeAvatarRoute(p7, p8) -- line: 74
	-- upvalues: findNavigationRoute (copy), AvatarScreen (copy), v17 (copy), RouteInfo (copy), AvatarRoute (copy), makeRouteInfo (copy), v13 (copy), AvatarScreenProperties (copy), mutedError (copy), HttpService (copy), v11 (copy)
	local v37 = nil
	local v38 = nil
	local t1 = {}
	local v40, v41 = findNavigationRoute(p7, AvatarScreen.AvatarExperienceMainStackNavigator)
	local routes = v40.routes

	if routes and v40.index then
		local v43 = v17(routes[v40.index])

		v37 = RouteInfo.new(v43.routeName, v43.key, v43.params)

		for i = v40.index, 1, -1 do
			local v45 = v17(routes[i])

			if #t1 < AvatarRoute.maxPreviousCount and i < v40.index then
				table.insert(t1, makeRouteInfo(v45))
			end

			if v13 and not AvatarScreenProperties[v45.routeName] then
				mutedError("AvatarScreenProperties does not exist for: " .. HttpService:JSONEncode(v45))
			end

			if (not v13 or AvatarScreenProperties[v45.routeName]) and not AvatarScreenProperties[v45.routeName].isTransparent then
				v38 = RouteInfo.new(v45.routeName, v45.key, v45.params)

				break
			end
		end
	end

	local v46 = AvatarRoute.new({
		isVisible = p8,
		isOverlayVisible = not v41,
		current = v37,
		previousPages = t1,
		opaque = v38
	})

	v11:debug("makeAvatarRoute: {}", v46)

	return v46
end

return makeAvatarRoute
