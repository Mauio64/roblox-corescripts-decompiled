local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/BeduiAnalytics")

local function AbuseReportAnalyticsProvider(p2)
	local state, setState = React.useState(false)

	return React.createElement(AbuseReportAnalyticsContext.Provider, {
		value = {
			abuseVector = p2.abuseVector,
			isReportSubmitted = state,
			setIsReportSubmitted = setState
		}
	}, p2.children)
end

return AbuseReportAnalyticsProvider
