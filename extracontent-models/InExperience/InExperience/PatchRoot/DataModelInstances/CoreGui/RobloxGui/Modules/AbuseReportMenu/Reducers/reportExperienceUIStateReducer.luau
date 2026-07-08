local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

local PlayerMenuActions = Constants.PlayerMenuActions

local function reportExperienceUIStateReducer(p1, p2) -- line: 6
	-- upvalues: PlayerMenuActions (copy)
	local v7 = table.clone(p1)

	if p2.type == PlayerMenuActions.UpdateComment then
		v7.comment = p2.comment
	end

	return v7
end

return reportExperienceUIStateReducer
