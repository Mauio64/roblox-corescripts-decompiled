local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SessionService = game:GetService("SessionService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/LoggingProtocol").default
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Analytics")
local analytics = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

local defineFastFlag = game:DefineFastFlag("AXSendSessionForEvents", false)

return {
	Diag = analytics.Diag,
	EventStream = {
		setRBXEventStream = function(self, p3, p4, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p3, p4, options or {})
		end,
		sendEventDeferred = function(p2, p3, p4, options)
			EventIngestService:SendEventDeferred(getPlatformTarget(), p3, p4, options or {})
		end,
		sendEventImmediately = function(self, p3, p4, options)
			EventIngestService:SendEventImmediately(getPlatformTarget(), p3, p4, options or {})
		end,
		sendTelemetryEvent = function(self, p3, p4, p5)
			default:logRobloxTelemetryEvent({
				eventName = p4,
				backends = { default.TelemetryBackends.EventIngest },
				throttlingPercentage = 10000
			}, { "addSessionId", "addSessionInfo" }, p5, p3)

			if defineFastFlag then
				default:logRobloxTelemetryEvent({
					eventName = "sessionIdDebugEvent",
					backends = { default.TelemetryBackends.EventIngest },
					throttlingPercentage = 10000
				}, { "addSessionInfo" }, {
					testEventName = p4,
					sessionTagL2a = SessionService:GetSessionTag("level2a")
				}, p3)
			end
		end
	}
}
