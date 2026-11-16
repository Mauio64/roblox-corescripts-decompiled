local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiTabExperimentation = SocialExperiments.ExpChatPresetChatEmojiTabExperimentation

local SocialExperiments2 = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiEffectExperimentation = SocialExperiments2.ExpChatPresetChatEmojiEffectExperimentation

local FFlagExpChatMessageEffectChatWindowEnlargeRolloutEnabled = require(ExpChat.Flags.FFlagExpChatMessageEffectChatWindowEnlargeRolloutEnabled)

local v = nil

local function isChatWindowEnlargeEnabled()
	if v == nil then
		v = FFlagExpChatMessageEffectChatWindowEnlargeRolloutEnabled
			or ExpChatPresetChatEmojiTabExperimentation.getIsEmphasizedRenderingEnabled()
			or ExpChatPresetChatEmojiEffectExperimentation.getHasChatWindowEnlargeEffect()
	end

	return v
end

return isChatWindowEnlargeEnabled
