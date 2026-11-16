local module = require("@luauforge/deferred/eeZ")
local analyticsFactory = module.Analytics.AnalyticsFactory
local defaultAnalyticsService = module.Analytics.DefaultAnalyticsService

local module2 = require("@luauforge/deferred/efa")
local module3 = require("@luauforge/deferred/efd")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = module2, Telemetry = module3 },
	analyticsImpl = {
		EventStream = defaultAnalyticsService.EventStream,
		Telemetry = defaultAnalyticsService.Telemetry
	}
})
