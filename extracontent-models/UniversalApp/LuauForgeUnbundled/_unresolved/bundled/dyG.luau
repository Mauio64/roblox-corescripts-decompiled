local fFlagUseNavigationSelectors = require("@luauforge/bundled/dtD").FFlagUseNavigationSelectors
local selectors = require("@luauforge/bundled/dyH").Selectors

return function(p2)
	if fFlagUseNavigationSelectors then
		return selectors.selectCurrentPageName(p2)
	end

	local history = p2.Navigation.history
	local v5 = history[#history]
	return v5[#v5].name
end
