local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local messageSortPredicate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/messageSortPredicate")
local filterForLinksWithPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/filterForLinksWithPolicy")
local populateMessageWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/populateMessageWithState")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

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
	local v5 = data2.previousMessagesState[conversationId]
	local v6 = data2.previousSendingMessagesState[conversationId]
	local v7 = data2.previousMessagesResult[conversationId]

	if not messages or messages == v5 and sendingMessages == v6 then
		return {
			itemList = v7 or {},
			previousMessagesState = data2.previousMessagesState,
			previousSendingMessagesState = data2.previousSendingMessagesState,
			previousMessagesResult = data2.previousMessagesResult
		}
	end

	local v8 = getDeepValue(messages, "values")
	local v9 = not sendingMessages and {} or getDeepValue(sendingMessages, "values")
	local joined = Cryo.Dictionary.join(v8, v9)
	local sorted = Cryo.List.sort(Cryo.Dictionary.values(joined), messageSortPredicate)

	local v10 = {}

	for k, v11 in sorted do
		local v12 = v9[v11.id] and true or false
		local v13 = filterForLinksWithPolicy(v11)

		for k2, v14 in v13 do
			local v15 = v13[k2 + 1] or sorted[k + 1]

			local v17 = populateMessageWithState(
				{ Users = data.Users, LocalUserId = data.localUserId },
				v14,
				v11.id,
				conversation,
				v10[#v10],
				v12,
				v15
			)

			v17.stable_key = `{v17.stableKey or v17.messageId}_{k2}`

			table.insert(v10, v17)
		end
	end

	local clone = table.clone(data2.previousMessagesState)
	local clone2 = table.clone(data2.previousSendingMessagesState)
	local clone3 = table.clone(data2.previousMessagesResult)

	clone[conversationId] = messages
	clone2[conversationId] = sendingMessages
	clone3[conversationId] = Cryo.List.reverse(v10)

	return {
		itemList = clone3[conversationId],
		previousMessagesState = clone,
		previousSendingMessagesState = clone2,
		previousMessagesResult = clone3
	}
end

return selectMessagesPure
