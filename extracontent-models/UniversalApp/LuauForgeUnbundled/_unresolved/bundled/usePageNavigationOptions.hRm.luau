local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local useNavigation = Navigation.useNavigation
local getActiveRoutes = Navigation.getActiveRoutes

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module3 = require("@luauforge/bundled/dDE")
local module4 = require("@luauforge/bundled/hRn")

local getFFlagLuaAppEnableTopBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableTopBanner

local function createPageNavigationOptionsFromRouteState(p2)
	local routeName = p2.routeName
	local v5 = module3[routeName] or {}

	local detail = if routeName == appPage.SearchPage and p2.params then p2.params.detail else nil

	local pageNavigationOptionsFromRouteState = {
		routeName = routeName,
		titleLocalizationKey = v5.nameLocalizationKey,
		headerBarDisplayOption = 0,
		searchUuid = 0,
		disableAppTopBanner = 0
	}
	local v6 = if v5.renderUnderlyingPage then module4.DeferBeneath else v5.headerBarDisplayOption
	pageNavigationOptionsFromRouteState.headerBarDisplayOption = v6

	pageNavigationOptionsFromRouteState.searchUuid = detail
	local v7 = if getFFlagLuaAppEnableTopBanner() then v5.disableAppTopBanner == true else false
	pageNavigationOptionsFromRouteState.disableAppTopBanner = v7
	return pageNavigationOptionsFromRouteState
end

local function getRootPage(p2)
	if not (p2.routes and p2.index) then
		return nil
	end

	local route = p2.routes[1]

	if route.routes and route.index and route.routeName == NavigationRodux.Constants.TempRnSwitchNavigatorName then
		return route.routes[route.index].routeName
	end

	return route.routeName
end

local function getPageNavigationOptionsInReverse(state)
	local activeRoutes = getActiveRoutes(state)

	for i = #activeRoutes, 1, -1 do
		local pageNavigationOptionsFromRouteState = createPageNavigationOptionsFromRouteState(activeRoutes[i])

		if pageNavigationOptionsFromRouteState.headerBarDisplayOption ~= module4.DeferBeneath then
			return pageNavigationOptionsFromRouteState
		end
	end

	local v5 = {
		routeName = appPage.None,
		titleLocalizationKey = "",
		headerBarDisplayOption = module4.HideAll,
		searchUuid = nil,
		disableAppTopBanner = 0
	}

	local v6 = if getFFlagLuaAppEnableTopBanner() then false else nil
	v5.disableAppTopBanner = v6
	return v5
end

local function usePageNavigationOptions()
	local v5 = useNavigation()
	return React.useMemo(function()
		local pageNavigationOptionsInReverse = getPageNavigationOptionsInReverse(v5.state)

		local state = v5.state
		local routeName

		if state.routes and state.index then
			local route = state.routes[1]

			if
				route.routes
				and route.index
				and route.routeName == NavigationRodux.Constants.TempRnSwitchNavigatorName
			then
				routeName = route.routes[route.index].routeName
			else
				routeName = route.routeName
			end
		end

		if not routeName then
			return pageNavigationOptionsInReverse
		end

		local v6 = module3[routeName]

		local v8 = if v6 then v6.nameLocalizationKey else nil
		local v9 = if getFFlagLuaAppEnableTopBanner() and v6 then v6.disableAppTopBanner == true else nil
		pageNavigationOptionsInReverse.rootPageOptions = {
			routeName = routeName,
			titleLocalizationKey = v8,
			disableAppTopBanner = v9
		}

		return pageNavigationOptionsInReverse
	end, { v5.state })
end

return usePageNavigationOptions
