local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local SocialLuaAnalytics = require(MomentsCommonParent.SocialLuaAnalytics)

require(MomentsCommon.Analytics.EventNames)
require(MomentsCommon.Analytics.Types)

local telemetryEmitter = require(MomentsCommon.Analytics.telemetryEmitter)
local FunnelEventActionList = require(MomentsCommon.Analytics.FunnelEventActionList)
local SessionManager = require(MomentsCommon.Analytics.SessionManager)
local fireFunnelAnalyticsEvent = require(MomentsCommon.Analytics.fireFunnelAnalyticsEvent)
local v8 = if not require(MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs)() then nil else {
	"addSessionInfo",
	"addSessionId"
}
local v9 = SocialLuaAnalytics.Telemetry.new({
	name = "MomentsAnalyticsEvent",
	description = "Moments analytics events ported from moments-repo. The wire eventName is taken from the per-emission `eventName` field via `overrideName`; one config covers all moments EventNames values.",
	lastUpdated = {
		2026,
		5,
		28
	},
	eventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Moments,
	backendsList = {{
		type = "EventIngest",
		standardizedFields = v8,
		overrideName = function(t1: {[any]: any}) -- line: 69
			return t1.eventName
		end,
		format = function(t2: {[any]: any}, _: {[any]: any}) -- line: 72
			return t2.additionalInfo or {}
		end
	}}
})

local function fireAnalyticsEvent(p1, p2) -- line: 79
	-- upvalues: telemetryEmitter (copy), v9 (copy), FunnelEventActionList (copy), SessionManager (copy), fireFunnelAnalyticsEvent (copy)
	telemetryEmitter.emit(v9, {
		eventName = p1,
		additionalInfo = p2
	})

	local v16 = FunnelEventActionList[p1]

	if v16 ~= nil then
		for _, v18 in v16 do
			local v19 = SessionManager.getSessionId(v18.funnelType) or SessionManager.startSession(v18.funnelType)

			if v18.endSession then
				SessionManager.endSession(v18.funnelType)
			end

			if v18.stepKey ~= nil then
				fireFunnelAnalyticsEvent(v18.funnelType, v18.stepKey, v19)
			end
		end
	end
end

return fireAnalyticsEvent
