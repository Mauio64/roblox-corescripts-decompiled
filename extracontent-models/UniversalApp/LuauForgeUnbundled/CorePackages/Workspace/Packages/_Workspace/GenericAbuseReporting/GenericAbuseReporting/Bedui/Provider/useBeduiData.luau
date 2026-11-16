local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AbuseReportBeduiContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiContext")

local function useBeduiData()
	return React.useContext(AbuseReportBeduiContext)
end

return useBeduiData
