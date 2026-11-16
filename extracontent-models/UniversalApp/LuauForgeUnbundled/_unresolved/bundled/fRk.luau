local module = require("@luauforge/bundled/fQM")
local module2 = require("@luauforge/bundled/fRl")
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = module.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(p2, p3)
		eventIngest:sendEventDeferred(p2, module2.eventNames.pageLoad, { origin = p3 })
	end,
	sendFormInteractionEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(p2, module2.eventNames.formInteraction, {
			origin = p3,
			field = p4
		})
	end,
	sendButtonClickEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(p2, module2.eventNames.buttonClick, {
			origin = p3,
			btn = p4
		})
	end
}
