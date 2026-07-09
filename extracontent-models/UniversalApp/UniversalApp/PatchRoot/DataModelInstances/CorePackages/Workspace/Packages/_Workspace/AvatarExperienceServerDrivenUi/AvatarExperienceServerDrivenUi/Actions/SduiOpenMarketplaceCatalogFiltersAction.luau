local Parent = script:FindFirstAncestor("AvatarExperienceServerDrivenUi").Parent
local AvatarScreen = require(Parent.AvatarExperienceNavigation).Enums.AvatarScreen
local Navigation = require(Parent.Navigation)
local getCurrentRouteState = Navigation.getCurrentRouteState
local getRootNavigation = Navigation.getRootNavigation
local RoactNavigation = require(Parent.RoactNavigation)

require(Parent.SduiCoreSystem)

local function SduiOpenMarketplaceCatalogFiltersAction(_, _, p3, _) -- line: 19
	-- upvalues: getCurrentRouteState (copy), getRootNavigation (copy), AvatarScreen (copy), RoactNavigation (copy)
	local v12 = p3.dependencies.getNavigation()
	local v13 = getCurrentRouteState(getRootNavigation(v12))

	if v13 and v13.routeName == AvatarScreen.SortAndFilters then
		v12.dispatch(RoactNavigation.Actions.back(nil))

		return
	end

	v12.navigate(AvatarScreen.SortAndFilters, {})
end

return SduiOpenMarketplaceCatalogFiltersAction
