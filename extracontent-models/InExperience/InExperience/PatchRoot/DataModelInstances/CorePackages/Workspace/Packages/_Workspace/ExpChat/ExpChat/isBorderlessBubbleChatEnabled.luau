local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiTabExperimentation = SocialExperiments.ExpChatPresetChatEmojiTabExperimentation

local SocialExperiments2 = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiEffectExperimentation = SocialExperiments2.ExpChatPresetChatEmojiEffectExperimentation

local FFlagExpChatMessageEffectBorderlessBubbleChatRolloutEnabled = require(ExpChat.Flags.FFlagExpChatMessageEffectBorderlessBubbleChatRolloutEnabled)

local v = nil

local function isBorderlessBubbleChatEnabled()
	if v == nil then
		v = FFlagExpChatMessageEffectBorderlessBubbleChatRolloutEnabled
			or ExpChatPresetChatEmojiTabExperimentation.getIsEmphasizedRenderingEnabled()
			or ExpChatPresetChatEmojiEffectExperimentation.getHasBorderlessBubbleChatEffect()
	end

	return v
end

return isBorderlessBubbleChatEnabled
