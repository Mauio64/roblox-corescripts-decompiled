local CorePackages = game:GetService("CorePackages")
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors

return function(p1, _) -- line: 7
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v6 = if not FFlagUseNavigationSelectors then p1.Navigation.history else Selectors.selectLegacyHistory(p1)

	return {
		canGoBackInAppRoute = #v6[#v6] > 1
	}
end
