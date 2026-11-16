local parent = script:FindFirstAncestor("TextChannelWindow").Parent
local SharedFlags = require(parent.SharedFlags)

return function()
	return SharedFlags.FFlagExpChatUseChatMuteStore
end
