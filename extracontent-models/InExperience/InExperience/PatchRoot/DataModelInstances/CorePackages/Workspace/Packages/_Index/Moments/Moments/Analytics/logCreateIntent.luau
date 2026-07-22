local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsCommon = require(Parent.MomentsCommon)
local Analytics = MomentsCommon.Analytics
local FunnelEventNames = Analytics.FunnelEventNames
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs

local function logCreateIntent(s1: string) -- line: 32
	-- upvalues: Analytics (copy), FunnelEventNames (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy)
	local v8 = Analytics.SessionManager.startSession(FunnelEventNames.FunnelTypes.CreationFlow)

	Analytics.fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.CreationFlow, FunnelEventNames.CreationFlowSteps.CreateIntent, v8, {
		source = s1
	})

	local t1 = {
		source = s1
	}

	if GetFFlagMomentsAnalyticsProducerPrereqs() then
		t1.creationSessionId = v8
	end

	Analytics.fireAnalyticsEvent(Analytics.EventNames.MomentCreationStarted, t1)
end

return logCreateIntent
