local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local React = require(parent.React)

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportAnalyticsContext)

local function useAnalyticsContext()
	return React.useContext(AbuseReportAnalyticsContext)
end

return useAnalyticsContext
