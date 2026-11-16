local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local abuseReportBeduiContextStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes").AbuseReportBeduiContextStatus

return React.createContext({
	status = abuseReportBeduiContextStatus.Loading,
	beduiData = nil,
	error = nil
})
