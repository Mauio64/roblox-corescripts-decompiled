local module = require("@luauforge/bundled/dzP")
local module2 = require("@luauforge/bundled/dPN")

return function(object, p2)
	module.isType(p2, "string", "moreMenuToCatalogButton event expects eventContext")

	object:sendTelemetryEvent(p2, "moreMenuToCatalogButton", {
		feature = module2.AnalyticsTag
	})
end
