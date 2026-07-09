local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local SignalsExperimental = require(AppChatParent.SignalsExperimental)
local getOtherParticipants = require(script.Parent.getOtherParticipants)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)

return function(t1: {[any]: any}, n1: number) -- line: 17
	-- upvalues: getOtherParticipants (copy), GetConversationStore (copy), AppChatNetworking (copy), ConversationChannels (copy), SignalsExperimental (copy)
	local v10 = getOtherParticipants(t1, n1)

	if #v10 ~= 1 then
		return nil
	end

	local v11 = v10[1]
	local v12 = GetConversationStore(false)

	return AppChatNetworking.http.CreateConversation(nil, "one_to_one", { v11 }):andThen(function(p1) -- line: 25
		-- upvalues: ConversationChannels (copy), SignalsExperimental (copy), v12 (copy), t1 (copy)
		local v14 = p1 and p1.responseBody
		local v15 = v14 and (v14.conversations and v14.conversations[1])

		if v15 == nil or v15.status == "failed" then
			return nil
		end

		local v16 = ConversationChannels.fromChannelsApi(v15)

		SignalsExperimental.batch(function() -- line: 33
			-- upvalues: v12 (copy), v16 (copy), t1 (copy)
			v12.upsertConversation(v16, false)
			v12.removeConversation(t1.id)
		end)

		return v16
	end)
end
