local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)

return {
	componentType = "dropdown",
	fieldLabel = "ReasonForAbuse",
	componentName = "AbuseReason",
	getIsVisible = function(_) -- line: 7
		return true
	end,
	getMenuItems = function(_) -- line: 10
		return {}
	end,
	onUpdateSelectedOption = function(_, _) -- line: 13
	end,
	readonlyValue = Constants.InappropriateContentAbuseReason
}
