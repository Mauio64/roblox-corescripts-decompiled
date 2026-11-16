local PromptsServerDrivenUi = script:FindFirstAncestor("PromptsServerDrivenUi")
local parent = PromptsServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiSharedContent = require(parent.SduiSharedContent)
local reportPromptDismiss = SduiSharedContent.reportPromptDismiss
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDismissPromptPageScope = SharedFlags.FFlagSduiDismissPromptPageScope
local setPromptDismissedInPageScope = require(PromptsServerDrivenUi.Actions.setPromptDismissedInPageScope)

local function SduiDismissPromptAction(p, _, data)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "DismissPrompt", message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local promptType = actionParams.promptType

	if typeof(promptType) ~= "string" then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
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
			SduiErrorType.InvalidActionParams,
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

	if FFlagSduiDismissPromptPageScope then
		local configKey = data.configKey

		if typeof(configKey) == "string" and configKey ~= "" then
			setPromptDismissedInPageScope(configKey, promptType)
		elseif #dismissEntry == 0 then
			data.dependencies.logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = "DismissPrompt",
					message = "Missing sduiContext.configKey for page-scope dismiss"
				},
				data.appPage
			)
		end
	end

	reportPromptDismiss(data.dependencies.networking, promptType, promptId):andThen(function()
		for _, configKey in dismissEntry do
			sduiApiStore.refreshFromApi({
				configKey = configKey,
				loadTimer = SduiLoadTimer.createLoadTimer(configKey)
			})
		end
	end):catch(function(p2)
		data.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissPrompt",
			message = "reportPromptDismiss failed: " .. SduiParseHelpers.stringifyValue(p2)
		}, data.appPage)
	end)
end

return SduiDismissPromptAction
