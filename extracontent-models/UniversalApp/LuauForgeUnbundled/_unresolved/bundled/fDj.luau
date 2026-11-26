local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

return function(object, p2)
	module.isType(p2, "string", "clickNavigationTab event expects eventContext")

	object:sendTelemetryEvent(p2, "catalogNavButtonClick", {
		feature = module2.AnalyticsTag
	})
end
