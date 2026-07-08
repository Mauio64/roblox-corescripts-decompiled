local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)

return {
	componentType = "freeComments",
	componentName = "FreeComments",
	getIsVisible = function(_) -- line: 7
		return true
	end,
	onUpdate = function(s1: string, _, p3, p4) -- line: 10
		-- upvalues: Constants (copy)
		p4.analyticsDispatch({
			type = Constants.AnalyticsActions.SetCommentAdded,
			commentAdded = #s1 > 0
		})
		p3({
			type = Constants.PlayerMenuActions.UpdateComment,
			comment = s1
		})
	end
}
