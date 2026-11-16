local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)
local FreeFormCommentMenuConfig = {}
FreeFormCommentMenuConfig.componentType = "freeComments"

function FreeFormCommentMenuConfig.getIsVisible(_): boolean
	return true
end

function FreeFormCommentMenuConfig.onUpdate(comment: string, _, callback, p)
	p.analyticsDispatch({
		type = Constants.AnalyticsActions.SetCommentAdded,
		commentAdded = #comment > 0
	})

	callback({ type = Constants.PlayerMenuActions.UpdateComment, comment = comment })
end

FreeFormCommentMenuConfig.componentName = "FreeComments"
return FreeFormCommentMenuConfig
