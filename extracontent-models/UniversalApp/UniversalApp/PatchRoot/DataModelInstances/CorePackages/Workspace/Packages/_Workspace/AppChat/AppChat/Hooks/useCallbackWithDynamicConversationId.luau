local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.Models.ConversationChannels)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)

local function useCallbackWithDynamicConversationId(p1: ((...any) -> ...any), s1: string) -- line: 25
	-- upvalues: useGetConversationFromId (copy), useGetOneToOneFriendIdFromConversationId (copy), React (copy), Cryo (copy)
	local v10 = useGetConversationFromId(s1)
	local v11 = v10 ~= nil
	local v12 = useGetOneToOneFriendIdFromConversationId(s1)
	local v13 = v10 and (v10.source == "friends" and v12)
	local v14 = v10 and (v10.source ~= "friends" and s1)

	return React.useCallback(function(p2) -- line: 35
		-- upvalues: p1 (copy), Cryo (copy), v14 (copy), s1 (copy), v13 (copy), v12 (copy)
		return p1((Cryo.Dictionary.union(p2 or {}, {
			conversationId = if not v14 then nil else s1,
			friendId = if not v13 then nil else v12
		})))
	end, {
		p1,
		s1,
		v13,
		v14,
		v12
	}), v11
end

return useCallbackWithDynamicConversationId
