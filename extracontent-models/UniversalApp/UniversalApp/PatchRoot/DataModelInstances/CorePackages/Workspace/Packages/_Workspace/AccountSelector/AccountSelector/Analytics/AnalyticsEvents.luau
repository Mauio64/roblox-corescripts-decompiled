local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local EventConstants = require(script.Parent.EventConstants)
local EventIngestService = game:GetService("EventIngestService")
local v5 = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(s1: string, s2: string, s3: string) -- line: 8
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s1, EventConstants.eventNames.pageLoad, {
			origin = s2,
			state = s3
		})
	end,
	sendSelectEvent = function(s4: string, s5: string, s6: string) -- line: 11
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s4, EventConstants.eventNames.buttonClick, {
			origin = s5,
			btn = EventConstants.btn.select,
			state = s6
		})
	end,
	sendModalShownEvent = function(s7: string, s8: string) -- line: 18
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s7, EventConstants.eventNames.modalShown, {
			origin = s8
		})
	end,
	sendButtonClickEvent = function(s9: string, s10: string, s11: string) -- line: 21
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s9, EventConstants.eventNames.buttonClick, {
			origin = s10,
			btn = s11
		})
	end
}
