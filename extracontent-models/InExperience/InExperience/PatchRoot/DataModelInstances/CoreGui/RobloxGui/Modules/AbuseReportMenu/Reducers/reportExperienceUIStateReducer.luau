local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local Constants = require(AbuseReportMenu.Components.Constants)
require(AbuseReportMenu.Components.Types)
local PlayerMenuActions = Constants.PlayerMenuActions

local function reportExperienceUIStateReducer(p, p2)
	local clone = table.clone(p)

	if p2.type == PlayerMenuActions.UpdateComment then
		clone.comment = p2.comment
	end

	return clone
end

return reportExperienceUIStateReducer
