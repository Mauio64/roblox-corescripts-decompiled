local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SessionService = game:GetService("SessionService")
local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget

local defineFastFlag = game:DefineFastFlag("AXSendSessionForEvents", false)

return {
	Diag = analytics.Diag,
	EventStream = {
		setRBXEventStream = function(_, p: string, p2: string, options)
			EventIngestService:SetRBXEventStream(getPlatformTarget(), p, p2, options or {})
		end,
		sendEventDeferred = function(_, p: string, p2: string, options)
			EventIngestService:SendEventDeferred(getPlatformTarget(), p, p2, options or {})
		end,
		sendEventImmediately = function(_, p: string, p2: string, options)
			EventIngestService:SendEventImmediately(getPlatformTarget(), p, p2, options or {})
		end,
		sendTelemetryEvent = function(_, p: string, p2: string, p3)
			default:logRobloxTelemetryEvent({
				eventName = p2,
				backends = { default.TelemetryBackends.EventIngest },
				throttlingPercentage = 10000
			}, { "addSessionId", "addSessionInfo" }, p3, p)

			if defineFastFlag then
				default:logRobloxTelemetryEvent({
					eventName = "sessionIdDebugEvent",
					backends = { default.TelemetryBackends.EventIngest },
					throttlingPercentage = 10000
				}, { "addSessionInfo" }, {
					testEventName = p2,
					sessionTagL2a = SessionService:GetSessionTag("level2a")
				}, p)
			end
		end
	}
}
