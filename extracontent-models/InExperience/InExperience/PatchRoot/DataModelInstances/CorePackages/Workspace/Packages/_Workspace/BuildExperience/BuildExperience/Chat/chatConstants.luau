local BuildExperience = script:FindFirstAncestor("BuildExperience")
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local v3 = game:DefineFastInt("BuildExperienceAssistantStatusSwapIntervalSeconds", 10)
local v4 = game:DefineFastInt("BuildExperienceAssistantThinkingDurationSuffixDelaySeconds", 10)

return {
	CAS_RPC_TIMEOUT_SECONDS = 30,
	THINKING_GRADIENT_ANIMATION_SPEED = 1.4,
	THINKING_GRADIENT_OFFSET = 3,
	BOTTOM_SCROLL_THRESHOLD = 24,
	BUILD_CHAT_PAGE_TITLE = LocalizationStrings.CHAT_BUILD_CHAT_PAGE_TITLE,
	ASSISTANT_LOADING_TEXT = LocalizationStrings.CHAT_ASSISTANT_LOADING,
	ASSISTANT_STILL_WORKING_TEXT = LocalizationStrings.CHAT_ASSISTANT_STILL_WORKING,
	formatAssistantLoadingText = LocalizationStrings.formatChatThinkingDuration,
	ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = v3,
	ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS = v4,
	PUBLISH_PLACE_TOOL_IDENTIFIERS = {
		"studio_save_and_publish",
		"cas_save_and_publish"
	}
}
