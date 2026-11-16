require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local ServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/ServerTriggeredModals")
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local createProfileCompletionPromptsConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/ProfilePlatformCommon").Utils.createProfileCompletionPromptsConfig

local defineFastString = game:DefineFastString(
	"ProfileFramesEditorScreen",
	"EditProfileImageProfilePlatform"
)
local defineFastString2 = game:DefineFastString("ProfileFramesUpsellPromptType", "ProfileFramesUpsell")

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil
	local promptId = if actionParams then actionParams.promptId else nil

	if reportPromptImpression then
		reportPromptImpression(defineFastString2, promptId):andThen(function()
			fetchPrompts(createProfileCompletionPromptsConfig(), true)
		end):catch(function() end)
	end

	p4.dependencies.getNavigation().navigate(defineFastString, { mode = "framesOnly" })
end
