local parent = script:FindFirstAncestor("ExpChat").Parent

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatGlobalTabDefaultExperimentation = SocialExperiments.ExpChatGlobalTabDefaultExperimentation

local v = nil

local function isGlobalMessagePrefixEnabled()
	if v == nil then
		v = ExpChatGlobalTabDefaultExperimentation.getIsGlobalMessagePrefixEnabled()
	end

	return v
end

return isGlobalMessagePrefixEnabled
