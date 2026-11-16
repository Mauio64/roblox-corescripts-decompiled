local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Cryo")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SocialLuaAnalytics")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/EventNames")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/Types")
local realtimeTelemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/realtimeTelemetryEmitter")
local FunnelEventActionList = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/FunnelEventActionList")
local SessionManager = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/SessionManager")
local fireFunnelAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/fireFunnelAnalyticsEvent")
local GetFFlagMomentsCreationSaveDraft = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsCreationSaveDraft")

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "MomentsAnalyticsEvent",
	description = "Moments analytics events ported from moments-repo. The wire eventName is taken from the per-emission `eventName` field via `overrideName`; one config covers all moments EventNames values.",
	lastUpdated = { 2026, 5, 28 },
	eventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Moments,
	backendsList = {
		{
			type = "EventIngest",
			standardizedFields = { "addSessionInfo", "addSessionId" },
			overrideName = function(p2)
				return p2.eventName
			end,
			format = function(p2, p3)
				return Cryo.Dictionary.join(p2.additionalInfo or {}, {
					client_event_timestamp_ms = DateTime.now().UnixTimestampMillis
				})
			end
		}
	}
})

local function fireAnalyticsEvent(p2, p3)
	realtimeTelemetryEmitter.emit(telemetry, { eventName = p2, additionalInfo = p3 })

	local v5 = FunnelEventActionList[p2]

	if v5 ~= nil then
		for k, v6 in v5 do
			if not (not GetFFlagMomentsCreationSaveDraft() or not v6.onlyIfSessionOpen or SessionManager.getSessionId(v6.funnelType) ~= nil) then
				continue
			end

			local v7 = SessionManager.getSessionId(v6.funnelType) or SessionManager.startSession(v6.funnelType)

			if v6.endSession then
				SessionManager.endSession(v6.funnelType)
			end

			if v6.stepKey ~= nil then
				fireFunnelAnalyticsEvent(v6.funnelType, v6.stepKey, v7)
			end
		end
	end
end

return fireAnalyticsEvent
