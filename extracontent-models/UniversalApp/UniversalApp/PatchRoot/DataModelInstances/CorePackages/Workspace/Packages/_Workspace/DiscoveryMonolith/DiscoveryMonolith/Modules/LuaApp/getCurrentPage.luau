local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local FFlagUseNavigationSelectors = require(Parent.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(Parent.NavigationRodux).Selectors

return function(p1) -- line: 6
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	if FFlagUseNavigationSelectors then
		return Selectors.selectCurrentPageName(p1)
	end

	local history = p1.Navigation.history
	local v6 = history[#history]

	return v6[#v6].name
end
