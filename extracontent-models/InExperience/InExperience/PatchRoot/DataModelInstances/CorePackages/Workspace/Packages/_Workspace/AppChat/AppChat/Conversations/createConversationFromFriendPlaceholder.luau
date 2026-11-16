local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local SignalsExperimental = require(parent.SignalsExperimental)
local getOtherParticipants = require(script.Parent.getOtherParticipants)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationSearchDataHydration = require(AppChat.Stores.GetConversationSearchDataHydration)
local FFlagAppChatAnyServerSideConversationSearch = require(AppChat.Flags.FFlagAppChatAnyServerSideConversationSearch)

return function(p, p2: number)
	local otherParticipants = getOtherParticipants(p, p2)

	if #otherParticipants ~= 1 then
		return nil
	end

	local otherParticipant = otherParticipants[1]

	local conversationStore = GetConversationStore(false)
	return AppChatNetworking.http.CreateConversation(nil, "one_to_one", { otherParticipant }):andThen(function(p3)
		local responseBody = p3 and p3.responseBody
		local v = responseBody and responseBody.conversations and responseBody.conversations[1]

		if v == nil or v.status == "failed" then
			return nil
		end

		local v2 = ConversationChannels.fromChannelsApi(v)
		SignalsExperimental.batch(function()
			conversationStore.upsertConversation(v2, false)
			conversationStore.removeConversation(p.id)
		end)

		if FFlagAppChatAnyServerSideConversationSearch then
			GetConversationSearchDataHydration(false).invalidate()
		end

		return v2
	end)
end
