local BuildExperience = script:FindFirstAncestor("BuildExperience")
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)

local defineFastInt = game:DefineFastInt("BuildExperienceAssistantStatusSwapIntervalSeconds", 10)

local defineFastInt2 = game:DefineFastInt("BuildExperienceAssistantThinkingDurationSuffixDelaySeconds", 10)
local defineFastInt3 = game:DefineFastInt("BuildExperiencePromptStallSeconds", 20)

return {
	BUILD_CHAT_PAGE_TITLE = LocalizationStrings.CHAT_BUILD_CHAT_PAGE_TITLE,
	ASSISTANT_LOADING_TEXT = LocalizationStrings.CHAT_ASSISTANT_LOADING,
	ASSISTANT_STILL_WORKING_TEXT = LocalizationStrings.CHAT_ASSISTANT_STILL_WORKING,
	ASSISTANT_STATUS_SWAP_INTERVAL_SECONDS = defineFastInt,
	ASSISTANT_THINKING_DURATION_SUFFIX_DELAY_SECONDS = defineFastInt2,
	PROMPT_STALL_SECONDS = defineFastInt3,
	CAS_RPC_TIMEOUT_SECONDS = 30,
	MESSAGE_LAYOUT_ORDER_STRIDE = FFlagBuildAdUpsell and 10 or 1,
	THINKING_GRADIENT_ANIMATION_SPEED = 1.4,
	THINKING_GRADIENT_OFFSET = 3,
	BOTTOM_SCROLL_THRESHOLD = 24,
	PUBLISH_PLACE_TOOL_IDENTIFIERS = { "studio_save_and_publish", "cas_save_and_publish" }
}
