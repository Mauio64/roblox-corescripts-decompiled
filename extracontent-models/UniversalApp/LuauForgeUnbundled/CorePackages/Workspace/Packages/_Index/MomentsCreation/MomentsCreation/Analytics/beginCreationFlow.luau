local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Analytics
local funnelEventNames = analytics.FunnelEventNames

local function beginCreationFlow(p2)
	local v5 = analytics.SessionManager.startSession(funnelEventNames.FunnelTypes.CreationFlow)
	analytics.fireFunnelAnalyticsEvent(
		funnelEventNames.FunnelTypes.CreationFlow,
		funnelEventNames.CreationFlowSteps.CreateIntent,
		v5,
		{ source = p2 }
	)

	local v6 = { source = p2 }
	v6.creationSessionId = v5
	analytics.fireAnalyticsEvent(analytics.EventNames.MomentCreationStarted, v6)
end

return beginCreationFlow
