local module = require("@luauforge/bundled/dMx")

return function(object, p2)
	object:sendTelemetryEvent(p2, "catalogOpenedFromLandingPage", {
		feature = module.AnalyticsTag
	})
end
