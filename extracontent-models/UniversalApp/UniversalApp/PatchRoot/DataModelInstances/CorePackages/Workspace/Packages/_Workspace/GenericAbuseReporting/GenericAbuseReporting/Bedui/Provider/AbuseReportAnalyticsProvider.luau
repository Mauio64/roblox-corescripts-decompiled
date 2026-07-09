local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportAnalyticsContext)

require(GenericAbuseReporting.Enums.AbuseVector)
require(GenericAbuseReporting.Bedui.Utils.BeduiAnalytics)

local function AbuseReportAnalyticsProvider(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), AbuseReportAnalyticsContext (copy)
	local v7, v8 = React.useState(false)

	return React.createElement(AbuseReportAnalyticsContext.Provider, {
		value = {
			abuseVector = t1.abuseVector,
			isReportSubmitted = v7,
			setIsReportSubmitted = v8
		}
	}, t1.children)
end

return AbuseReportAnalyticsProvider
