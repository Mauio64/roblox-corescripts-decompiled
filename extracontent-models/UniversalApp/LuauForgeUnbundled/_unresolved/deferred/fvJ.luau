local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

return function(p2, p3)
	local v5

	if fFlagUseNavigationSelectors then
		v5 = selectors.selectLegacyHistory(p2)
	else
		v5 = p2.Navigation.history
	end

	return {
		canGoBackInAppRoute = #v5[#v5] > 1
	}
end
