local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

return function(s1: string?) -- line: 11
	-- upvalues: useDispatch (copy), useGetConversationFromId (copy), useGetOneToOneFriendIdFromConversationId (copy), AppChatNetworking (copy)
	local v8 = useDispatch()
	local v9 = useGetConversationFromId(s1)
	local v10 = useGetOneToOneFriendIdFromConversationId(s1)

	return function(p1, p2, s2: string?, p3) -- line: 18
		-- upvalues: v9 (copy), v10 (copy), v8 (copy), AppChatNetworking (copy), s1 (copy)
		if v9 and (v9.source == "friends" and v10) then
			return v8(AppChatNetworking.rodux.RecordModalSequenceResponse.API(p1, p2, s2, p3, nil, v10))
		end

		return v8(AppChatNetworking.rodux.RecordModalSequenceResponse.API(p1, p2, s2, p3, s1))
	end
end
