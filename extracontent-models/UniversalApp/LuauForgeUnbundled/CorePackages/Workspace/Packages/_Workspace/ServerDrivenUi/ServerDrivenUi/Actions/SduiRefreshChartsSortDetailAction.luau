local Charts = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Charts")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities")

local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local refreshChartsSortDetailGenre = Charts.refreshChartsSortDetailGenre

local function reportInvalidActionParams(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.RefreshChartsSortDetail, message = p3, propName = p4 },
		p2.appPage
	)
end

local function SduiRefreshChartsSortDetailAction(p2, p3, data)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshChartsSortDetail,
				message = "Missing actionParams",
				propName = nil
			},
			data.appPage
		)

		return
	end

	assert(actionParams, "actionParams must exist")

	local configKey = data.configKey

	if typeof(configKey) ~= "string" or configKey == "" then
		configKey = actionParams.configKey
	end

	if typeof(configKey) == "string" and configKey ~= "" then
		local selectedOption = actionParams.selectedOption

		if typeof(selectedOption) == "string" and selectedOption ~= "" then
			local loadTimer = sduiLoadTimer.createLoadTimer("ChartsSortDetail")
			loadTimer.start("refresh")

			local v5 = refreshChartsSortDetailGenre({
				configKey = configKey,
				selectedGenre = selectedOption,
				loadTimer = loadTimer
			})

			if not v5 then
				return nil
			end

			v5:finally(function()
				loadTimer.logRefreshComplete()
			end)
			return v5
		else
			local formatted = `Invalid or missing selectedOption: {selectedOption}`
			data.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.RefreshChartsSortDetail,
					message = formatted,
					propName = "selectedOption"
				},
				data.appPage
			)
		end
	else
		local formatted = `Invalid or missing configKey: {configKey}`
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RefreshChartsSortDetail,
				message = formatted,
				propName = "configKey"
			},
			data.appPage
		)
	end
end

return SduiRefreshChartsSortDetailAction
