local EventIngestService = game:GetService("EventIngestService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local SessionService = game:GetService("SessionService")
local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local default = require(Parent.LoggingProtocol).default
local Analytics = require(Parent.Analytics)
local v7 = Analytics.Analytics.new(RbxAnalyticsService)
local getPlatformTarget = Analytics.getPlatformTarget
local v9 = game:DefineFastFlag("AXSendSessionForEvents", false)

return {
	Diag = v7.Diag,
	EventStream = {
		setRBXEventStream = function(_, s1: string, s2: string, t1: {[any]: any}?) -- line: 17
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v14 = t1 or {}

			EventIngestService:SetRBXEventStream(getPlatformTarget(), s1, s2, v14)
		end,
		sendEventDeferred = function(_, s3: string, s4: string, t2: {[any]: any}?) -- line: 22
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v19 = t2 or {}

			EventIngestService:SendEventDeferred(getPlatformTarget(), s3, s4, v19)
		end,
		sendEventImmediately = function(_, s5: string, s6: string, t3: {[any]: any}?) -- line: 27
			-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
			local v24 = t3 or {}

			EventIngestService:SendEventImmediately(getPlatformTarget(), s5, s6, v24)
		end,
		sendTelemetryEvent = function(_, s7: string, s8: string, t4: {[any]: any}?) -- line: 32
			-- upvalues: default (copy), v9 (copy), SessionService (copy)
			default:logRobloxTelemetryEvent({
				throttlingPercentage = 10000,
				eventName = s8,
				backends = { default.TelemetryBackends.EventIngest }
			}, {
				"addSessionId",
				"addSessionInfo"
			}, t4, s7)

			if v9 then
				default:logRobloxTelemetryEvent({
					eventName = "sessionIdDebugEvent",
					throttlingPercentage = 10000,
					backends = { default.TelemetryBackends.EventIngest }
				}, { "addSessionInfo" }, {
					testEventName = s8,
					sessionTagL2a = SessionService:GetSessionTag("level2a")
				}, s7)
			end
		end
	}
}
