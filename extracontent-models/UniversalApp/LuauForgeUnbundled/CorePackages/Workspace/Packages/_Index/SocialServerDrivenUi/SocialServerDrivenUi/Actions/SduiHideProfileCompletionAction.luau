local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local createProfileCompletionPromptsConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/ProfilePlatformCommon").Utils.createProfileCompletionPromptsConfig

local ServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/ServerTriggeredModals")
local fetchPrompts = ServerTriggeredModals.fetchPrompts
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression

local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/ToastRodux").Actions.SetCurrentToastMessage

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.HideProfileCompletion,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local promptType = actionParams.promptType

	if promptType == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.HideProfileCompletion,
				message = "Missing actionParam: promptType",
				propName = "promptType"
			},
			p4.appPage
		)
		return
	end

	reportPromptImpression(promptType, actionParams.promptId):andThen(function()
		fetchPrompts(createProfileCompletionPromptsConfig(), true)
	end):catch(function()
		p4.dependencies.dispatch(setCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
		}))
	end)
end
