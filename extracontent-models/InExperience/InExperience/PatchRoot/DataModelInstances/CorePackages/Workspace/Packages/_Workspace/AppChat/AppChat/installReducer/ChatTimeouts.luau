local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)

local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local CurrentConversationTimeoutEnded = require(AppChat.Conversations.Actions.CurrentConversationTimeoutEnded)

local AppChatNetworking = require(parent.AppChatNetworking)
local serializeChatTimeoutRange = require(AppChat.Utils.serializeChatTimeoutRange)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

return (Rodux.createReducer({ userTimeout = {}, byConversationId = {} }, {
	[AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody
		local ids

		if p2.postBody then
			ids = p2.postBody.ids
		end

		if responseBody.user_timeout_range then
			local userTimeout = serializeChatTimeoutRange(responseBody.user_timeout_range)
			p = Cryo.Dictionary.join(p, { userTimeout = userTimeout })
		elseif FFlagAppChatReactiveFeatureRestrictions and ids ~= nil then
			p = Cryo.Dictionary.join(p, { userTimeout = {} })
		end

		if not responseBody.conversation_timeout_ranges then
			return p
		end

		local idSet = {}

		for _, conversation_timeout_range in responseBody.conversation_timeout_ranges do
			local id = conversation_timeout_range.id
			idSet[id] = true

			local v = serializeChatTimeoutRange(conversation_timeout_range.timeout_range)
			p = Cryo.Dictionary.join(p, {
				byConversationId = Cryo.Dictionary.join(p.byConversationId, { [id] = v })
			})
		end

		if FFlagAppChatReactiveFeatureRestrictions and ids ~= nil and #ids > 0 then
			for _, id in ids do
				if not idSet[id] then
					p = Cryo.Dictionary.join(p, {
						byConversationId = Cryo.Dictionary.join(p.byConversationId, {
							[id] = Cryo.None
						})
					})
				end
			end
		end

		return p
	end,
	[RemovedConversation.name] = function(p, p2)
		local conversationId = p2.conversationId
		return Cryo.Dictionary.join(p, {
			byConversationId = Cryo.Dictionary.join(p.byConversationId, {
				[conversationId] = Cryo.None
			})
		})
	end,
	[CurrentConversationTimeoutEnded.name] = function(p, p2)
		local unixTimestamp = DateTime.now().UnixTimestamp
		local v

		if
			p.userTimeout
			and p.userTimeout.endTimestamp
			and p.userTimeout.endTimestamp < unixTimestamp
			and (not FFlagAppChatReactiveFeatureRestrictions or p.userTimeout.requiresAcknowledgement ~= true)
		then
			v = Cryo.Dictionary.join(p, { userTimeout = {} })
		else
			v = p
		end

		local conversationId = p2.conversationId

		if
			p.byConversationId[conversationId]
			and p.byConversationId[conversationId].endTimestamp
			and not (unixTimestamp <= p.byConversationId[conversationId].endTimestamp)
			and (not FFlagAppChatReactiveFeatureRestrictions or p.byConversationId[conversationId].requiresAcknowledgement ~= true)
		then
			return Cryo.Dictionary.join(v, {
				byConversationId = Cryo.Dictionary.join(v.byConversationId, {
					[conversationId] = Cryo.None
				})
			})
		end

		return v
	end
}))
