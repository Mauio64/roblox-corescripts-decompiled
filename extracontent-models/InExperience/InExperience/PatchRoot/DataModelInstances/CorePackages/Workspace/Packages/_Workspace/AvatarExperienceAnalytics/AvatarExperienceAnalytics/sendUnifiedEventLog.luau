local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local isRunningInStudio = require(Parent.AppCommonLib).isRunningInStudio
local AnalyticsService = require(script.Parent.AnalyticsService)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)
local v5 = game:DefineFastFlag("AXSendUnifiedEventsInStudio", false)

return function(p1) -- line: 11
	-- upvalues: isRunningInStudio (copy), v5 (copy), AnalyticsService (copy), UnifiedEventLogConstants (copy)
	if isRunningInStudio() and not v5 then
		return
	end

	AnalyticsService.EventStream:sendTelemetryEvent(UnifiedEventLogConstants.EVENT_NAME, UnifiedEventLogConstants.EVENT_NAME, p1)
end
