local module = require("@luauforge/bundled/dGK")
local splitPaneStore = require("@luauforge/bundled/dIW").SplitPaneStore

return function(p2)
	if splitPaneStore.isSplitEnabledNow() then
		return module.Visible
	end

	return module.PolicyDependent
end
