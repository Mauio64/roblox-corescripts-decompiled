local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiSharedUtilities")
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local reportPromptDismiss = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SduiSharedContent").reportPromptDismiss
local fFlagSduiDismissPromptPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/PromptsServerDrivenUi/SharedFlags").FFlagSduiDismissPromptPageScope
local setPromptDismissedInPageScope = require("@game/CorePackages/Workspace/Packages/_Index/PromptsServerDrivenUi/PromptsServerDrivenUi/Actions/setPromptDismissedInPageScope")

local function SduiDismissPromptAction(p2, p3, data)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "DismissPrompt", message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local promptType = actionParams.promptType

	if typeof(promptType) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "DismissPrompt",
				message = `Invalid or missing promptType: {promptType}`,
				propName = "promptType"
			},
			data.appPage
		)
		return
	end

	local promptId = actionParams.promptId

	if promptId ~= nil and typeof(promptId) ~= "string" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "DismissPrompt",
				message = `Invalid promptId: {promptId}`,
				propName = "promptId"
			},
			data.appPage
		)
		return
	end

	local sduiApiStore = getSduiApiStore()
	local dismissEntry = sduiApiStore.dismissEntry(promptType)

	if fFlagSduiDismissPromptPageScope then
		local configKey = data.configKey

		if typeof(configKey) == "string" and configKey ~= "" then
			setPromptDismissedInPageScope(configKey, promptType)
		elseif #dismissEntry == 0 then
			data.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = "DismissPrompt",
					message = "Missing sduiContext.configKey for page-scope dismiss"
				},
				data.appPage
			)
		end
	end

	reportPromptDismiss(data.dependencies.networking, promptType, promptId):andThen(function()
		for k, v5 in dismissEntry do
			sduiApiStore.refreshFromApi({
				configKey = v5,
				loadTimer = sduiLoadTimer.createLoadTimer(v5)
			})
		end
	end):catch(function(p4)
		data.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissPrompt",
			message = "reportPromptDismiss failed: " .. sduiParseHelpers.stringifyValue(p4)
		}, data.appPage)
	end)
end

return SduiDismissPromptAction
