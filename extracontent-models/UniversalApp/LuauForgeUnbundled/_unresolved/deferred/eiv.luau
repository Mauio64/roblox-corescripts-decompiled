local module = require("@luauforge/deferred/eiw")
local analyticsFactory = module.Analytics.AnalyticsFactory
local defaultAnalyticsService = module.Analytics.DefaultAnalyticsService

local module2 = require("@luauforge/deferred/eix")
local module3 = require("@luauforge/deferred/eiA")

return analyticsFactory.setUpAnalyticsFactory({
	eventLists = { EventStream = module2, Telemetry = module3 },
	analyticsImpl = {
		EventStream = defaultAnalyticsService.EventStream,
		Telemetry = defaultAnalyticsService.Telemetry
	}
})
