local ExpChat = script:FindFirstAncestor("ExpChat")

local FFlagExpChatPresetChatAutocompleteEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatAutocompleteEnabled)

return game:DefineFastFlag("ExpChatPresetChatAutocompleteAnalyticsEnabled", false)
	and FFlagExpChatPresetChatAutocompleteEnabled
