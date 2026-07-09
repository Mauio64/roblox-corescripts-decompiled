local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Rodux = require(AppChatParent.Rodux)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local CurrentConversationTimeoutEnded = require(AppChat.Conversations.Actions.CurrentConversationTimeoutEnded)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local t1 = {
	userTimeout = {},
	byConversationId = {}
}

local function serializeChatTimeoutRange(p1) -- line: 33
	local dateTime = DateTime.now()
	local UnixTimestamp = (DateTime.fromIsoDate(p1.start_time) or dateTime).UnixTimestamp
	local UnixTimestamp2 = (DateTime.fromIsoDate(p1.end_time) or dateTime).UnixTimestamp

	return {
		endTimestamp = math.clamp(dateTime.UnixTimestamp + p1.time_remaining, -17987443200, 253402300799),
		decisionEventId = p1.decision_event_id,
		duration = math.clamp(UnixTimestamp2 - UnixTimestamp, 0, 253402300799)
	}
end

return (Rodux.createReducer(t1, {
	[AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name] = function(p2, p3) -- line: 45
		-- upvalues: serializeChatTimeoutRange (copy), Cryo (copy)
		local responseBody = p3.responseBody

		if responseBody.user_timeout_range then
			local v17 = serializeChatTimeoutRange(responseBody.user_timeout_range)

			p2 = Cryo.Dictionary.join(p2, {
				userTimeout = v17
			})
		end

		if responseBody.conversation_timeout_ranges then
			for _, v19 in responseBody.conversation_timeout_ranges do
				local id = v19.id
				local v21 = serializeChatTimeoutRange(v19.timeout_range)

				p2 = Cryo.Dictionary.join(p2, {
					byConversationId = Cryo.Dictionary.join(p2.byConversationId, {
						[id] = v21
					})
				})
			end
		end

		return p2
	end,
	[RemovedConversation.name] = function(t2: {[any]: any}, p4) -- line: 66
		-- upvalues: Cryo (copy)
		local conversationId = p4.conversationId

		return Cryo.Dictionary.join(t2, {
			byConversationId = Cryo.Dictionary.join(t2.byConversationId, {
				[conversationId] = Cryo.None
			})
		})
	end,
	[CurrentConversationTimeoutEnded.name] = function(t3: {[any]: any}, p5) -- line: 74
		-- upvalues: Cryo (copy)
		local v27 = t3
		local UnixTimestamp = DateTime.now().UnixTimestamp

		if t3.userTimeout and (t3.userTimeout.endTimestamp and UnixTimestamp > t3.userTimeout.endTimestamp) then
			v27 = Cryo.Dictionary.join(v27, {
				userTimeout = {}
			})
		end

		local conversationId = p5.conversationId

		if not t3.byConversationId[conversationId] or not t3.byConversationId[conversationId].endTimestamp or UnixTimestamp <= t3.byConversationId[conversationId].endTimestamp then
			return v27
		end

		return Cryo.Dictionary.join(v27, {
			byConversationId = Cryo.Dictionary.join(v27.byConversationId, {
				[conversationId] = Cryo.None
			})
		})
	end
}))
