local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.Models.ConversationChannels)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)

local function useCallbackWithDynamicConversationId(callback, p: string)
	local v = useGetConversationFromId(p)
	local v2 = v ~= nil
	local v3 = useGetOneToOneFriendIdFromConversationId(p)
	local v4

	if v then
		v4 = v.source == "friends" and v3
	else
		v4 = v
	end

	if v then
		v = not (v.source == "friends") and p
	end

	return React.useCallback(function(options)
		local union = Cryo.Dictionary.union
		local conversationId

		if v then
			conversationId = p
		end

		local friendId

		if v4 then
			friendId = v3
		end

		return callback((union(options or {}, {
			conversationId = conversationId,
			friendId = friendId
		})))
	end, { callback, p, v4, v, v3 }), v2
end

return useCallbackWithDynamicConversationId
