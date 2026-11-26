local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
return Rodux.createReducer({}, {
	[AppChatNetworking.rodux.GetConversationsParticipantsMetadata.Succeeded.name] = function(p2, p3)
		for k, v6 in p3.responseBody.conversation_participants_metadata do
			local v7 = {}

			for k2, v8 in v6.participants_metadata do
				local v9 = { isPending = v8.is_pending }

				v9.isBlocked = v8.is_blocked
				v9.isInviter = v8.is_inviter
				v9.isInvited = v8.is_invited
				v7[k2] = v9
			end

			p2 = Cryo.Dictionary.join(p2, { [k] = v7 })
		end

		return p2
	end,
	[RemovedConversation.name] = function(p2, p3)
		local conversationId = p3.conversationId

		if conversationId then
			return Cryo.Dictionary.join(p2, { [conversationId] = Cryo.None })
		end

		return p2
	end
})
