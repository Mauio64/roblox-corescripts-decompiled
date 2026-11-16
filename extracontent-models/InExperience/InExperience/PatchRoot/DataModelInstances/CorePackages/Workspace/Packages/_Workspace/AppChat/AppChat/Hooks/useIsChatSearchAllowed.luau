local AppChat = script:FindFirstAncestor("AppChat")

local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)

return function()
	local v = useAppPolicy(function(p)
		return p.getChatHeaderSearch()
	end)

	local v2 = useIsChatEnabled()

	return v and v2 or false
end
