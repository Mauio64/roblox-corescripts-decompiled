local parent = script:FindFirstAncestor("ExpChat").Parent

local ExpChatShared = require(parent.ExpChatShared)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatGlobalTabDefaultExperimentation = SocialExperiments.ExpChatGlobalTabDefaultExperimentation

local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs

local v = nil

local function isGlobalTabFirst()
	if v == nil then
		v = GetFFlagTextChatEnableUniverseChatTabs() and ExpChatGlobalTabDefaultExperimentation.getIsGlobalTabDefault()
	end

	return v
end

return isGlobalTabFirst
