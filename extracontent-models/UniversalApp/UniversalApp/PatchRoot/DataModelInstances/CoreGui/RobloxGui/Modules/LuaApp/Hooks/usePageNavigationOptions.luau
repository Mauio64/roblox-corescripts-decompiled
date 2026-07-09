local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Navigation = require(CorePackages.Workspace.Packages.Navigation)
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local useNavigation = Navigation.useNavigation
local getActiveRoutes = Navigation.getActiveRoutes
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local HeaderBarDisplayOptions = require(Modules.LuaApp.Enum.HeaderBarDisplayOptions)
local GetFFlagLuaAppEnableTopBanner = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableTopBanner

local function createPageNavigationOptionsFromRouteState(p1) -- line: 35
	-- upvalues: AppPageProperties (copy), AppPage (copy), HeaderBarDisplayOptions (copy), GetFFlagLuaAppEnableTopBanner (copy)
	local routeName = p1.routeName
	local v18 = AppPageProperties[routeName] or {}
	local v19 = if routeName ~= AppPage.SearchPage or not p1.params then nil else p1.params.detail

	return {
		routeName = routeName,
		titleLocalizationKey = v18.nameLocalizationKey,
		headerBarDisplayOption = if not v18.renderUnderlyingPage then v18.headerBarDisplayOption else HeaderBarDisplayOptions.DeferBeneath,
		searchUuid = v19,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() and v18.disableAppTopBanner == true
	}
end
local function getRootPage(p2) -- line: 60
	-- upvalues: NavigationRodux (copy)
	if p2.routes and p2.index then
		local v21 = p2.routes[1]

		if v21.routes and v21.index and v21.routeName == NavigationRodux.Constants.TempRnSwitchNavigatorName then
			return v21.routes[v21.index].routeName
		end

		return v21.routeName
	end

	return nil
end
local function getPageNavigationOptionsInReverse(p3) -- line: 76
	-- upvalues: getActiveRoutes (copy), createPageNavigationOptionsFromRouteState (copy), HeaderBarDisplayOptions (copy), AppPage (copy), GetFFlagLuaAppEnableTopBanner (copy)
	local v23 = getActiveRoutes(p3)

	for i = #v23, 1, -1 do
		local v25 = createPageNavigationOptionsFromRouteState(v23[i])

		if v25.headerBarDisplayOption ~= HeaderBarDisplayOptions.DeferBeneath then
			return v25
		end
	end

	return {
		titleLocalizationKey = "",
		searchUuid = nil,
		routeName = AppPage.None,
		headerBarDisplayOption = HeaderBarDisplayOptions.HideAll,
		disableAppTopBanner = not GetFFlagLuaAppEnableTopBanner() and nil
	}
end
local function usePageNavigationOptions() -- line: 95
	-- upvalues: useNavigation (copy), React (copy), getPageNavigationOptionsInReverse (copy), NavigationRodux (copy), AppPageProperties (copy), GetFFlagLuaAppEnableTopBanner (copy)
	local v26 = useNavigation()

	return React.useMemo(function() -- line: 97
		-- upvalues: getPageNavigationOptionsInReverse (copy), v26 (copy), NavigationRodux (copy), AppPageProperties (copy), GetFFlagLuaAppEnableTopBanner (copy)
		local v27 = getPageNavigationOptionsInReverse(v26.state)
		local state = v26.state
		local v30

		if state.routes and state.index then
			local v29 = state.routes[1]

			v30 = if not v29.routes or (not v29.index or v29.routeName ~= NavigationRodux.Constants.TempRnSwitchNavigatorName) then v29.routeName else v29.routes[v29.index].routeName
		else
			v30 = nil
		end

		if v30 then
			local v31 = AppPageProperties[v30]

			v27.rootPageOptions = {
				routeName = v30,
				titleLocalizationKey = if not v31 then nil else v31.nameLocalizationKey,
				disableAppTopBanner = if not GetFFlagLuaAppEnableTopBanner() or not v31 then nil else v31.disableAppTopBanner == true
			}
		end

		return v27
	end, { v26.state })
end

return usePageNavigationOptions
