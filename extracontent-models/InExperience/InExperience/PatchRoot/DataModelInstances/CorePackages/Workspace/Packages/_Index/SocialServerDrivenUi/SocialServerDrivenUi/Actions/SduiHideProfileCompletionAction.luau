local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local createProfileCompletionPromptsConfig = require(Parent.ProfilePlatformCommon).Utils.createProfileCompletionPromptsConfig
local ServerTriggeredModals = require(Parent.ServerTriggeredModals)
local fetchPrompts = ServerTriggeredModals.fetchPrompts
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local SetCurrentToastMessage = require(Parent.ToastRodux).Actions.SetCurrentToastMessage

return function(p1, _, p3, _) -- line: 21
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), reportPromptImpression (copy), fetchPrompts (copy), createProfileCompletionPromptsConfig (copy), SetCurrentToastMessage (copy)
	local v14 = p1 and p1.actionParams or nil

	if v14 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.HideProfileCompletion
		}, p3.appPage)

		return
	end

	local promptType = v14.promptType

	if promptType == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParam: promptType",
			propName = "promptType",
			name = SduiActionType.HideProfileCompletion
		}, p3.appPage)

		return
	end

	local promptId = v14.promptId

	reportPromptImpression(promptType, promptId):andThen(function() -- line: 49
		-- upvalues: fetchPrompts (copy), createProfileCompletionPromptsConfig (copy)
		fetchPrompts(createProfileCompletionPromptsConfig(), true)
	end):catch(function() -- line: 52
		-- upvalues: p3 (copy), SetCurrentToastMessage (copy)
		p3.dependencies.dispatch(SetCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
		}))
	end)
end
