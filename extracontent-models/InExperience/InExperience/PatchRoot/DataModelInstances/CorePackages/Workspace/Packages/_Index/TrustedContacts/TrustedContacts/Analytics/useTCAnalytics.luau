local parent = script:FindFirstAncestor("TrustedContacts").Parent

local React = require(parent.React)

local AnalyticsSetup = require(script.Parent.AnalyticsSetup)

local function useTCAnalytics(infoForAllEvents)
	return (React.useMemo(function()
		return AnalyticsSetup({ infoForAllEvents = infoForAllEvents })
	end, { infoForAllEvents }))
end

return useTCAnalytics
