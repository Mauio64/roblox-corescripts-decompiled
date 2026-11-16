local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Cryo = require(parent.Cryo)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local FunnelEventNames = require(MomentsCommon.Analytics.FunnelEventNames)
require(MomentsCommon.Analytics.Types)
local telemetryEmitter = require(MomentsCommon.Analytics.telemetryEmitter)

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "MomentsFunnelStep",
	description = "Moments funnel-step events ported from moments-repo. funnelName/funnelSessionId/stepNumber/stepName plus any customFields are emitted as top-level EventIngest columns so downstream funnel reconstruction continues to work.",
	lastUpdated = { 2026, 5, 28 },
	eventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Moments,
	backendsList = {
		{
			type = "EventIngest",
			standardizedFields = { "addSessionInfo", "addSessionId" },
			format = function(self, _)
				return Cryo.Dictionary.join(self.customFields or {}, {
					funnelName = self.funnelName,
					funnelSessionId = self.funnelSessionId,
					stepNumber = self.stepNumber,
					stepName = self.stepName
				})
			end
		}
	}
})

local function fireFunnelAnalyticsEvent(funnelName, p, funnelSessionId: string, customFields)
	local funnelStep = FunnelEventNames.FunnelSteps[funnelName]

	if not funnelStep then
		warn(`[Moments] Unknown funnel type: {funnelName}`)
		return
	end

	local v = funnelStep[p]

	if v then
		telemetryEmitter.emit(telemetry, {
			funnelName = funnelName,
			funnelSessionId = funnelSessionId,
			stepNumber = v.stepNumber,
			stepName = v.stepName,
			customFields = customFields
		})
	else
		warn(`[Moments] Unknown funnel step '{p}' for funnel '{funnelName}'`)
	end
end

return fireFunnelAnalyticsEvent
