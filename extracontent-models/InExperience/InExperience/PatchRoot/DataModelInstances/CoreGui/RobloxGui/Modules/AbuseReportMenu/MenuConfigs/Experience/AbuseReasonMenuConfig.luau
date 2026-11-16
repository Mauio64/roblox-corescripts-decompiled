local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)
local AbuseReasonMenuConfig = {}
AbuseReasonMenuConfig.componentType = "dropdown"

function AbuseReasonMenuConfig.getIsVisible(_): boolean
	return true
end

function AbuseReasonMenuConfig.getMenuItems(_)
	return {}
end

function AbuseReasonMenuConfig.onUpdateSelectedOption(_, _) end
AbuseReasonMenuConfig.readonlyValue = Constants.InappropriateContentAbuseReason
AbuseReasonMenuConfig.fieldLabel = "ReasonForAbuse"
AbuseReasonMenuConfig.componentName = "AbuseReason"
return AbuseReasonMenuConfig
