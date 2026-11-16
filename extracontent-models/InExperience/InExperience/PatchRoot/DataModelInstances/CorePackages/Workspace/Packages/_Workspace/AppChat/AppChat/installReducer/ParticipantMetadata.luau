local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)

local AppChatNetworking = require(parent.AppChatNetworking)
return Rodux.createReducer({}, {
	[AppChatNetworking.rodux.GetConversationsParticipantsMetadata.Succeeded.name] = function(p, p2)
		for k, v in p2.responseBody.conversation_participants_metadata do
			local v2 = {}

			for k2, v3 in v.participants_metadata do
				local v4 = { isPending = v3.is_pending }

				v4.isBlocked = v3.is_blocked
				v4.isInviter = v3.is_inviter
				v4.isInvited = v3.is_invited
				v2[k2] = v4
			end

			p = Cryo.Dictionary.join(p, { [k] = v2 })
		end

		return p
	end,
	[RemovedConversation.name] = function(p, p2)
		local conversationId = p2.conversationId

		if conversationId then
			return Cryo.Dictionary.join(p, { [conversationId] = Cryo.None })
		end

		return p
	end
})
