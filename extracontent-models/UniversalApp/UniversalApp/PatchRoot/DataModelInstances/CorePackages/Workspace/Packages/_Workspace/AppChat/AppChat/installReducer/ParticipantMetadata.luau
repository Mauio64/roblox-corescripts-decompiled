local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Rodux = require(AppChatParent.Rodux)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

return Rodux.createReducer({}, {
	[AppChatNetworking.rodux.GetConversationsParticipantsMetadata.Succeeded.name] = function(p1, p2) -- line: 24
		-- upvalues: Cryo (copy)
		for v9, v10 in p2.responseBody.conversation_participants_metadata do
			local t1 = {}

			for v12, v13 in v10.participants_metadata do
				t1[v12] = {
					isPending = v13.is_pending,
					isBlocked = v13.is_blocked,
					isInviter = v13.is_inviter,
					isInvited = v13.is_invited
				}
			end

			p1 = Cryo.Dictionary.join(p1, {
				[v9] = t1
			})
		end

		return p1
	end,
	[RemovedConversation.name] = function(t2: {[any]: any}, p3) -- line: 46
		-- upvalues: Cryo (copy)
		local conversationId = p3.conversationId

		if not conversationId then
			return t2
		end

		return Cryo.Dictionary.join(t2, {
			[conversationId] = Cryo.None
		})
	end
})
