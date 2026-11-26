local getBooleanParam = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").SduiActionParams.getBooleanParam
local ServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/ServerTriggeredModals")
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local fetchPrompts = ServerTriggeredModals.fetchPrompts

local createProfileCompletionPromptsConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/ProfilePlatformCommon").Utils.createProfileCompletionPromptsConfig

local FFlagSduiOpenProfileFramesEditorSkipImpression = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Flags/FFlagSduiOpenProfileFramesEditorSkipImpression")

local defineFastString = game:DefineFastString(
	"ProfileFramesEditorScreen",
	"EditProfileImageProfilePlatform"
)
local defineFastString2 = game:DefineFastString("ProfileFramesUpsellPromptType", "ProfileFramesUpsell")

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil
	local promptId = if actionParams then actionParams.promptId else nil

	local v5 = FFlagSduiOpenProfileFramesEditorSkipImpression

	if v5 then
		v5 = not (actionParams == nil) and getBooleanParam(actionParams, "skipPromptImpression", false)
	end

	if reportPromptImpression and not v5 then
		reportPromptImpression(defineFastString2, promptId):andThen(function()
			fetchPrompts(createProfileCompletionPromptsConfig(), true)
		end):catch(function() end)
	end

	p4.dependencies.getNavigation().navigate(defineFastString, { mode = "framesOnly" })
end
