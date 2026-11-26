local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities")
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local reportPromptDismiss = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Actions/reportPromptDismiss")

local function SduiDismissPromptAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "DismissPrompt", message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local promptType = actionParams.promptType

	if typeof(promptType) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "DismissPrompt",
				message = `Invalid or missing promptType: {promptType}`,
				propName = "promptType"
			},
			p4.appPage
		)
		return
	end

	local promptId = actionParams.promptId

	if promptId ~= nil and typeof(promptId) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "DismissPrompt",
				message = `Invalid promptId: {promptId}`,
				propName = "promptId"
			},
			p4.appPage
		)
		return
	end

	local sduiApiStore = getSduiApiStore()
	local dismissEntry = sduiApiStore.dismissEntry(promptType)

	reportPromptDismiss(p4.dependencies.networking, promptType, promptId):andThen(function()
		for k, v5 in dismissEntry do
			sduiApiStore.refreshFromApi({
				configKey = v5,
				loadTimer = sduiLoadTimer.createLoadTimer(v5)
			})
		end
	end):catch(function(p5)
		p4.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissPrompt",
			message = "reportPromptDismiss failed: " .. sduiParseHelpers.stringifyValue(p5)
		}, p4.appPage)
	end)
end

return SduiDismissPromptAction
