local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Cryo = require(MomentsCommonParent.Cryo)
local SocialLuaAnalytics = require(MomentsCommonParent.SocialLuaAnalytics)
local FunnelEventNames = require(MomentsCommon.Analytics.FunnelEventNames)

require(MomentsCommon.Analytics.Types)

local telemetryEmitter = require(MomentsCommon.Analytics.telemetryEmitter)
local v7 = if not require(MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs)() then nil else {
	"addSessionInfo",
	"addSessionId"
}
local v8 = SocialLuaAnalytics.Telemetry.new({
	name = "MomentsFunnelStep",
	description = "Moments funnel-step events ported from moments-repo. funnelName/funnelSessionId/stepNumber/stepName plus any customFields are emitted as top-level EventIngest columns so downstream funnel reconstruction continues to work.",
	lastUpdated = {
		2026,
		5,
		28
	},
	eventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Moments,
	backendsList = {{
		type = "EventIngest",
		standardizedFields = v7,
		format = function(t1: {[any]: any}, _: {[any]: any}) -- line: 67
			-- upvalues: Cryo (copy)
			return Cryo.Dictionary.join(t1.customFields or {}, {
				funnelName = t1.funnelName,
				funnelSessionId = t1.funnelSessionId,
				stepNumber = t1.stepNumber,
				stepName = t1.stepName
			})
		end
	}}
})

local function fireFunnelAnalyticsEvent(p1, p2, s1: string, p3) -- line: 85
	-- upvalues: FunnelEventNames (copy), telemetryEmitter (copy), v8 (copy)
	local v16 = FunnelEventNames.FunnelSteps[p1]

	if not v16 then
		warn(`[Moments] Unknown funnel type: { p1 }`)

		return
	end

	local v17 = v16[p2]

	if not v17 then
		warn(`[Moments] Unknown funnel step '{ p2 }' for funnel '{ p1 }'`)

		return
	end

	telemetryEmitter.emit(v8, {
		funnelName = p1,
		funnelSessionId = s1,
		stepNumber = v17.stepNumber,
		stepName = v17.stepName,
		customFields = p3
	})
end

return fireFunnelAnalyticsEvent
