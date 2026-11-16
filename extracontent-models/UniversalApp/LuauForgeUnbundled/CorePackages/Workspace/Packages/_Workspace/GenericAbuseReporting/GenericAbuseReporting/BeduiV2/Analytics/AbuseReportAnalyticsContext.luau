local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")

local context = React.createContext(nil)

return {
	AbuseReportAnalyticsContext = context,
	AbuseReportAnalyticsProvider = function(p2)
		return React.createElement(context.Provider, { value = p2.analytics }, p2.children)
	end,
	useAbuseReportAnalytics = function()
		local v5 = React.useContext(context)

		if not v5 then
			error("Invalid use of `useAbuseReportAnalytics` hook. Ensure your component has an ancestor wrapped in `AbuseReportAnalyticsProvider`")
		end

		return v5
	end,
	useOptionalAbuseReportAnalytics = function()
		return React.useContext(context)
	end
}
