local module = require("@luauforge/bundled/fPo")
local module2 = require("@luauforge/bundled/fPQ")
local EventIngestService = game:GetService("EventIngestService")
local eventIngest = module.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(p2, module2.eventNames.pageLoad, {
			origin = p3,
			state = p4
		})
	end,
	sendSelectEvent = function(p2, p3, p4)
		eventIngest:sendEventDeferred(p2, module2.eventNames.buttonClick, {
			origin = p3,
			btn = module2.btn.select,
			state = p4
		})
	end,
	sendModalShownEvent = function(p2, p3, p4)
		if p4 == nil then
			eventIngest:sendEventDeferred(p2, module2.eventNames.modalShown, {
				origin = p3
			})
		else
			module.getAuthAnalytics().Events.authModalShown(p2, p4, nil, p3)
		end
	end,
	sendButtonClickEvent = function(p2, p3, p4, p5)
		if p5 == nil then
			eventIngest:sendEventDeferred(p2, module2.eventNames.buttonClick, {
				origin = p3,
				btn = p4
			})
		else
			module.getAuthAnalytics().Events.authButtonClick(p2, p4, p5, nil, nil, p3)
		end
	end,
	sendButtonShownEvent = function(p2, p3, p4, p5)
		module.getAuthAnalytics().Events.authButtonShown(p2, p4, p5, p3)
	end
}
