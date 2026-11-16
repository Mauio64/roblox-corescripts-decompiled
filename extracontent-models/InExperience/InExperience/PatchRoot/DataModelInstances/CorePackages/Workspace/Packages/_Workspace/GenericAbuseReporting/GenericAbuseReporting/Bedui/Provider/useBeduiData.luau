local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local React = require(parent.React)

local AbuseReportBeduiContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiContext)

local function useBeduiData()
	return React.useContext(AbuseReportBeduiContext)
end

return useBeduiData
