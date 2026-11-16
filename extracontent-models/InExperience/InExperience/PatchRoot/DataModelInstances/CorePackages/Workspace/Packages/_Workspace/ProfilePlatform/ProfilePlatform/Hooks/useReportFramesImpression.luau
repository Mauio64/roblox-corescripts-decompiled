local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)

local ServerTriggeredModals = require(parent.ServerTriggeredModals)
local reportPromptImpression = ServerTriggeredModals.reportPromptImpression
local fetchPrompts = ServerTriggeredModals.fetchPrompts
local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local createProfileCompletionPromptsConfig = ProfilePlatformCommon.Utils.createProfileCompletionPromptsConfig
local fetchFramesPromptId = require(ProfilePlatform.Hooks.fetchFramesPromptId)

local defineFastString = game:DefineFastString("ProfileFramesUpsellPromptType", "ProfileFramesUpsell")

local function useReportFramesImpression()
	React.useEffect(function()
		if reportPromptImpression then
			fetchFramesPromptId():andThen(function(p)
				return reportPromptImpression(defineFastString, p)
			end):andThen(function()
				fetchPrompts(createProfileCompletionPromptsConfig(), true)
			end):catch(function() end)
		end
	end, {})
end

return useReportFramesImpression
