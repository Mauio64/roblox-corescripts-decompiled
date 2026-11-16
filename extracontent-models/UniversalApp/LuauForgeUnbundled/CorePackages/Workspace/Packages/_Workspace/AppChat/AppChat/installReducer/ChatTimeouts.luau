local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local CurrentConversationTimeoutEnded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/CurrentConversationTimeoutEnded")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local serializeChatTimeoutRange = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/serializeChatTimeoutRange")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

return (Rodux.createReducer({ userTimeout = {}, byConversationId = {} }, {
	[AppChatNetworking.rodux.GetChatModerationStatuses.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody
		local ids = if p3.postBody then p3.postBody.ids else nil

		if responseBody.user_timeout_range then
			local v6 = serializeChatTimeoutRange(responseBody.user_timeout_range)
			p2 = Cryo.Dictionary.join(p2, { userTimeout = v6 })
		elseif fFlagAppChatReactiveFeatureRestrictions and ids ~= nil then
			p2 = Cryo.Dictionary.join(p2, { userTimeout = {} })
		end

		if not responseBody.conversation_timeout_ranges then
			return p2
		end

		local idSet = {}

		for k, conversation_timeout_range in responseBody.conversation_timeout_ranges do
			local id = conversation_timeout_range.id
			idSet[id] = true

			local v6 = serializeChatTimeoutRange(conversation_timeout_range.timeout_range)
			p2 = Cryo.Dictionary.join(p2, {
				byConversationId = Cryo.Dictionary.join(p2.byConversationId, {
					[id] = v6
				})
			})
		end

		if fFlagAppChatReactiveFeatureRestrictions and ids ~= nil and #ids > 0 then
			for k, id in ids do
				if not idSet[id] then
					p2 = Cryo.Dictionary.join(p2, {
						byConversationId = Cryo.Dictionary.join(p2.byConversationId, {
							[id] = Cryo.None
						})
					})
				end
			end
		end

		return p2
	end,
	[RemovedConversation.name] = function(p2, p3)
		local conversationId = p3.conversationId
		return Cryo.Dictionary.join(p2, {
			byConversationId = Cryo.Dictionary.join(p2.byConversationId, {
				[conversationId] = Cryo.None
			})
		})
	end,
	[CurrentConversationTimeoutEnded.name] = function(p2, p3)
		local unixTimestamp = DateTime.now().UnixTimestamp
		local v6

		if
			p2.userTimeout
			and p2.userTimeout.endTimestamp
			and p2.userTimeout.endTimestamp < unixTimestamp
			and (not fFlagAppChatReactiveFeatureRestrictions or p2.userTimeout.requiresAcknowledgement ~= true)
		then
			v6 = Cryo.Dictionary.join(p2, { userTimeout = {} })
		else
			v6 = p2
		end

		local conversationId = p3.conversationId

		if
			p2.byConversationId[conversationId]
			and p2.byConversationId[conversationId].endTimestamp
			and not (unixTimestamp <= p2.byConversationId[conversationId].endTimestamp)
			and (not fFlagAppChatReactiveFeatureRestrictions or p2.byConversationId[conversationId].requiresAcknowledgement ~= true)
		then
			return Cryo.Dictionary.join(v6, {
				byConversationId = Cryo.Dictionary.join(v6.byConversationId, {
					[conversationId] = Cryo.None
				})
			})
		end

		return v6
	end
}))
