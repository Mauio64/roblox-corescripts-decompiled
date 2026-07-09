local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportAnalyticsContext)

local function useAnalyticsContext() -- line: 7
	-- upvalues: React (copy), AbuseReportAnalyticsContext (copy)
	return React.useContext(AbuseReportAnalyticsContext)
end

return useAnalyticsContext
