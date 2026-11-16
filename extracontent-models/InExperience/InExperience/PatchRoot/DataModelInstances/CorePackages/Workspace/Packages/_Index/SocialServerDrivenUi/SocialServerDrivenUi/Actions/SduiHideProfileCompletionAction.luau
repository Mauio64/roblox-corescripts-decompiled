local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local createProfileCompletionPromptsConfig = ProfilePlatformCommon.Utils.createProfileCompletionPromptsConfig

local ServerTriggeredModals = require(parent.ServerTriggeredModals)
local fetchPrompts = ServerTriggeredModals.fetchPrompts
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.HideProfileCompletion, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local promptType = actionParams.promptType

	if promptType == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.HideProfileCompletion,
				message = "Missing actionParam: promptType",
				propName = "promptType"
			},
			p2.appPage
		)
	else
		reportPromptImpression(promptType, actionParams.promptId):andThen(function()
			fetchPrompts(createProfileCompletionPromptsConfig(), true)
		end):catch(function()
			p2.dependencies.dispatch(SetCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
			}))
		end)
	end
end
