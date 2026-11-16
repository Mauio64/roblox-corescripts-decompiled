local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local Charts = require(parent.Charts)
local navigateToChartsSortDetailPage = Charts.navigateToChartsSortDetailPage

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenChartsSortDetail, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local sortId = actionParams.sortId or actionParams.sort_id

	if sortId == nil or sortId == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenChartsSortDetail, message = "Missing sortId" },
			p2.appPage
		)
	else
		navigateToChartsSortDetailPage(p2.dependencies.getNavigation(), {
			sortId = sortId,
			pageContext = p2.appPage
		})
	end
end
