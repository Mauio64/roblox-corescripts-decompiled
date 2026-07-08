local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local navigateToChartsSortDetailPage = require(Parent.Charts).navigateToChartsSortDetailPage
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p1, _, p3, _) -- line: 14
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), navigateToChartsSortDetailPage (copy)
	local v10 = p1 and p1.actionParams or nil

	if v10 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenChartsSortDetail
		}, p3.appPage)

		return
	end

	local v11 = v10.sortId or v10.sort_id

	if v11 == nil or v11 == "" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing sortId",
			name = SduiActionType.OpenChartsSortDetail
		}, p3.appPage)

		return
	end

	navigateToChartsSortDetailPage(p3.dependencies.getNavigation(), {
		sortId = v11,
		pageContext = p3.appPage
	})
end
