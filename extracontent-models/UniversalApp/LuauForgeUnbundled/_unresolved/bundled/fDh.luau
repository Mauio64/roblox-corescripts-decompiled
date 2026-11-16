local module = require("@luauforge/bundled/fCM")
local module2 = require("@luauforge/bundled/fDi")
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = module.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendModalShownEvent = function(p2, p3)
		eventIngest:sendEventDeferred(p2, module2.eventNames.modalShown, { state = p3 })
	end,
	sendButtonClickEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(p2, module2.eventNames.buttonClick, {
			btn = p3,
			state = p4
		})
	end
}
