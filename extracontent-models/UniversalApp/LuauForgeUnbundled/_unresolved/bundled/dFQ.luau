local module = require("@luauforge/bundled/dDF")
local splitPaneStore = require("@luauforge/bundled/dFR").SplitPaneStore

return function(p2)
	if splitPaneStore.isSplitEnabledNow() then
		return module.Visible
	end

	return module.PolicyDependent
end
