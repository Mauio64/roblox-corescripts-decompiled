local parent = script:FindFirstAncestor("SocialBlockingModal").Parent

local React = require(parent.React)

local AnalyticsSetup = require(script.Parent.AnalyticsSetup)

local function useSocialBlockingModalAnalytics(infoForAllEvents)
	return (React.useMemo(function()
		return AnalyticsSetup({ infoForAllEvents = infoForAllEvents })
	end, { infoForAllEvents }))
end

return useSocialBlockingModalAnalytics
