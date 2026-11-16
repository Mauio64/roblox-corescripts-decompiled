local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

return function(p, _, data)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ApplyChartsFilter, message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	if data.configKey == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.ApplyChartsFilter,
				message = "Missing sduiContext.configKey; filter selections cannot be persisted in client page scope"
			},
			data.appPage
		)
		return
	end

	local filterSelections = actionParams.filterSelections

	local Charts = require(parent.Charts)
	getSduiClientPageScope(data.configKey).set(Charts.ChartsPageScopeFields.FilterSelections, filterSelections)

	local loadTimer = SduiLoadTimer.createLoadTimer("ChartsPage")
	loadTimer.start("filter_refetch")
	local chartsPage = Charts.fetchChartsPage(loadTimer, true)

	if chartsPage then
		chartsPage:finally(function()
			loadTimer.logRefreshComplete()
		end)
	end

	return chartsPage
end
