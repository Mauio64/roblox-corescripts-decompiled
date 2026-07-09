local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local EventConstants = require(script.Parent.EventConstants)
local EventIngestService = game:GetService("EventIngestService")
local v5 = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendPageLoadEvent = function(s1: string, s2: string) -- line: 8
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s1, EventConstants.eventNames.pageLoad, {
			origin = s2
		})
	end,
	sendFormInteractionEvent = function(s3: string, s4: string, s5: string) -- line: 11
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s3, EventConstants.eventNames.formInteraction, {
			origin = s4,
			field = s5
		})
	end,
	sendButtonClickEvent = function(s6: string, s7: string, s8: string) -- line: 18
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s6, EventConstants.eventNames.buttonClick, {
			origin = s7,
			btn = s8
		})
	end
}
