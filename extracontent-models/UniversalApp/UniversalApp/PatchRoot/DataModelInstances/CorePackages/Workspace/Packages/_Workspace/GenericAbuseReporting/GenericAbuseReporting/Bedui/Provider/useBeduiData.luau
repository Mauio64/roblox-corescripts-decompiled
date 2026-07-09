local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportBeduiContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiContext)

local function useBeduiData() -- line: 7
	-- upvalues: React (copy), AbuseReportBeduiContext (copy)
	return React.useContext(AbuseReportBeduiContext)
end

return useBeduiData
