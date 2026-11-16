local module = require("@luauforge/bundled/dMx")

return function(object, p2)
	object:sendTelemetryEvent(p2, "catalogToAvatarBackButton", {
		feature = module.AnalyticsTag
	})
end
