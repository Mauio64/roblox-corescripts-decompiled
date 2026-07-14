local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local SharedFlags = require(Parent.SharedFlags)

return function() -- line: 5
	-- upvalues: SharedFlags (copy)
	return SharedFlags.FFlagExpChatUseChatMuteStore
end
