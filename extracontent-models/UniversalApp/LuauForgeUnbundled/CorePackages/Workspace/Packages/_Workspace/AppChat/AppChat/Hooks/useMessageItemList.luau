local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime

local filterForLinksWithPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/filterForLinksWithPolicy")
local populateMessageWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/populateMessageWithState")
local GetConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Enums")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local FFlagAppChatIncrementalMessageItemList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIncrementalMessageItemList")
local FFlagAppChatParseMessageTimestampsOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatParseMessageTimestampsOnce")
local FFlagAppChatFixMessageItemListStaleRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFixMessageItemListStaleRefs")
local FFlagAppChatMessageItemListCurrentOnSwitch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageItemListCurrentOnSwitch")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local messageStatus = Enums.MessageStatus
local messageType = Enums.MessageType

local function toLuaDateTime(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	local success, result = pcall(function()
		return dateTime.fromIsoDate(p2)
	end)

	if success then
		return result
	end

	return nil
end

local function toLuaDateTimeFromMessage(p2)
	local createdAtUnixMillis = p2.createdAtUnixMillis

	if createdAtUnixMillis ~= nil then
		return dateTime.fromUnixTimestampMillis(createdAtUnixMillis)
	end

	local created_at = p2.created_at

	if created_at == nil or created_at == "" then
		return nil
	end

	local success, result = pcall(function()
		return dateTime.fromIsoDate(created_at)
	end)

	if success then
		return result
	end

	return nil
end

local function buildLegacyRepliesTo(data, p2)
	local replies_to = data.replies_to

	if replies_to == nil then
		return nil
	end

	local v5 = p2[replies_to.id]

	if v5 == nil then
		local v6 = {
			id = replies_to.id,
			content = replies_to.content,
			messageType = replies_to.type == messageType.System and "System" or "PlainText",
			senderTargetId = tostring(replies_to.sender_user_id),
			sent = 0
		}
		local result

		if FFlagAppChatParseMessageTimestampsOnce then
			local createdAtUnixMillis = replies_to.createdAtUnixMillis

			if createdAtUnixMillis == nil then
				local created_at = replies_to.created_at

				if not (created_at == nil or created_at == "") then
					local success
					success, result = pcall(function()
						return dateTime.fromIsoDate(created_at)
					end)

					if not success then
						result = nil
					end
				end
			else
				result = dateTime.fromUnixTimestampMillis(createdAtUnixMillis)
			end
		else
			local created_at = replies_to.created_at

			if not (created_at == nil or created_at == "") then
				local success
				success, result = pcall(function()
					return dateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		end

		v6.sent = result
		return v6
	else
		local join = Cryo.Dictionary.join
		local v6 = {
			senderTargetId = tostring(v5.sender_user_id),
			sent = 0,
			messageType = 0
		}
		local result

		if FFlagAppChatParseMessageTimestampsOnce then
			local createdAtUnixMillis = v5.createdAtUnixMillis

			if createdAtUnixMillis == nil then
				local created_at = v5.created_at

				if not (created_at == nil or created_at == "") then
					local success
					success, result = pcall(function()
						return dateTime.fromIsoDate(created_at)
					end)

					if not success then
						result = nil
					end
				end
			else
				result = dateTime.fromUnixTimestampMillis(createdAtUnixMillis)
			end
		else
			local created_at = v5.created_at

			if not (created_at == nil or created_at == "") then
				local success
				success, result = pcall(function()
					return dateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		end

		v6.sent = result

		v6.messageType = v5.type == messageType.System and "System" or "PlainText"
		return join(v5, v6)
	end
end

local function toLegacyMessage(data, p2)
	local v5 = data.type == messageType.System and "System" or "PlainText"
	local join = Cryo.Dictionary.join
	local v6 = {
		senderTargetId = tostring(data.sender_user_id),
		senderType = data.type,
		messageType = data.messageType or v5,
		sent = 0,
		moderationType = 0,
		moderated = 0,
		failed = 0,
		isSending = 0,
		filteredForReceivers = 0,
		contentToDisplay = 0,
		repliesTo = 0
	}
	local result

	if FFlagAppChatParseMessageTimestampsOnce then
		local createdAtUnixMillis = data.createdAtUnixMillis

		if createdAtUnixMillis == nil then
			local created_at = data.created_at

			if not (created_at == nil or created_at == "") then
				local success
				success, result = pcall(function()
					return dateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		else
			result = dateTime.fromUnixTimestampMillis(createdAtUnixMillis)
		end
	else
		local created_at = data.created_at

		if not (created_at == nil or created_at == "") then
			local success
			success, result = pcall(function()
				return dateTime.fromIsoDate(created_at)
			end)

			if not success then
				result = nil
			end
		end
	end

	v6.sent = result

	v6.moderationType = data.moderation_type
	v6.moderated = data.status == messageStatus.Moderated
	v6.failed = data.status == messageStatus.Failed
	v6.isSending = data.status == messageStatus.Pending
	v6.filteredForReceivers = data.filtered_for_receivers
	v6.contentToDisplay = data.content_to_display
	v6.repliesTo = buildLegacyRepliesTo(data, p2)
	return join(data, v6)
end

local function applyGroupedVariant(p2, p3)
	if p3 == nil then
		return p2
	end

	local groupedMessageVariant = Enums.GroupedMessageVariant

	if p3 == groupedMessageVariant.Single then
		p2.isNewSender = true
		p2.isLastMessageInMessageGroup = true
	elseif p3 == groupedMessageVariant.First then
		p2.isNewSender = true
		p2.isLastMessageInMessageGroup = false
	elseif p3 == groupedMessageVariant.Middle then
		p2.isNewSender = false
		p2.isLastMessageInMessageGroup = false
	elseif p3 == groupedMessageVariant.Last then
		p2.isNewSender = false
		p2.isLastMessageInMessageGroup = true
	end

	return p2
end

local function buildPopulatedMessage(p2, p3, p4, p5, p6, p7, p8, k)
	local populatedMessage = populateMessageWithState(
		{ Users = p7, LocalUserId = p8 },
		p2,
		p2.id,
		p6,
		p4,
		p2.isSending == true,
		p5
	)

	if p3 ~= nil then
		local groupedMessageVariant = Enums.GroupedMessageVariant

		if p3 == groupedMessageVariant.Single then
			populatedMessage.isNewSender = true
			populatedMessage.isLastMessageInMessageGroup = true
		elseif p3 == groupedMessageVariant.First then
			populatedMessage.isNewSender = true
			populatedMessage.isLastMessageInMessageGroup = false
		elseif p3 == groupedMessageVariant.Middle then
			populatedMessage.isNewSender = false
			populatedMessage.isLastMessageInMessageGroup = false
		elseif p3 == groupedMessageVariant.Last then
			populatedMessage.isNewSender = false
			populatedMessage.isLastMessageInMessageGroup = true
		end
	end

	populatedMessage.stable_key = `{populatedMessage.stableKey or populatedMessage.messageId}_{k}`
	return populatedMessage
end

local function buildMessageRows(p2, p3, p4, p5, p6, p7, p8)
	local v5 = filterForLinksWithPolicy(p2)
	local messageRows = table.create(#v5)

	for k, v6 in v5 do
		local v7 = v5[k + 1] or p3
		local v8 = if #v5 == 1 then p5 else nil
		p4 = buildPopulatedMessage(v6, v8, p4, v7, p6, p7, p8, k)

		table.insert(messageRows, p4)
	end

	return messageRows
end

local function buildMessageItemList(list, p2, callback, p3, p4, p5)
	if #list == 0 or p3 == nil then
		return {}
	end

	local filterMap = Cryo.List.filterMap(list, function(p6)
		local v5 = p2[p6]

		if v5 == nil then
			return nil
		end

		return toLegacyMessage(v5, p2)
	end)
	local v5 = nil
	local messageRows = {}

	for i = #filterMap, 1, -1 do
		local filter = filterMap[i]
		local v6 = if i > 1 then filterMap[i - 1] else nil
		local messageRows2 = buildMessageRows(filter, v6, v5, callback(filter.id), p3, p4, p5)

		for k, messageRow in messageRows2 do
			table.insert(messageRows, messageRow)
		end

		v5 = messageRows2[#messageRows2] or v5
	end

	return Cryo.List.reverse(messageRows)
end

local function createIncrementalMessageItemList()
	local v5 = {}
	local v6 = {}
	local v7 = 0
	local id = nil
	local conversationType = nil
	local v8 = nil

	return function(list, p2, callback, data, p3, p4)
		if #list == 0 or data == nil then
			v5 = {}
			v7 = 0

			if #v6 > 0 then
				v6 = {}
			end

			return v6
		else
			if data.id ~= id or data.conversationType ~= conversationType or p4 ~= v8 then
				v5 = {}
				id = data.id
				conversationType = data.conversationType
				v8 = p4
			end

			local v9 = {}

			for k, item in list do
				local v10 = p2[item]

				if v10 ~= nil then
					table.insert(v9, v10)
				end
			end

			local function getReplyTarget(p5)
				if p5.replies_to == nil then
					return nil
				end

				return p2[p5.replies_to.id]
			end

			local v10 = {}
			local function getLegacyMessage(p5)
				local v11 = v10[p5.id]

				if v11 ~= nil then
					return v11
				end

				local v12 = v5[p5.id]
				local v13

				if v12 == nil or v12.message ~= p5 then
					v13 = toLegacyMessage(p5, p2)
				else
					local replyTarget = v12.replyTarget
					local v14 = if p5.replies_to ~= nil then p2[p5.replies_to.id] else nil
					v13 = if replyTarget == v14 then v12.legacyMessage else toLegacyMessage(p5, p2)
				end

				v10[p5.id] = v13
				return v13
			end

			local v11 = nil
			local v12 = {}
			local total = 0
			local v13 = false

			for i = #v9, 1, -1 do
				local v14 = v9[i]
				local v15 = v9[i + 1]
				local v16 = v9[i - 1]
				local v17 = if v14.replies_to ~= nil then p2[v14.replies_to.id] else nil

				local v18 = callback(v14.id)
				local v19 = not (p3 == nil) and p3[tostring(v14.sender_user_id)] ~= nil
				local v20 = v15 == nil and data.fetchedOldestMessage == true

				local v21 = v5[v14.id]

				if
					v21 == nil
					or v21.message ~= v14
					or v21.replyTarget ~= v17
					or v21.olderMessage ~= v15
					or v21.newerMessage ~= v16
					or v21.groupedVariant ~= v18
					or v21.hasSender ~= v19
					or v21.showsOldestDateTime ~= v20
				then
					v13 = true
					local v22 = v10[v14.id]

					if v22 == nil then
						local v23 = v5[v14.id]

						if v23 == nil or v23.message ~= v14 then
							v22 = toLegacyMessage(v14, p2)
						else
							local replyTarget = v23.replyTarget
							local v24 = if v14.replies_to ~= nil then p2[v14.replies_to.id] else nil
							v22 = if replyTarget == v24 then v23.legacyMessage else toLegacyMessage(v14, p2)
						end

						v10[v14.id] = v22
					end

					local v23

					if v16 ~= nil then
						v23 = v10[v16.id]

						if v23 == nil then
							local v24 = v5[v16.id]

							if v24 == nil or v24.message ~= v16 then
								v23 = toLegacyMessage(v16, p2)
							else
								local replyTarget = v24.replyTarget
								local v25 = if v16.replies_to ~= nil then p2[v16.replies_to.id] else nil
								v23 = if replyTarget == v25 then v24.legacyMessage else toLegacyMessage(v16, p2)
							end

							v10[v16.id] = v23
						end
					end

					v21 = {
						message = v14,
						replyTarget = v17,
						legacyMessage = v22,
						olderMessage = v15,
						newerMessage = v16,
						groupedVariant = v18,
						hasSender = v19,
						showsOldestDateTime = v20,
						rows = buildMessageRows(v22, v23, v11, v18, data, p3, p4)
					}
				end

				v12[v14.id] = v21
				total += #v21.rows
				v11 = v21.rows[#v21.rows] or v11
			end

			v5 = v12

			if not v13 and #v9 == v7 then
				return v6
			end

			v7 = #v9

			local result = table.create(total)

			for k, v14 in v9 do
				local rows = v12[v14.id].rows

				for i = #rows, 1, -1 do
					table.insert(result, rows[i])
				end
			end

			v6 = result
			return result
		end
	end
end

local function isSameItemListConversation(data, data2): boolean
	if data == nil or data2 == nil then
		return data == data2
	end

	return data.id == data2.id
		and data.fetchedOldestMessage == data2.fetchedOldestMessage
		and data.conversationType == data2.conversationType
end

local function isSameUserIdSet(items, items2): boolean
	for k in items do
		if not items2[k] then
			return false
		end
	end

	for k in items2 do
		if not items[k] then
			return false
		end
	end

	return true
end

local function useItemListInputs(p2, current, current2, p3)
	local conversationMessageStore = p3.conversationMessageStore
	local conversationMessageListStore = p3.conversationMessageListStore

	local v5 = React.useMemo(function()
		local signal, v6 = Signals.createSignal(current, isSameItemListConversation)
		local signal2, v7 = Signals.createSignal(current2)

		return {
			getConversation = signal,
			setConversation = v6,
			getUsers = signal2,
			setUsers = v7,
			getKnownSenderIds = Signals.createComputed(function(p4)
				local sender_user_idSet = {}
				local v8 = signal2(p4)

				if p2 == nil or v8 == nil then
					return sender_user_idSet
				end

				local messages = conversationMessageStore.messages(p4)

				for k, v9 in conversationMessageListStore.getOrderedIds(p2, p4) do
					local message = messages[v9]

					if message == nil then
						continue
					end

					local sender_user_id = tostring(message.sender_user_id)

					if v8[sender_user_id] ~= nil then
						sender_user_idSet[sender_user_id] = true
					end
				end

				return sender_user_idSet
			end, isSameUserIdSet)
		}
	end, { p2, conversationMessageStore, conversationMessageListStore })

	React.useLayoutEffect(function()
		SignalsExperimental.batch(function()
			v5.setConversation(current)
			v5.setUsers(current2)
		end)
	end, { v5, current, current2 })

	return v5
end

return {
	useMessageItemList = function(p2, current, value, current2)
		local v5 = React.useMemo(function()
			return GetConversationMessageViewModelStore(false)
		end, {})
		local conversationMessageStore = v5.conversationMessageStore
		local conversationMessageListStore = v5.conversationMessageListStore

		local ref = React.useRef(current2)
		ref.current = current2
		local ref2 = React.useRef(current)
		ref2.current = current

		local v6 = if FFlagAppChatFixMessageItemListStaleRefs then useItemListInputs(p2, current2, current, v5) else nil

		local v7 = React.useMemo(function()
			if p2 == nil then
				return Signals.createComputed(function()
					return {}
				end)
			end

			local v8 = if FFlagAppChatIncrementalMessageItemList then createIncrementalMessageItemList() else buildMessageItemList

			return Signals.createComputed(function(p3)
				local orderedIds = conversationMessageListStore.getOrderedIds(p2, p3)
				local messages = conversationMessageStore.messages(p3)
				local v9 = tostring(value or "")

				local v10 = ref.current
				local v11 = ref2.current

				if FFlagAppChatFixMessageItemListStaleRefs then
					local v12 = v6
					v10 = v12.getConversation(p3)
					v12.getKnownSenderIds(p3)
					v11 = v12.getUsers(false)
				end

				if v10 == nil then
					return {}
				end

				local v12 = FFlagAppChatPerfTracking
					and FFlagAppChatMessageTTIMilestones
					and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = p2
					})

				if v12 then
					local v13 = { conversationId = p2 }
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
						v13
					)

					AppChatPerfTracker.trackSubphase(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
						AppChatPerfTracker.Milestone.DataProcessingStarted.Subphase.DataUpdate,
						v13
					)
				end

				local v13 = v8(orderedIds, messages, function(p4)
					return v5.getGroupedVariant(p4, p2)(p3)
				end, v10, v11, v9)

				if v12 then
					local v14 = { conversationId = p2 }
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
						v14
					)

					AppChatPerfTracker.trackSubphase(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
						AppChatPerfTracker.Milestone.DataProcessingCompleted.Subphase.DataUpdate,
						v14
					)
				end

				return v13
			end)
		end, {
			p2,
			value,
			v5,
			conversationMessageStore,
			conversationMessageListStore,
			v6
		})

		if not FFlagAppChatMessageItemListCurrentOnSwitch then
			return useSignalState(v7)
		end

		useSignalState(v7)
		return v7(false)
	end,
	buildMessageItemList = buildMessageItemList,
	createIncrementalMessageItemList = createIncrementalMessageItemList
}
