local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local filterForLinksWithPolicy = require(AppChat.Components.ChatConversation.Utils.filterForLinksWithPolicy)
local populateMessageWithState = require(AppChat.Conversations.populateMessageWithState)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
require(AppChat.MessageData.Types)
local Enums = require(AppChat.MessageData.Enums)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local FFlagAppChatIncrementalMessageItemList = require(AppChat.Flags.FFlagAppChatIncrementalMessageItemList)
local FFlagAppChatParseMessageTimestampsOnce = require(AppChat.Flags.FFlagAppChatParseMessageTimestampsOnce)
local FFlagAppChatFixMessageItemListStaleRefs = require(AppChat.Flags.FFlagAppChatFixMessageItemListStaleRefs)
local FFlagAppChatMessageItemListCurrentOnSwitch = require(AppChat.Flags.FFlagAppChatMessageItemListCurrentOnSwitch)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local MessageStatus = Enums.MessageStatus
local MessageType = Enums.MessageType

local function toLuaDateTime(created_at: string?) -- 1 equivalent call inferred from this helper
	if created_at == nil or created_at == "" then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(created_at)
	end)
	return if success then result else nil
end

local function toLuaDateTimeFromMessage(p)
	local createdAtUnixMillis = p.createdAtUnixMillis

	if createdAtUnixMillis ~= nil then
		return DateTime.fromUnixTimestampMillis(createdAtUnixMillis)
	end

	return toLuaDateTime(p.created_at) -- inferred equivalent call
end

local function buildLegacyRepliesTo(data, p)
	local replies_to = data.replies_to

	if replies_to == nil then
		return nil
	end

	local v = p[replies_to.id]

	if v == nil then
		local v2 = {
			id = replies_to.id,
			content = replies_to.content,
			messageType = replies_to.type == MessageType.System and "System" or "PlainText",
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
						return DateTime.fromIsoDate(created_at)
					end)

					if not success then
						result = nil
					end
				end
			else
				result = DateTime.fromUnixTimestampMillis(createdAtUnixMillis)
			end
		else
			local created_at = replies_to.created_at

			if not (created_at == nil or created_at == "") then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		end

		v2.sent = result
		return v2
	else
		local join = Cryo.Dictionary.join
		local v2 = { senderTargetId = tostring(v.sender_user_id), sent = 0, messageType = 0 }
		local result

		if FFlagAppChatParseMessageTimestampsOnce then
			local createdAtUnixMillis = v.createdAtUnixMillis

			if createdAtUnixMillis == nil then
				local created_at = v.created_at

				if not (created_at == nil or created_at == "") then
					local success
					success, result = pcall(function()
						return DateTime.fromIsoDate(created_at)
					end)

					if not success then
						result = nil
					end
				end
			else
				result = DateTime.fromUnixTimestampMillis(createdAtUnixMillis)
			end
		else
			local created_at = v.created_at

			if not (created_at == nil or created_at == "") then
				local success
				success, result = pcall(function()
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		end

		v2.sent = result

		v2.messageType = v.type == MessageType.System and "System" or "PlainText"
		return join(v, v2)
	end
end

local function toLegacyMessage(data, p)
	local v = data.type == MessageType.System and "System" or "PlainText"
	local join = Cryo.Dictionary.join
	local v2 = {
		senderTargetId = tostring(data.sender_user_id),
		senderType = data.type,
		messageType = data.messageType or v,
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
					return DateTime.fromIsoDate(created_at)
				end)

				if not success then
					result = nil
				end
			end
		else
			result = DateTime.fromUnixTimestampMillis(createdAtUnixMillis)
		end
	else
		local created_at = data.created_at

		if not (created_at == nil or created_at == "") then
			local success
			success, result = pcall(function()
				return DateTime.fromIsoDate(created_at)
			end)

			if not success then
				result = nil
			end
		end
	end

	v2.sent = result

	v2.moderationType = data.moderation_type
	v2.moderated = data.status == MessageStatus.Moderated
	v2.failed = data.status == MessageStatus.Failed
	v2.isSending = data.status == MessageStatus.Pending
	v2.filteredForReceivers = data.filtered_for_receivers
	v2.contentToDisplay = data.content_to_display
	v2.repliesTo = buildLegacyRepliesTo(data, p)
	return join(data, v2)
end

local function applyGroupedVariant(p, p2: string?) -- 1 equivalent call inferred from this helper
	if p2 == nil then
		return p
	end

	local groupedMessageVariant = Enums.GroupedMessageVariant

	if p2 == groupedMessageVariant.Single then
		p.isNewSender = true
		p.isLastMessageInMessageGroup = true
	elseif p2 == groupedMessageVariant.First then
		p.isNewSender = true
		p.isLastMessageInMessageGroup = false
	elseif p2 == groupedMessageVariant.Middle then
		p.isNewSender = false
		p.isLastMessageInMessageGroup = false
	elseif p2 == groupedMessageVariant.Last then
		p.isNewSender = false
		p.isLastMessageInMessageGroup = true
	end

	return p
end

local function buildPopulatedMessage(p, p2: string?, p3, p4, p5, users, localUserId: string, k: number)
	local populatedMessage = applyGroupedVariant( -- inferred equivalent call
		populateMessageWithState({ Users = users, LocalUserId = localUserId }, p, p.id, p5, p3, p.isSending == true, p4),
		p2
	)

	populatedMessage.stable_key = `{populatedMessage.stableKey or populatedMessage.messageId}_{k}`
	return populatedMessage
end

local function buildMessageRows(p, p2, p3, p4: string?, p5, users, localUserId: string)
	local v = filterForLinksWithPolicy(p)
	local messageRows = table.create(#v)

	for k, v2 in v do
		local v3 = v[k + 1] or p2
		local v4

		if #v == 1 then
			v4 = p4
		end

		p3 = buildPopulatedMessage(v2, v4, p3, v3, p5, users, localUserId, k)

		table.insert(messageRows, p3)
	end

	return messageRows
end

local function buildMessageItemList(list, p, callback, p2, users, localUserId: string)
	if #list == 0 or p2 == nil then
		return {}
	end

	local filterMap = Cryo.List.filterMap(list, function(p3)
		local v = p[p3]

		if v == nil then
			return nil
		end

		return toLegacyMessage(v, p)
	end)
	local v = nil
	local messageRows = {}

	for i = #filterMap, 1, -1 do
		local filter = filterMap[i]
		local v2

		if i > 1 then
			v2 = filterMap[i - 1]
		end

		local messageRows2 = buildMessageRows(filter, v2, v, callback(filter.id), p2, users, localUserId)

		for _, messageRow in messageRows2 do
			table.insert(messageRows, messageRow)
		end

		v = messageRows2[#messageRows2] or v
	end

	return Cryo.List.reverse(messageRows)
end

local function createIncrementalMessageItemList()
	local v = {}
	local v2 = {}
	local v3 = 0
	local id = nil
	local conversationType = nil
	local v4 = nil

	return function(list, p, callback, data, users, localUserId: string)
		if #list == 0 or data == nil then
			v = {}
			v3 = 0

			if #v2 > 0 then
				v2 = {}
			end

			return v2
		else
			if data.id ~= id or data.conversationType ~= conversationType or localUserId ~= v4 then
				v = {}
				id = data.id
				conversationType = data.conversationType
				v4 = localUserId
			end

			local v5 = {}

			for _, item in list do
				local v6 = p[item]

				if v6 ~= nil then
					table.insert(v5, v6)
				end
			end

			local function getReplyTarget(p2) -- 4 equivalent calls inferred from this helper
				if p2.replies_to == nil then
					return nil
				end

				return p[p2.replies_to.id]
			end

			local v6 = {}
			local function getLegacyMessage(p2)
				local v7 = v6[p2.id]

				if v7 ~= nil then
					return v7
				end

				local v8 = v[p2.id]
				local v9

				if v8 == nil or v8.message ~= p2 then
					v9 = toLegacyMessage(p2, p)
				elseif v8.replyTarget == getReplyTarget(p2) then -- inferred equivalent call
					v9 = v8.legacyMessage
				else
					v9 = toLegacyMessage(p2, p)
				end

				v6[p2.id] = v9
				return v9
			end

			local v7 = nil
			local v8 = {}
			local total = 0
			local v9 = false

			for i = #v5, 1, -1 do
				local message = v5[i]
				local olderMessage = v5[i + 1]
				local newerMessage = v5[i - 1]
				local replyTarget = getReplyTarget(message) -- inferred equivalent call
				local groupedVariant = callback(message.id)
				local hasSender

				if users == nil then
					hasSender = false
				else
					hasSender = users[tostring(message.sender_user_id)] ~= nil
				end

				local showsOldestDateTime

				if olderMessage == nil then
					showsOldestDateTime = data.fetchedOldestMessage == true
				else
					showsOldestDateTime = false
				end

				local v10 = v[message.id]

				if
					v10 == nil
					or v10.message ~= message
					or v10.replyTarget ~= replyTarget
					or v10.olderMessage ~= olderMessage
					or v10.newerMessage ~= newerMessage
					or v10.groupedVariant ~= groupedVariant
					or v10.hasSender ~= hasSender
					or v10.showsOldestDateTime ~= showsOldestDateTime
				then
					v9 = true
					local legacyMessage = v6[message.id]

					if legacyMessage == nil then
						local v11 = v[message.id]

						if v11 == nil or v11.message ~= message then
							legacyMessage = toLegacyMessage(message, p)
						elseif v11.replyTarget == getReplyTarget(message) then -- inferred equivalent call
							legacyMessage = v11.legacyMessage
						else
							legacyMessage = toLegacyMessage(message, p)
						end

						v6[message.id] = legacyMessage
					end

					local v11

					if newerMessage ~= nil then
						v11 = v6[newerMessage.id]

						if v11 == nil then
							local v12 = v[newerMessage.id]

							if v12 == nil or v12.message ~= newerMessage then
								v11 = toLegacyMessage(newerMessage, p)
							elseif v12.replyTarget == getReplyTarget(newerMessage) then -- inferred equivalent call
								v11 = v12.legacyMessage
							else
								v11 = toLegacyMessage(newerMessage, p)
							end

							v6[newerMessage.id] = v11
						end
					end

					v10 = {
						message = message,
						replyTarget = replyTarget,
						legacyMessage = legacyMessage,
						olderMessage = olderMessage,
						newerMessage = newerMessage,
						groupedVariant = groupedVariant,
						hasSender = hasSender,
						showsOldestDateTime = showsOldestDateTime,
						rows = buildMessageRows(legacyMessage, v11, v7, groupedVariant, data, users, localUserId)
					}
				end

				v8[message.id] = v10
				total += #v10.rows
				v7 = v10.rows[#v10.rows] or v7
			end

			v = v8

			if not v9 and #v5 == v3 then
				return v2
			end

			v3 = #v5

			local result = table.create(total)

			for _, v10 in v5 do
				local rows = v8[v10.id].rows

				for i = #rows, 1, -1 do
					table.insert(result, rows[i])
				end
			end

			v2 = result
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

local function useItemListInputs(p: string?, current, current2, p2)
	local conversationMessageStore = p2.conversationMessageStore
	local conversationMessageListStore = p2.conversationMessageListStore

	local v = React.useMemo(function()
		local signal, setConversation = Signals.createSignal(current, isSameItemListConversation)
		local signal2, setUsers = Signals.createSignal(current2)

		return {
			getConversation = signal,
			setConversation = setConversation,
			getUsers = signal2,
			setUsers = setUsers,
			getKnownSenderIds = Signals.createComputed(function(p3)
				local sender_user_idSet = {}
				local v = signal2(p3)

				if p == nil or v == nil then
					return sender_user_idSet
				end

				local messages = conversationMessageStore.messages(p3)

				for _, v2 in conversationMessageListStore.getOrderedIds(p, p3) do
					local message = messages[v2]

					if message == nil then
						continue
					end

					local sender_user_id = tostring(message.sender_user_id)

					if v[sender_user_id] ~= nil then
						sender_user_idSet[sender_user_id] = true
					end
				end

				return sender_user_idSet
			end, isSameUserIdSet)
		}
	end, { p, conversationMessageStore, conversationMessageListStore })

	React.useLayoutEffect(function()
		SignalsExperimental.batch(function()
			v.setConversation(current)
			v.setUsers(current2)
		end)
	end, { v, current, current2 })

	return v
end

return {
	useMessageItemList = function(conversationId: string?, current, value: string?, current2)
		local v = React.useMemo(function()
			return GetConversationMessageViewModelStore(false)
		end, {})
		local conversationMessageStore = v.conversationMessageStore
		local conversationMessageListStore = v.conversationMessageListStore

		local ref = React.useRef(current2)
		ref.current = current2
		local ref2 = React.useRef(current)
		ref2.current = current
		local v2

		if FFlagAppChatFixMessageItemListStaleRefs then
			v2 = useItemListInputs(conversationId, current2, current, v)
		else
			v2 = nil
		end

		local v3 = React.useMemo(function()
			if conversationId == nil then
				return Signals.createComputed(function()
					return {}
				end)
			end

			local v3

			if FFlagAppChatIncrementalMessageItemList then
				v3 = createIncrementalMessageItemList()
			else
				v3 = buildMessageItemList
			end

			return Signals.createComputed(function(p)
				local orderedIds = conversationMessageListStore.getOrderedIds(conversationId, p)
				local messages = conversationMessageStore.messages(p)
				local v4 = tostring(value or "")

				local v5 = ref.current
				local v6 = ref2.current

				if FFlagAppChatFixMessageItemListStaleRefs then
					local v7 = v2
					v5 = v7.getConversation(p)
					v7.getKnownSenderIds(p)
					v6 = v7.getUsers(false)
				end

				if v5 == nil then
					return {}
				end

				local v7 = FFlagAppChatPerfTracking
					and FFlagAppChatMessageTTIMilestones
					and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = conversationId
					})

				if v7 then
					local v8 = { conversationId = conversationId }
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
						v8
					)

					AppChatPerfTracker.trackSubphase(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
						AppChatPerfTracker.Milestone.DataProcessingStarted.Subphase.DataUpdate,
						v8
					)
				end

				local v8 = v3(orderedIds, messages, function(p2)
					return v.getGroupedVariant(p2, conversationId)(p)
				end, v5, v6, v4)

				if v7 then
					local v9 = { conversationId = conversationId }
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
						v9
					)

					AppChatPerfTracker.trackSubphase(
						AppChatPerfTracker.Events.ChatConversationTTI,
						AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
						AppChatPerfTracker.Milestone.DataProcessingCompleted.Subphase.DataUpdate,
						v9
					)
				end

				return v8
			end)
		end, {
			conversationId,
			value,
			v,
			conversationMessageStore,
			conversationMessageListStore,
			v2
		})

		if not FFlagAppChatMessageItemListCurrentOnSwitch then
			return useSignalState(v3)
		end

		useSignalState(v3)
		return v3(false)
	end,
	buildMessageItemList = buildMessageItemList,
	createIncrementalMessageItemList = createIncrementalMessageItemList
}
