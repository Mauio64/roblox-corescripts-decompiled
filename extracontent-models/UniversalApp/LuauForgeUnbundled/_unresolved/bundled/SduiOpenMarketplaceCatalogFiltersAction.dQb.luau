local avatarScreen = require("@luauforge/bundled/dQc").Enums.AvatarScreen

local module = require("@luauforge/bundled/dQd")
local getCurrentRouteState = module.getCurrentRouteState
local getRootNavigation = module.getRootNavigation

local module2 = require("@luauforge/bundled/dQe")

require("@luauforge/bundled/dQa")

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
