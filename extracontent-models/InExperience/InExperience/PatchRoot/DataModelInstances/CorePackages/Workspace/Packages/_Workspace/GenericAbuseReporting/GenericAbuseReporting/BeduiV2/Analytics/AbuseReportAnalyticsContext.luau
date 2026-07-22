local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)

local v4 = React.createContext(nil)

return {
	AbuseReportAnalyticsContext = v4,
	AbuseReportAnalyticsProvider = function(t1: {[any]: any}) -- line: 25
		-- upvalues: React (copy), v4 (copy)
		return React.createElement(v4.Provider, {
			value = t1.analytics
		}, t1.children)
	end,
	useAbuseReportAnalytics = function() -- line: 36
		-- upvalues: React (copy), v4 (copy)
		local v6 = React.useContext(v4)

		if not v6 then
			error("Invalid use of `useAbuseReportAnalytics` hook. Ensure your component has an ancestor wrapped in `AbuseReportAnalyticsProvider`")
		end

		return v6
	end,
	useOptionalAbuseReportAnalytics = function() -- line: 52
		-- upvalues: React (copy), v4 (copy)
		return React.useContext(v4)
	end
}
