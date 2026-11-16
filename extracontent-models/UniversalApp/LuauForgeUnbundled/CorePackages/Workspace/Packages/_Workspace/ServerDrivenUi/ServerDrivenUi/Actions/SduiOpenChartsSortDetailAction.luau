local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local navigateToChartsSortDetailPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Charts").navigateToChartsSortDetailPage

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenChartsSortDetail,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local sortId = actionParams.sortId or actionParams.sort_id

	if sortId == nil or sortId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenChartsSortDetail, message = "Missing sortId" },
			p4.appPage
		)
	else
		navigateToChartsSortDetailPage(p4.dependencies.getNavigation(), {
			sortId = sortId,
			pageContext = p4.appPage
		})
	end
end
