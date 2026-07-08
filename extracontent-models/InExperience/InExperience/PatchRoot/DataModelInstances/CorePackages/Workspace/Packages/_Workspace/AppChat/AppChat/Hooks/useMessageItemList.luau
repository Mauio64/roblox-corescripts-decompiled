local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local Cryo = require(AppChatParent.Cryo)
local Signals = require(AppChatParent.Signals)
local DateTime = require(AppChatParent.Time).DateTime
local filterForLinksWithPolicy = require(AppChat.Components.ChatConversation.Utils.filterForLinksWithPolicy)
local populateMessageWithState = require(AppChat.Conversations.populateMessageWithState)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)

require(AppChat.MessageData.Types)

local Enums = require(AppChat.MessageData.Enums)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local MessageStatus = Enums.MessageStatus
local MessageType = Enums.MessageType

local function toLuaDateTime(s1: string?) -- line: 32
	-- upvalues: DateTime (copy)
	if s1 == nil or s1 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 36
		-- upvalues: DateTime (copy), s1 (copy)
		return DateTime.fromIsoDate(s1)
	end)

	if ok then
		return result
	end

	return nil
end
local function buildLegacyRepliesTo(p1, t1: {[any]: any}) -- line: 48
	-- upvalues: Cryo (copy), DateTime (copy), MessageType (copy)
	local replies_to = p1.replies_to

	if replies_to == nil then
		return nil
	end

	local v29 = t1[replies_to.id]

	if v29 ~= nil then
		local join = Cryo.Dictionary.join
		local t2 = {
			senderTargetId = tostring(v29.sender_user_id)
		}
		local created_at = v29.created_at
		local v33

		if created_at == nil or created_at == "" then
			v33 = nil
		else
			local ok, result = pcall(function() -- line: 36
				-- upvalues: DateTime (copy), created_at (copy)
				return DateTime.fromIsoDate(created_at)
			end)

			v33 = if not ok then nil else result
		end

		t2.sent = v33
		t2.messageType = v29.type ~= MessageType.System and "PlainText" or "System"

		return join(v29, t2)
	end

	local t3 = {
		id = replies_to.id,
		content = replies_to.content,
		messageType = replies_to.type ~= MessageType.System and "PlainText" or "System",
		senderTargetId = tostring(replies_to.sender_user_id)
	}
	local created_at = replies_to.created_at
	local v38

	if created_at == nil or created_at == "" then
		v38 = nil
	else
		local ok, result = pcall(function() -- line: 36
			-- upvalues: DateTime (copy), created_at (copy)
			return DateTime.fromIsoDate(created_at)
		end)

		v38 = if not ok then nil else result
	end

	t3.sent = v38

	return t3
end
local function toLegacyMessage(p2, t4: {[any]: any}) -- line: 75
	-- upvalues: MessageType (copy), Cryo (copy), DateTime (copy), MessageStatus (copy), buildLegacyRepliesTo (copy)
	local v43 = p2.type ~= MessageType.System and "PlainText" or "System"
	local join = Cryo.Dictionary.join
	local t5 = {
		senderTargetId = tostring(p2.sender_user_id),
		senderType = p2.type,
		messageType = p2.messageType or v43
	}
	local created_at = p2.created_at
	local v47

	if created_at == nil or created_at == "" then
		v47 = nil
	else
		local ok, result = pcall(function() -- line: 36
			-- upvalues: DateTime (copy), created_at (copy)
			return DateTime.fromIsoDate(created_at)
		end)

		v47 = if not ok then nil else result
	end

	t5.sent = v47
	t5.moderationType = p2.moderation_type
	t5.moderated = p2.status == MessageStatus.Moderated
	t5.failed = p2.status == MessageStatus.Failed
	t5.isSending = p2.status == MessageStatus.Pending
	t5.filteredForReceivers = p2.filtered_for_receivers
	t5.contentToDisplay = p2.content_to_display
	t5.repliesTo = buildLegacyRepliesTo(p2, t4)

	return join(p2, t5)
end
local function applyGroupedVariant(p3, s2: string?) -- line: 93
	-- upvalues: Enums (copy)
	if s2 == nil then
		return p3
	end

	local GroupedMessageVariant = Enums.GroupedMessageVariant

	if s2 == GroupedMessageVariant.Single then
		p3.isNewSender = true
		p3.isLastMessageInMessageGroup = true

		return p3
	end

	if s2 == GroupedMessageVariant.First then
		p3.isNewSender = true
		p3.isLastMessageInMessageGroup = false

		return p3
	end

	if s2 == GroupedMessageVariant.Middle then
		p3.isNewSender = false
		p3.isLastMessageInMessageGroup = false

		return p3
	end

	if s2 == GroupedMessageVariant.Last then
		p3.isNewSender = false
		p3.isLastMessageInMessageGroup = true
	end

	return p3
end
local function buildPopulatedMessage(p4, s3: string?, p5, p6, p7, p8, s4: string, n1: number) -- line: 117
	-- upvalues: populateMessageWithState (copy), Enums (copy)
	local t6 = {
		Users = p8,
		LocalUserId = s4
	}
	local v62 = populateMessageWithState(t6, p4, p4.id, p7, p5, p4.isSending == true, p6)

	if s3 == nil then
	else
		local GroupedMessageVariant = Enums.GroupedMessageVariant

		if s3 == GroupedMessageVariant.Single then
			v62.isNewSender = true
			v62.isLastMessageInMessageGroup = true
		elseif s3 == GroupedMessageVariant.First then
			v62.isNewSender = true
			v62.isLastMessageInMessageGroup = false
		elseif s3 == GroupedMessageVariant.Middle then
			v62.isNewSender = false
			v62.isLastMessageInMessageGroup = false
		elseif s3 == GroupedMessageVariant.Last then
			v62.isNewSender = false
			v62.isLastMessageInMessageGroup = true
		end
	end

	v62.stable_key = `{ v62.stableKey or v62.messageId }_{ n1 }`

	return v62
end
local function buildMessageItemList(t7: {[any]: any}, t8: {[any]: any}, p9: ((...any) -> ...any), p10, p11, s5: string) -- line: 157
	-- upvalues: Cryo (copy), toLegacyMessage (copy), filterForLinksWithPolicy (copy), buildPopulatedMessage (copy)
	if #t7 == 0 or p10 == nil then
		return {}
	end

	local v70 = Cryo.List.filterMap(t7, function(p12) -- line: 169
		-- upvalues: t8 (copy), toLegacyMessage (copy)
		local v93 = t8[p12]

		if v93 == nil then
			return nil
		end

		return toLegacyMessage(v93, t8)
	end)
	local t9 = {}
	local v72 = nil

	for i = #v70, 1, -1 do
		local v74 = v70[i]
		local v75 = filterForLinksWithPolicy(v74)
		local v76 = if not (i > 1) then nil else v70[i - 1]
		local v77 = p9(v74.id)

		for v78, v79 in v75 do
			local v80 = v75[v78 + 1] or v76
			local v81 = if #v75 ~= 1 then nil else v77

			v72 = buildPopulatedMessage(v79, v81, v72, v80, p10, p11, s5, v78)
			table.insert(t9, v72)
		end
	end

	return Cryo.List.reverse(t9)
end

return {
	useMessageItemList = function(s6: string?, p13, s7: string?, p14) -- line: 218
		-- upvalues: React (copy), GetConversationMessageViewModelStore (copy), Signals (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), buildMessageItemList (copy), useSignalState (copy)
		local v86 = React.useMemo(function() -- line: 219
			-- upvalues: GetConversationMessageViewModelStore (copy)
			return GetConversationMessageViewModelStore(false)
		end, {})
		local conversationMessageStore = v86.conversationMessageStore
		local conversationMessageListStore = v86.conversationMessageListStore
		local v89 = React.useRef(p14)

		v89.current = p14

		local v90 = React.useRef(p13)

		v90.current = p13

		local v91 = React.useMemo(function() -- line: 232
			-- upvalues: s6 (copy), Signals (copy), conversationMessageListStore (copy), conversationMessageStore (copy), s7 (copy), v89 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), buildMessageItemList (copy), v86 (copy), v90 (copy)
			if s6 == nil then
				return Signals.createComputed(function() -- line: 234
					return {}
				end)
			end

			return Signals.createComputed(function(p15) -- line: 239
				-- upvalues: conversationMessageListStore (copy), s6 (copy), conversationMessageStore (copy), s7 (copy), v89 (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), buildMessageItemList (copy), v86 (copy), v90 (copy)
				local v95 = conversationMessageListStore.getOrderedIds(s6, p15)
				local v96 = conversationMessageStore.messages(p15)
				local str = tostring(s7 or "")

				if v89.current == nil then
					return {}
				end

				local v98 = FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
					conversationId = s6
				}))

				if v98 then
					local t10 = {
						conversationId = s6
					}

					AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingStarted.Name, t10)
					AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingStarted.Name, AppChatPerfTracker.Milestone.DataProcessingStarted.Subphase.DataUpdate, t10)
				end

				local v100 = buildMessageItemList(v95, v96, function(p16) -- line: 268
					-- upvalues: v86 (copy), s6 (copy), p15 (copy)
					return v86.getGroupedVariant(p16, s6)(p15)
				end, v89.current, v90.current, str)

				if v98 then
					local t11 = {
						conversationId = s6
					}

					AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingCompleted.Name, t11)
					AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingCompleted.Name, AppChatPerfTracker.Milestone.DataProcessingCompleted.Subphase.DataUpdate, t11)
				end

				return v100
			end)
		end, {
			s6,
			s7,
			v86,
			conversationMessageStore,
			conversationMessageListStore
		})

		return useSignalState(v91)
	end,
	buildMessageItemList = buildMessageItemList
}
