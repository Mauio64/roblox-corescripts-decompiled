local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local getDeepValue = require(AppChat.Utils.getDeepValue)
local Cryo = require(AppChatParent.Cryo)
local messageSortPredicate = require(AppChat.Components.ChatConversation.Utils.messageSortPredicate)
local filterForLinksWithPolicy = require(AppChat.Components.ChatConversation.Utils.filterForLinksWithPolicy)
local populateMessageWithState = require(AppChat.Conversations.populateMessageWithState)

require(AppChatParent.AppChatNetworking)

local function selectMessagesPure(p1, t1: {[any]: any}) -- line: 83
	-- upvalues: getDeepValue (copy), Cryo (copy), messageSortPredicate (copy), filterForLinksWithPolicy (copy), populateMessageWithState (copy)
	local conversation = p1.conversation

	if not conversation then
		return {
			itemList = {},
			previousMessagesState = t1.previousMessagesState,
			previousSendingMessagesState = t1.previousSendingMessagesState,
			previousMessagesResult = t1.previousMessagesResult
		}
	end

	local messages = conversation.messages
	local sendingMessages = conversation.sendingMessages
	local conversationId = p1.conversationId
	local v15 = t1.previousMessagesState[conversationId]
	local v16 = t1.previousSendingMessagesState[conversationId]
	local v17 = t1.previousMessagesResult[conversationId]

	if not messages then
		return {
			itemList = v17 or {},
			previousMessagesState = t1.previousMessagesState,
			previousSendingMessagesState = t1.previousSendingMessagesState,
			previousMessagesResult = t1.previousMessagesResult
		}
	end

	if messages == v15 and sendingMessages == v16 then
		return {
			itemList = v17 or {},
			previousMessagesState = t1.previousMessagesState,
			previousSendingMessagesState = t1.previousSendingMessagesState,
			previousMessagesResult = t1.previousMessagesResult
		}
	end

	local v18 = getDeepValue(messages, "values")
	local v19 = if not sendingMessages then {} else getDeepValue(sendingMessages, "values")
	local v20 = Cryo.Dictionary.join(v18, v19)
	local v21 = Cryo.List.sort(Cryo.Dictionary.values(v20), messageSortPredicate)
	local t2 = {}

	for v23, v24 in v21 do
		local v25 = v19[v24.id]
		local v26 = filterForLinksWithPolicy(v24)

		for v27, v28 in v26 do
			local v29 = v26[v27 + 1] or v21[v23 + 1]
			local t3 = {
				Users = p1.Users,
				LocalUserId = p1.localUserId
			}
			local v31 = populateMessageWithState(t3, v28, v24.id, conversation, t2[#t2], not not v25, v29)

			v31.stable_key = `{ v31.stableKey or v31.messageId }_{ v27 }`
			table.insert(t2, v31)
		end
	end

	local v32 = table.clone(t1.previousMessagesState)
	local v33 = table.clone(t1.previousSendingMessagesState)
	local v34 = table.clone(t1.previousMessagesResult)

	v32[conversationId] = messages
	v33[conversationId] = sendingMessages
	v34[conversationId] = Cryo.List.reverse(t2)

	return {
		itemList = v34[conversationId],
		previousMessagesState = v32,
		previousSendingMessagesState = v33,
		previousMessagesResult = v34
	}
end

return selectMessagesPure
