local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local getDeepValue = require(AppChat.Utils.getDeepValue)
local Cryo = require(parent.Cryo)
local messageSortPredicate = require(AppChat.Components.ChatConversation.Utils.messageSortPredicate)
local filterForLinksWithPolicy = require(AppChat.Components.ChatConversation.Utils.filterForLinksWithPolicy)
local populateMessageWithState = require(AppChat.Conversations.populateMessageWithState)
require(parent.AppChatNetworking)

local function selectMessagesPure(data, data2)
	local conversation = data.conversation

	if not conversation then
		return {
			itemList = {},
			previousMessagesState = data2.previousMessagesState,
			previousSendingMessagesState = data2.previousSendingMessagesState,
			previousMessagesResult = data2.previousMessagesResult
		}
	end

	local messages = conversation.messages
	local sendingMessages = conversation.sendingMessages
	local conversationId = data.conversationId
	local v = data2.previousMessagesState[conversationId]
	local v2 = data2.previousSendingMessagesState[conversationId]
	local v3 = data2.previousMessagesResult[conversationId]

	if not messages or messages == v and sendingMessages == v2 then
		return {
			itemList = v3 or {},
			previousMessagesState = data2.previousMessagesState,
			previousSendingMessagesState = data2.previousSendingMessagesState,
			previousMessagesResult = data2.previousMessagesResult
		}
	end

	local deepValue = getDeepValue(messages, "values")
	local v4 = not sendingMessages and {} or getDeepValue(sendingMessages, "values")
	local joined = Cryo.Dictionary.join(deepValue, v4)
	local sorted = Cryo.List.sort(Cryo.Dictionary.values(joined), messageSortPredicate)

	local v5 = {}

	for k, v6 in sorted do
		local v7 = v4[v6.id] and true or false
		local v8 = filterForLinksWithPolicy(v6)

		for k2, v9 in v8 do
			local v10 = v8[k2 + 1] or sorted[k + 1]

			local v11 = populateMessageWithState(
				{ Users = data.Users, LocalUserId = data.localUserId },
				v9,
				v6.id,
				conversation,
				v5[#v5],
				v7,
				v10
			)

			v11.stable_key = `{v11.stableKey or v11.messageId}_{k2}`

			table.insert(v5, v11)
		end
	end

	local clone = table.clone(data2.previousMessagesState)
	local clone2 = table.clone(data2.previousSendingMessagesState)
	local clone3 = table.clone(data2.previousMessagesResult)

	clone[conversationId] = messages
	clone2[conversationId] = sendingMessages
	clone3[conversationId] = Cryo.List.reverse(v5)

	return {
		itemList = clone3[conversationId],
		previousMessagesState = clone,
		previousSendingMessagesState = clone2,
		previousMessagesResult = clone3
	}
end

return selectMessagesPure
