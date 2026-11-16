local parent = script:FindFirstAncestor("ExpChat").Parent

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatGlobalTabDefaultExperimentation = SocialExperiments.ExpChatGlobalTabDefaultExperimentation

local globalWelcomeMessageKey = nil

local function getGlobalWelcomeMessageKey()
	if globalWelcomeMessageKey == nil then
		globalWelcomeMessageKey = ExpChatGlobalTabDefaultExperimentation.getGlobalWelcomeMessageKey()
	end

	return globalWelcomeMessageKey
end

return getGlobalWelcomeMessageKey
