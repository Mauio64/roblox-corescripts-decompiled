local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/dMx")

return function(object, p2)
	module.isType(p2, "string", "moreMenuToCatalogButton event expects eventContext")

	object:sendTelemetryEvent(p2, "moreMenuToCatalogButton", {
		feature = module2.AnalyticsTag
	})
end
