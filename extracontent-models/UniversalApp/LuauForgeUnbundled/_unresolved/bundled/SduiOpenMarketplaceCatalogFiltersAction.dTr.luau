local avatarScreen = require("@luauforge/bundled/dTs").Enums.AvatarScreen

local module = require("@luauforge/bundled/dTt")
local getCurrentRouteState = module.getCurrentRouteState
local getRootNavigation = module.getRootNavigation

local module2 = require("@luauforge/bundled/dTu")

require("@luauforge/bundled/dTq")

local function SduiOpenMarketplaceCatalogFiltersAction(p2, p3, p4, p5)
	local navigation = p4.dependencies.getNavigation()

	local currentRouteState = getCurrentRouteState(getRootNavigation(navigation))

	if currentRouteState and currentRouteState.routeName == avatarScreen.SortAndFilters then
		navigation.dispatch(module2.Actions.back(nil))
	else
		navigation.navigate(avatarScreen.SortAndFilters, {})
	end
end

return SduiOpenMarketplaceCatalogFiltersAction
