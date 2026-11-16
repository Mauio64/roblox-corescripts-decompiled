local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)

return function(p: string?)
	local v = useLocalUserId()
	local v2 = useGetConversationFromId(p)

	if not (p and v and v2 and v2.type == "one_to_one") then
		return nil
	end

	local otherParticipants = getOtherParticipants(v2, v)
	return if #otherParticipants == 1 then otherParticipants[1] else nil
end
