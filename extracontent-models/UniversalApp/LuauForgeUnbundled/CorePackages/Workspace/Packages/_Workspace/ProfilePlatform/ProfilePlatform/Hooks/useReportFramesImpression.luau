local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local ServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ServerTriggeredModals")
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local fetchPrompts = ServerTriggeredModals.fetchPrompts
local createProfileCompletionPromptsConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Utils.createProfileCompletionPromptsConfig
local fetchFramesPromptId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/fetchFramesPromptId")

local defineFastString = game:DefineFastString("ProfileFramesUpsellPromptType", "ProfileFramesUpsell")

local function useReportFramesImpression()
	React.useEffect(function()
		if reportPromptImpression then
			fetchFramesPromptId():andThen(function(p2)
				return reportPromptImpression(defineFastString, p2)
			end):andThen(function()
				fetchPrompts(createProfileCompletionPromptsConfig(), true)
			end):catch(function() end)
		end
	end, {})
end

return useReportFramesImpression
