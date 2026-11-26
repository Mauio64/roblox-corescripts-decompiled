local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").SduiLoadTimer
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

return function(p2, p3, data)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ApplyChartsFilter,
				message = "Missing actionParams"
			},
			data.appPage
		)
		return
	end

	if data.configKey == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ApplyChartsFilter,
				message = "Missing sduiContext.configKey; filter selections cannot be persisted in client page scope"
			},
			data.appPage
		)
		return
	end

	local filterSelections = actionParams.filterSelections

	local Charts = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Charts")
	getSduiClientPageScope(data.configKey).set(
		Charts.ChartsPageScopeFields.FilterSelections,
		filterSelections
	)

	local loadTimer = sduiLoadTimer.createLoadTimer("ChartsPage")
	loadTimer.start("filter_refetch")
	local chartsPage = Charts.fetchChartsPage(loadTimer, true)

	if chartsPage then
		chartsPage:finally(function()
			loadTimer.logRefreshComplete()
		end)
	end

	return chartsPage
end
