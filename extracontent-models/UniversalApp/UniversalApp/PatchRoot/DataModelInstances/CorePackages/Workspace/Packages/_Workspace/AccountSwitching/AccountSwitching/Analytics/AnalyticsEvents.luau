local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local EventConstants = require(script.Parent.EventConstants)
local EventIngestService = game:GetService("EventIngestService")
local v5 = dependencies.Analytics.AnalyticsReporters.EventIngest.new(EventIngestService)

return {
	sendModalShownEvent = function(s1: string, s2: string) -- line: 8
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s1, EventConstants.eventNames.modalShown, {
			state = s2
		})
	end,
	sendButtonClickEvent = function(s3: string, s4: string, s5: string) -- line: 11
		-- upvalues: v5 (copy), EventConstants (copy)
		v5:sendEventDeferred(s3, EventConstants.eventNames.buttonClick, {
			btn = s4,
			state = s5
		})
	end
}
