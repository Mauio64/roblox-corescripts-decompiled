local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportAnalyticsContext")

local function useAnalyticsContext()
	return React.useContext(AbuseReportAnalyticsContext)
end

return useAnalyticsContext
