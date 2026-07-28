local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Rodux = require(AppChatParent.Rodux)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local CurrentConversationTimeoutEnded = require(AppChat.Conversations.Actions.CurrentConversationTimeoutEnded)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local serializeChatTimeoutRange = require(AppChat.Utils.serializeChatTimeoutRange)
local t1 = {
	userTimeout = {},
	byConversationId = {}
}

return (Rodux.createReducer(t1, {
	[AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name] = function(p1, p2) -- line: 28
		-- upvalues: serializeChatTimeoutRange (copy), Cryo (copy)
		local responseBody = p2.responseBody

		if responseBody.user_timeout_range then
			local v13 = serializeChatTimeoutRange(responseBody.user_timeout_range)

			p1 = Cryo.Dictionary.join(p1, {
				userTimeout = v13
			})
		end

		if responseBody.conversation_timeout_ranges then
			for _, v15 in responseBody.conversation_timeout_ranges do
				local id = v15.id
				local v17 = serializeChatTimeoutRange(v15.timeout_range)

				p1 = Cryo.Dictionary.join(p1, {
					byConversationId = Cryo.Dictionary.join(p1.byConversationId, {
						[id] = v17
					})
				})
			end
		end

		return p1
	end,
	[RemovedConversation.name] = function(t2: {[any]: any}, p3) -- line: 49
		-- upvalues: Cryo (copy)
		local conversationId = p3.conversationId

		return Cryo.Dictionary.join(t2, {
			byConversationId = Cryo.Dictionary.join(t2.byConversationId, {
				[conversationId] = Cryo.None
			})
		})
	end,
	[CurrentConversationTimeoutEnded.name] = function(t3: {[any]: any}, p4) -- line: 57
		-- upvalues: Cryo (copy)
		local v23 = t3
		local UnixTimestamp = DateTime.now().UnixTimestamp

		if t3.userTimeout and (t3.userTimeout.endTimestamp and UnixTimestamp > t3.userTimeout.endTimestamp) then
			v23 = Cryo.Dictionary.join(v23, {
				userTimeout = {}
			})
		end

		local conversationId = p4.conversationId

		if not t3.byConversationId[conversationId] or not t3.byConversationId[conversationId].endTimestamp or UnixTimestamp <= t3.byConversationId[conversationId].endTimestamp then
			return v23
		end

		return Cryo.Dictionary.join(v23, {
			byConversationId = Cryo.Dictionary.join(v23.byConversationId, {
				[conversationId] = Cryo.None
			})
		})
	end
}))
