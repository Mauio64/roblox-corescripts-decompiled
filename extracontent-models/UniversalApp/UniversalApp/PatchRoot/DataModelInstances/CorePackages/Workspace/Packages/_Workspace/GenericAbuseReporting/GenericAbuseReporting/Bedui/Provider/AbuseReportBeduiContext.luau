local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportBeduiContextStatus = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes).AbuseReportBeduiContextStatus

return React.createContext({
	beduiData = nil,
	error = nil,
	status = AbuseReportBeduiContextStatus.Loading
})
