local module = require("@luauforge/bundled/dPN")

return function(object, p2)
	object:sendTelemetryEvent(p2, "avatarToCatalogButton", {
		feature = module.AnalyticsTag
	})
end
