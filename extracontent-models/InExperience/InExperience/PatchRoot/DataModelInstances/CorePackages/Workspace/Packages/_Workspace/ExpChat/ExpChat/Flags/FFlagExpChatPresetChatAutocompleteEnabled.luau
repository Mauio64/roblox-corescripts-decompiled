local parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(parent.ExpChatShared)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatAutocompleteExperimentation = SocialExperiments.ExpChatPresetChatAutocompleteExperimentation

local FFlagExpChatPresetChatSendEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatSendEnabled

return game:DefineFastFlag("ExpChatPresetChatAutocompleteEnabled3", false)
	and ExpChatPresetChatAutocompleteExperimentation.isEnabled()
	and FFlagExpChatPresetChatSendEnabled
