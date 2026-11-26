local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Cryo")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SocialLuaAnalytics")

local FunnelEventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/FunnelEventNames")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/Types")
local realtimeTelemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/realtimeTelemetryEmitter")

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "MomentsFunnelStep",
	description = "Moments funnel-step events ported from moments-repo. funnelName/funnelSessionId/stepNumber/stepName plus any customFields are emitted as top-level EventIngest columns so downstream funnel reconstruction continues to work.",
	lastUpdated = { 2026, 5, 28 },
	eventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Moments,
	backendsList = {
		{
			type = "EventIngest",
			standardizedFields = { "addSessionInfo", "addSessionId" },
			format = function(data, p2)
				return Cryo.Dictionary.join(data.customFields or {}, {
					funnelName = data.funnelName,
					funnelSessionId = data.funnelSessionId,
					stepNumber = data.stepNumber,
					stepName = data.stepName
				})
			end
		}
	}
})

local function fireFunnelAnalyticsEvent(p2, p3, p4, p5)
	local funnelStep = FunnelEventNames.FunnelSteps[p2]

	if not funnelStep then
		warn(`[Moments] Unknown funnel type: {p2}`)
		return
	end

	local v5 = funnelStep[p3]

	if v5 then
		realtimeTelemetryEmitter.emit(telemetry, {
			funnelName = p2,
			funnelSessionId = p4,
			stepNumber = v5.stepNumber,
			stepName = v5.stepName,
			customFields = p5
		})
	else
		warn(`[Moments] Unknown funnel step '{p3}' for funnel '{p2}'`)
	end
end

return fireFunnelAnalyticsEvent
