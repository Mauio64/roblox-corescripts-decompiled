local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local reportPromptDismiss = require(SduiSharedContent.Actions.reportPromptDismiss)

local function SduiDismissPromptAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "DismissPrompt", message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local promptType = actionParams.promptType

	if typeof(promptType) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "DismissPrompt",
				message = `Invalid or missing promptType: {promptType}`,
				propName = "promptType"
			},
			p2.appPage
		)
		return
	end

	local promptId = actionParams.promptId

	if promptId ~= nil and typeof(promptId) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "DismissPrompt",
				message = `Invalid promptId: {promptId}`,
				propName = "promptId"
			},
			p2.appPage
		)
		return
	end

	local sduiApiStore = getSduiApiStore()
	local dismissEntry = sduiApiStore.dismissEntry(promptType)

	reportPromptDismiss(p2.dependencies.networking, promptType, promptId):andThen(function()
		for _, configKey in dismissEntry do
			sduiApiStore.refreshFromApi({
				configKey = configKey,
				loadTimer = SduiLoadTimer.createLoadTimer(configKey)
			})
		end
	end):catch(function(p3)
		p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissPrompt",
			message = "reportPromptDismiss failed: " .. SduiParseHelpers.stringifyValue(p3)
		}, p2.appPage)
	end)
end

return SduiDismissPromptAction
