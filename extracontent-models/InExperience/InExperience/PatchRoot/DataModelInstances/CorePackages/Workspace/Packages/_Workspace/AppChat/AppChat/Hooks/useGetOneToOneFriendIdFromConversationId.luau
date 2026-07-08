local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)

return function(s1: string?) -- line: 8
	-- upvalues: useLocalUserId (copy), useGetConversationFromId (copy), getOtherParticipants (copy)
	local v7 = useLocalUserId()
	local v8 = useGetConversationFromId(s1)

	if not s1 or not v7 then
		return nil
	end

	if not v8 then
		return nil
	end

	if v8.type ~= "one_to_one" then
		return nil
	end

	local v9 = getOtherParticipants(v8, v7)

	if #v9 ~= 1 then
		return nil
	end

	return v9[1]
end
