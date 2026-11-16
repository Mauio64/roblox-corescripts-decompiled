local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)

local context = React.createContext(nil)
local AbuseReportAnalyticsContext = {}
AbuseReportAnalyticsContext.AbuseReportAnalyticsContext = context

function AbuseReportAnalyticsContext.AbuseReportAnalyticsProvider(p)
	return React.createElement(context.Provider, { value = p.analytics }, p.children)
end

function AbuseReportAnalyticsContext.useAbuseReportAnalytics()
	local v = React.useContext(context)

	if not v then
		error("Invalid use of `useAbuseReportAnalytics` hook. Ensure your component has an ancestor wrapped in `AbuseReportAnalyticsProvider`")
	end

	return v
end

function AbuseReportAnalyticsContext.useOptionalAbuseReportAnalytics()
	return React.useContext(context)
end

return AbuseReportAnalyticsContext
