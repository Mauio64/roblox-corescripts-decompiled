local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Charts = require(parent.Charts)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local refreshChartsSortDetailGenre = Charts.refreshChartsSortDetailGenre

local function reportInvalidActionParams(p, message: string, propName: string?) -- 3 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.RefreshChartsSortDetail, message = message, propName = propName },
		p.appPage
	)
end

local function SduiRefreshChartsSortDetailAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		reportInvalidActionParams(p2, "Missing actionParams") -- inferred equivalent call
		return
	end

	assert(actionParams, "actionParams must exist")

	local configKey = p2.configKey

	if typeof(configKey) ~= "string" or configKey == "" then
		configKey = actionParams.configKey
	end

	if typeof(configKey) == "string" and configKey ~= "" then
		local selectedOption = actionParams.selectedOption

		if typeof(selectedOption) == "string" and selectedOption ~= "" then
			local loadTimer = SduiLoadTimer.createLoadTimer("ChartsSortDetail")
			loadTimer.start("refresh")

			local v = refreshChartsSortDetailGenre({
				configKey = configKey,
				selectedGenre = selectedOption,
				loadTimer = loadTimer
			})

			if not v then
				return nil
			end

			v:finally(function()
				loadTimer.logRefreshComplete()
			end)
			return v
		end

		reportInvalidActionParams(p2, `Invalid or missing selectedOption: {selectedOption}`, "selectedOption") -- inferred equivalent call
	else
		reportInvalidActionParams(p2, `Invalid or missing configKey: {configKey}`, "configKey") -- inferred equivalent call
	end
end

return SduiRefreshChartsSortDetailAction
