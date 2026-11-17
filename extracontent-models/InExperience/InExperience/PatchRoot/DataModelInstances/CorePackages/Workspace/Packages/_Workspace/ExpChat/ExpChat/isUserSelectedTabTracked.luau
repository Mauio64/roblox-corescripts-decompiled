local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatStickyTabs = SharedFlags.FFlagExpChatStickyTabs
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local function isUserSelectedTabTracked()
	return FFlagExpChatStickyTabs or FFlagExpChatGlobalTabDefault
end

return isUserSelectedTabTracked
