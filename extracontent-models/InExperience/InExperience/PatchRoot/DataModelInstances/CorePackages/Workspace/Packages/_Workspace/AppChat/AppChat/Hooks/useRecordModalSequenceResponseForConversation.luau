local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useGetOneToOneFriendIdFromConversationId = require(AppChat.Hooks.useGetOneToOneFriendIdFromConversationId)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local AppChatNetworking = require(parent.AppChatNetworking)

return function(p: string?)
	local v = useDispatch()
	local v2 = useGetConversationFromId(p)

	local v3 = useGetOneToOneFriendIdFromConversationId(p)

	return function(p2, p3, p4: string?, p5)
		if v2 and v2.source == "friends" and v3 then
			return v(AppChatNetworking.rodux.RecordModalSequenceResponse.API(p2, p3, p4, p5, nil, v3))
		end

		return v(AppChatNetworking.rodux.RecordModalSequenceResponse.API(p2, p3, p4, p5, p))
	end
end
