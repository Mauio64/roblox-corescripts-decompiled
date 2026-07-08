local Parent = script:FindFirstAncestor("Moments").Parent
local Analytics = require(Parent.MomentsCommon).Analytics
local FunnelEventNames = Analytics.FunnelEventNames

local function logCreateIntent(s1: string) -- line: 26
	-- upvalues: Analytics (copy), FunnelEventNames (copy)
	local v6 = Analytics.SessionManager.startSession(FunnelEventNames.FunnelTypes.CreationFlow)

	Analytics.fireFunnelAnalyticsEvent(FunnelEventNames.FunnelTypes.CreationFlow, FunnelEventNames.CreationFlowSteps.CreateIntent, v6, {
		source = s1
	})
	Analytics.fireAnalyticsEvent(Analytics.EventNames.MomentCreationStarted, {
		source = s1
	})
end

return logCreateIntent
