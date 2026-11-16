local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Cryo = require(parent.Cryo)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

require(MomentsCommon.Analytics.EventNames)
require(MomentsCommon.Analytics.Types)
local telemetryEmitter = require(MomentsCommon.Analytics.telemetryEmitter)
local FunnelEventActionList = require(MomentsCommon.Analytics.FunnelEventActionList)
local SessionManager = require(MomentsCommon.Analytics.SessionManager)
local fireFunnelAnalyticsEvent = require(MomentsCommon.Analytics.fireFunnelAnalyticsEvent)
local GetFFlagMomentsCreationSaveDraft = require(MomentsCommon.Flags.GetFFlagMomentsCreationSaveDraft)

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "MomentsAnalyticsEvent",
	description = "Moments analytics events ported from moments-repo. The wire eventName is taken from the per-emission `eventName` field via `overrideName`; one config covers all moments EventNames values.",
	lastUpdated = { 2026, 5, 28 },
	eventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Moments,
	backendsList = {
		{
			type = "EventIngest",
			standardizedFields = { "addSessionInfo", "addSessionId" },
			overrideName = function(p)
				return p.eventName
			end,
			format = function(p, _)
				return Cryo.Dictionary.join(p.additionalInfo or {}, {
					client_event_timestamp_ms = DateTime.now().UnixTimestampMillis
				})
			end
		}
	}
})

local function fireAnalyticsEvent(eventName, additionalInfo)
	telemetryEmitter.emit(telemetry, { eventName = eventName, additionalInfo = additionalInfo })

	local funnelEventAction = FunnelEventActionList[eventName]

	if funnelEventAction ~= nil then
		for _, v in funnelEventAction do
			if not (not GetFFlagMomentsCreationSaveDraft() or not v.onlyIfSessionOpen or SessionManager.getSessionId(v.funnelType) ~= nil) then
				continue
			end

			local v2 = SessionManager.getSessionId(v.funnelType) or SessionManager.startSession(v.funnelType)

			if v.endSession then
				SessionManager.endSession(v.funnelType)
			end

			if v.stepKey ~= nil then
				fireFunnelAnalyticsEvent(v.funnelType, v.stepKey, v2)
			end
		end
	end
end

return fireAnalyticsEvent
