local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

return function(p2)
	if fFlagUseNavigationSelectors then
		return selectors.selectCurrentPageName(p2)
	end

	local history = p2.Navigation.history
	local v5 = history[#history]
	return v5[#v5].name
end
