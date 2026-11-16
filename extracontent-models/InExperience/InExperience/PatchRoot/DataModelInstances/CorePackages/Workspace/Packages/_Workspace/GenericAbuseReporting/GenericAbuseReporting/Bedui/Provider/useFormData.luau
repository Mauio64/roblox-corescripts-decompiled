local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local React = require(parent.React)

local AbuseReportFormDataContext = require(GenericAbuseReporting.Bedui.Provider.AbuseReportFormDataContext)

local function useFormData()
	return React.useContext(AbuseReportFormDataContext)
end

return useFormData
