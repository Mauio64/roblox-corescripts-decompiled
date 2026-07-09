local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseReportFormDataContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportFormDataContext)

local function useFormData() -- line: 7
	-- upvalues: React (copy), AbuseReportFormDataContext (copy)
	return React.useContext(AbuseReportFormDataContext)
end

return useFormData
