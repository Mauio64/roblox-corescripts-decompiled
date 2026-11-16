local parent = script:FindFirstAncestor("ExpChat").Parent

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatGlobalTabDefaultExperimentation = SocialExperiments.ExpChatGlobalTabDefaultExperimentation

local v = nil

local function isGlobalBubbleChatEnabled()
	if v == nil then
		v = ExpChatGlobalTabDefaultExperimentation.getIsGlobalBubbleChatEnabled()
	end

	return v
end

return isGlobalBubbleChatEnabled
