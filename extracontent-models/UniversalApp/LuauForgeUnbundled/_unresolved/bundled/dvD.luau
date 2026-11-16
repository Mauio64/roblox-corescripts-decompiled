local fFlagUseNavigationSelectors = require("@luauforge/bundled/dqB").FFlagUseNavigationSelectors
local selectors = require("@luauforge/bundled/dvE").Selectors

return function(p2)
	if fFlagUseNavigationSelectors then
		return selectors.selectCurrentPageName(p2)
	end

	local history = p2.Navigation.history
	local v5 = history[#history]
	return v5[#v5].name
end
