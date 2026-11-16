local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportAnalyticsContext)
require(GenericAbuseReporting.Enums.AbuseVector)
require(GenericAbuseReporting.Bedui.Utils.BeduiAnalytics)

local function AbuseReportAnalyticsProvider(p)
	local state, setState = React.useState(false)

	return React.createElement(AbuseReportAnalyticsContext.Provider, {
		value = {
			abuseVector = p.abuseVector,
			isReportSubmitted = state,
			setIsReportSubmitted = setState
		}
	}, p.children)
end

return AbuseReportAnalyticsProvider
