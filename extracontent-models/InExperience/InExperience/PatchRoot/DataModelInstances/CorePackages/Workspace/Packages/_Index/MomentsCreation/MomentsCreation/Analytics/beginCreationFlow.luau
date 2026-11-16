local parent = script:FindFirstAncestor("MomentsCreation").Parent

local MomentsCommon = require(parent.MomentsCommon)

local Analytics = MomentsCommon.Analytics
local FunnelEventNames = Analytics.FunnelEventNames

local function beginCreationFlow(source: string)
	local creationSessionId = Analytics.SessionManager.startSession(FunnelEventNames.FunnelTypes.CreationFlow)
	Analytics.fireFunnelAnalyticsEvent(
		FunnelEventNames.FunnelTypes.CreationFlow,
		FunnelEventNames.CreationFlowSteps.CreateIntent,
		creationSessionId,
		{ source = source }
	)

	local v = { source = source }
	v.creationSessionId = creationSessionId
	Analytics.fireAnalyticsEvent(Analytics.EventNames.MomentCreationStarted, v)
end

return beginCreationFlow
