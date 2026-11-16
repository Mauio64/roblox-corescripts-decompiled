local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

require(parent.SduiCoreSystem)
local ServerTriggeredModals = require(parent.ServerTriggeredModals)
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local createProfileCompletionPromptsConfig = ProfilePlatformCommon.Utils.createProfileCompletionPromptsConfig

local defineFastString = game:DefineFastString("ProfileFramesEditorScreen", "EditProfileImageProfilePlatform")
local defineFastString2 = game:DefineFastString("ProfileFramesUpsellPromptType", "ProfileFramesUpsell")

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil
	local promptId

	if actionParams then
		promptId = actionParams.promptId
	end

	if reportPromptImpression then
		reportPromptImpression(defineFastString2, promptId):andThen(function()
			fetchPrompts(createProfileCompletionPromptsConfig(), true)
		end):catch(function() end)
	end

	p2.dependencies.getNavigation().navigate(defineFastString, { mode = "framesOnly" })
end
