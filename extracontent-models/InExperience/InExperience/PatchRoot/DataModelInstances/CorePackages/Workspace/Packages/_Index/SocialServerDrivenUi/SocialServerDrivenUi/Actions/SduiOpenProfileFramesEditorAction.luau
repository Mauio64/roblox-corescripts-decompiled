local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getBooleanParam = SduiCoreSystem.SduiActionParams.getBooleanParam
local ServerTriggeredModals = require(parent.ServerTriggeredModals)
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local createProfileCompletionPromptsConfig = ProfilePlatformCommon.Utils.createProfileCompletionPromptsConfig

local FFlagSduiOpenProfileFramesEditorSkipImpression = require(SocialServerDrivenUi.Flags.FFlagSduiOpenProfileFramesEditorSkipImpression)

local defineFastString = game:DefineFastString("ProfileFramesEditorScreen", "EditProfileImageProfilePlatform")
local defineFastString2 = game:DefineFastString("ProfileFramesUpsellPromptType", "ProfileFramesUpsell")

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil
	local promptId

	if actionParams then
		promptId = actionParams.promptId
	end

	local v = FFlagSduiOpenProfileFramesEditorSkipImpression

	if v then
		if actionParams == nil then
			v = false
		else
			v = getBooleanParam(actionParams, "skipPromptImpression", false)
		end
	end

	if reportPromptImpression and not v then
		reportPromptImpression(defineFastString2, promptId):andThen(function()
			fetchPrompts(createProfileCompletionPromptsConfig(), true)
		end):catch(function() end)
	end

	p2.dependencies.getNavigation().navigate(defineFastString, { mode = "framesOnly" })
end
