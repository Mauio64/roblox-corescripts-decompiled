local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Rodux = require(AppChatParent.Rodux)
local LuauPolyfill = require(AppChatParent.LuauPolyfill)
local Conversations = require(AppChat.Conversations)
local ChangedParticipants = require(AppChat.Conversations.Actions.ChangedParticipants)
local HasUnreadMessages = require(AppChat.Conversations.Actions.HasUnreadMessages)
local FetchedOldestMessage = require(AppChat.Conversations.Actions.FetchedOldestMessage)
local FetchingOlderMessages = require(AppChat.Conversations.Actions.FetchingOlderMessages)
local MessageFailedToSend = Conversations.Actions.MessageFailedToSend
local MessageModerated = Conversations.Actions.MessageModerated
local ReadConversation = require(AppChat.Conversations.Actions.ReadConversation)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local ReceivedMessages = Conversations.Actions.ReceivedMessages
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local ReceivedChannelsMigrationConflict = require(AppChat.Conversations.Actions.ReceivedChannelsMigrationConflict)
local RenamedGroupConversation = require(AppChat.Conversations.Actions.RenamedGroupConversation)
local SendingMessage = Conversations.Actions.SendingMessage
local SentMessage = Conversations.Actions.SentMessage
local SetConversationLoadingStatus = require(AppChat.Conversations.Actions.SetConversationLoadingStatus)
local SetPinnedGameForConversation = require(AppChat.Conversations.Actions.SetPinnedGameForConversation)
local SetUserLeavingConversation = require(AppChat.Conversations.Actions.SetUserLeavingConversation)
local SetUserTyping = require(AppChat.Conversations.Actions.SetUserTyping)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local FriendshipDestroyed = require(AppChat.Actions.FriendshipDestroyed)
local ReloadedMessagesForConversations = require(AppChat.Conversations.Actions.ReloadedMessagesForConversations)
local ConversationModerationTypeChanged = require(AppChat.Conversations.Actions.ConversationModerationTypeChanged)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local NetworkingBlocking = require(AppChat.Http.NetworkingBlocking)
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Immutable = require(AppChatParent.AppCommonLib).Immutable
local OrderedMap = require(AppChatParent.AppCommonLib).OrderedMap
local Functional = require(AppChatParent.AppCommonLib).Functional
local MessageModel = require(AppChat.Models.MessageModel)
local Cryo = require(AppChatParent.Cryo)
local addConversation = require(AppChat.Utils.addConversation)
local getFFlagAppChatPCMFixBlocking = require(AppChatParent.SharedFlags).getFFlagAppChatPCMFixBlocking
local updateConversationReducer = require(script.Parent.updateConversationReducer)
local getOneToOneConversationIdFromFriendId = require(AppChat.Utils.getOneToOneConversationIdFromFriendId)
local getFFlagAppChatEnableManualTranslation = require(AppChat.Flags.getFFlagAppChatEnableManualTranslation)
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local FFlagAppChatEnableU13ChatOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableU13ChatOptIn
local Constants = require(AppChat.Constants)
local t1 = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = if not FFlagAppChatEnableU13ChatOptIn then nil else {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	}
}

local function markConversationAndMessagesAsRead(t2: {[any]: any}, s1: string) -- line: 76
	-- upvalues: Immutable (copy)
	local v58 = t2[s1]

	if not v58 then
		warn("Conversation " .. s1 .. " not found in ReadConversation reducer")

		return t2
	end

	assert(v58, "FFlagLuauTinyControlFlowAnalysis")

	local v59 = v58.messages:Map(function(p1) -- line: 85
		-- upvalues: Immutable (copy)
		if p1.read then
			return p1
		end

		return Immutable.Set(p1, "read", true)
	end)
	local v60 = Immutable.Set(v58, "messages", v59)
	local v61 = Immutable.Set(v60, "hasUnreadMessages", false)

	return (Immutable.Set(t2, v61.id, v61))
end
local function addMessagesToConversation(t3: {[any]: any}, s2: string, t4: {[any]: any}) -- line: 101
	-- upvalues: Immutable (copy), OrderedMap (copy)
	local v65 = t3[s2]

	if v65 then
		local v66 = nil
		local previewMessageId = v65.previewMessageId
		local n1 = 0

		if previewMessageId and v65.messages then
			local v69 = v65.messages:Get(previewMessageId)

			if v69 then
				n1 = v69.sent:GetUnixTimestamp()
			end
		end

		for i = 1, #t4.messages do
			local v71 = t4.messages[i]
			local v72 = v65.messages:Get(v71.id)

			if v72 then
				if v66 then
					v66.previousMessageId = v72.id
				end

				if v71.previousMessageId == nil and v72.previousMessageId ~= nil then
					v71.previousMessageId = v72.previousMessageId
				end

				v71.read = v71.read or v72.read
			elseif v71.isPreviewable and n1 < v71.sent:GetUnixTimestamp() then
				previewMessageId = v71.id
				n1 = v71.sent:GetUnixTimestamp()
			end

			v66 = v71
		end

		local v73 = Immutable.JoinDictionaries(v65, {
			previewMessageId = previewMessageId
		})
		local v74 = OrderedMap.Insert(v73.messages, unpack(t4.messages))

		if t4.exclusiveStartMessageId and #t4.messages > 0 and v74:Get(t4.exclusiveStartMessageId) then
			local v75 = t4.messages[1]
			local v76 = v74:Get(t4.exclusiveStartMessageId)

			v74 = v74:Insert((Immutable.Set(v76, "previousMessageId", v75.id)))
		end

		local v77 = previewMessageId and (v74 and v74:Get(previewMessageId))
		local lastUpdated = v73.lastUpdated

		if v77 then
			lastUpdated = (lastUpdated and lastUpdated:GetUnixTimestamp() or 0) < v77.sent:GetUnixTimestamp() and v77.sent or v73.lastUpdated
		end

		local v79 = t4.shouldMarkConversationUnread or v73.hasUnreadMessages
		local v80 = Immutable.JoinDictionaries(v73, {
			messages = v74,
			lastUpdated = lastUpdated,
			hasUnreadMessages = v79,
			nextCursor = t4.nextCursor,
			previousCursor = t4.previousCursor
		})
		local v81 = Immutable.Set(v80, "usersTyping", {})

		return Immutable.Set(t3, v81.id, v81)
	end

	return t3
end
local function updateMessageContentToDisplay(t5: {[any]: any}, s3: string, s4: string, s5: string) -- line: 186
	-- upvalues: Immutable (copy)
	local v86 = t5[s3]

	if v86 then
		local v87 = v86.messages:Get(s4)

		if v87 then
			local v88 = Immutable.Set(v87, "contentToDisplay", s5)
			local v89 = v86.messages:Insert(v88)
			local v90 = Immutable.Set(v86, "messages", v89)

			return Immutable.Set(t5, v90.id, v90)
		end
	end

	return t5
end
local function messagesFromResponse(s6: string, p2) -- line: 206
	-- upvalues: Functional (copy), MessageModel (copy)
	if not p2 then
		return {}
	end

	local id = nil

	return (Functional.MapReverse(p2, function(p3) -- line: 213
		-- upvalues: MessageModel (copy), s6 (copy), id (ref)
		local v327 = MessageModel.fromWeb(p3, s6, id)

		id = v327.id

		return v327
	end))
end
local function messagesFromResponseOfChannelsApi(s7: string, p4) -- line: 221
	-- upvalues: MessageModel (copy)
	if not p4 then
		return {}
	end

	local id = nil
	local t6 = {}

	for i = #p4, 1, -1 do
		local v99 = p4[i]
		local v100 = MessageModel.fromChannelsApi(v99, s7, id)

		if v100 then
			table.insert(t6, v100)
			id = v100.id
		end
	end

	return t6
end
local function getMessagesFromConversationResponse(p5) -- line: 243
	return p5.messages or {}
end
local function isMessageFromSelf(p6) -- line: 249
	-- upvalues: Players (copy)
	local v103 = p6 and p6[#p6] or nil

	return not not v103 and (v103.senderTargetId == tostring(Players.LocalPlayer.UserId) or false)
end
local function getShouldMarkConversationUnread(p7, p8) -- line: 255
	-- upvalues: Players (copy)
	if not p7 or (not p7.messages or not p8) then
		return false
	end

	local v106 = p7.messages.keys[#p7.messages.keys]
	local v107 = p7.messages.values[v106]
	local v108 = v107 and (not not v107.sent and v107.sent:GetUnixTimestamp()) or 0

	for i = #p8, 1, -1 do
		local v110 = p8[i]

		if not v110 then
			continue
		end

		if v108 >= v110.sent:GetUnixTimestamp() then
			return false
		end

		if v110.senderTargetId ~= tostring(Players.LocalPlayer.UserId) and v110.isBadgeable then
			return true
		end
	end

	return false
end

return Rodux.createReducer({}, {
	[ReceivedConversation.name] = function(p9, p10) -- line: 292
		-- upvalues: updateConversationReducer (copy)
		return updateConversationReducer(p9, p10.conversation)
	end,
	[NetworkingChat.StartGroupConversation.Succeeded.name] = function(p11, p12) -- line: 295
		-- upvalues: Conversation (copy), updateConversationReducer (copy)
		local responseBody = p12.responseBody
		local v116 = Conversation.fromWeb(responseBody.conversation)

		return updateConversationReducer(p11, v116)
	end,
	[NetworkingChat.StartOneToOneConversation.Succeeded.name] = function(p13, p14) -- line: 300
		-- upvalues: Conversation (copy), updateConversationReducer (copy)
		local responseBody = p14.responseBody
		local v120 = Conversation.fromWeb(responseBody.conversation)

		return updateConversationReducer(p13, v120)
	end,
	[AppChatNetworking.rodux.CreateConversation.Succeeded.name] = function(p15, p16) -- line: 305
		-- upvalues: ConversationChannels (copy), updateConversationReducer (copy)
		local responseBody = p16.responseBody

		if responseBody and (responseBody.conversations and responseBody.conversations[1] and responseBody.conversations[1].status == "success") then
			local v124 = ConversationChannels.fromChannelsApi(responseBody.conversations[1])

			p15 = updateConversationReducer(p15, v124)
		end

		return p15
	end,
	[AppChatNetworking.rodux.DuplicateConversation.Succeeded.name] = function(p17, p18) -- line: 319
		-- upvalues: ConversationChannels (copy), addConversation (copy)
		local responseBody = p18.responseBody

		if responseBody and (responseBody.conversations and responseBody.conversations[1]) then
			local v128 = ConversationChannels.fromChannelsApi(responseBody.conversations[1])

			p17 = addConversation(p17, v128)
		end

		return p17
	end,
	[ReceivedMessages.name] = function(p19, p20) -- line: 328
		-- upvalues: addMessagesToConversation (copy)
		return addMessagesToConversation(p19, p20.conversationId, p20)
	end,
	[SendingMessage.name] = function(p21, p22) -- line: 331
		-- upvalues: OrderedMap (copy), Immutable (copy)
		local v133 = p21[p22.conversationId]

		if v133 then
			local v134 = OrderedMap.Insert(v133.sendingMessages, p22.message)
			local v135 = Immutable.Set(v133, "sendingMessages", v134)

			p21 = Immutable.Set(p21, v135.id, v135)
		end

		return p21
	end,
	[SentMessage.name] = function(p23, p24) -- line: 342
		-- upvalues: OrderedMap (copy), Immutable (copy)
		local v138 = p23[p24.conversationId]

		if v138 then
			local v139 = OrderedMap.Delete(v138.sendingMessages, p24.messageId)
			local v140 = Immutable.Set(v138, "sendingMessages", v139)

			p23 = Immutable.Set(p23, v140.id, v140)
		end

		return p23
	end,
	[RenamedGroupConversation.name] = function(p25, p26) -- line: 353
		-- upvalues: Immutable (copy)
		local conversationId = p26.conversationId
		local v144 = p25[conversationId]

		if v144 then
			local v145 = Immutable.JoinDictionaries(v144, {
				lastUpdated = p26.lastUpdated,
				title = p26.title,
				isDefaultTitle = p26.isDefaultTitle
			})

			p25 = Immutable.Set(p25, conversationId, v145)
		end

		return p25
	end,
	[HasUnreadMessages.name] = function(p27, p28) -- line: 368
		-- upvalues: Immutable (copy)
		local v148 = p28.conversation and p27[p28.conversation.id]

		if v148 then
			local v149 = Immutable.Set(v148, "hasUnreadMessages", true)

			p27 = Immutable.Set(p27, p28.conversation.id, v149)
		end

		return p27
	end,
	[ChangedParticipants.name] = function(p29, p30) -- line: 377
		-- upvalues: Immutable (copy)
		local conversationId = p30.conversationId
		local participants = p30.participants
		local v154 = p29[conversationId]

		if v154 then
			local v155 = Immutable.JoinDictionaries(v154, {
				participants = participants,
				lastUpdated = p30.lastUpdated,
				title = p30.title
			})

			p29 = Immutable.Set(p29, conversationId, v155)
		end

		return p29
	end,
	[RemovedConversation.name] = function(p31, p32) -- line: 393
		-- upvalues: Immutable (copy)
		local conversationId = p32.conversationId

		return Immutable.Set(p31, conversationId, nil)
	end,
	[SetUserTyping.name] = function(p33, p34) -- line: 397
		-- upvalues: Immutable (copy)
		local v161 = p33[p34.conversationId]

		if v161 then
			local usersTyping = v161.usersTyping
			local v163 = Immutable.Set(usersTyping, p34.userId, p34.value)
			local v164 = Immutable.Set(v161, "usersTyping", v163)

			p33 = Immutable.Set(p33, v164.id, v164)
		end

		return p33
	end,
	[FetchingOlderMessages.name] = function(p35, p36) -- line: 408
		-- upvalues: Immutable (copy)
		local v167 = p35[p36.conversationId]

		if v167 then
			local v168 = Immutable.Set(v167, "fetchingOlderMessages", p36.fetchingOlderMessages)

			p35 = Immutable.Set(p35, v168.id, v168)
		end

		return p35
	end,
	[FetchedOldestMessage.name] = function(p37, p38) -- line: 417
		-- upvalues: Immutable (copy)
		local v171 = p37[p38.conversationId]

		if v171 then
			local v172 = Immutable.Set(v171, "fetchedOldestMessage", p38.fetchedOldestMessage)

			return Immutable.Set(p37, v172.id, v172)
		end

		return p37
	end,
	[ReadConversation.name] = function(p39, p40) -- line: 426
		-- upvalues: markConversationAndMessagesAsRead (copy)
		return (markConversationAndMessagesAsRead(p39, p40.conversationId))
	end,
	[MessageModerated.name] = function(p41, p42) -- line: 429
		-- upvalues: Immutable (copy)
		local v177 = p41[p42.conversationId]

		if v177 then
			local v178 = v177.sendingMessages:Get(p42.messageId)

			if v178 then
				local v179 = Immutable.Set(v178, "moderated", true)
				local v180 = v177.sendingMessages:Insert(v179)
				local v181 = Immutable.Set(v177, "sendingMessages", v180)

				p41 = Immutable.Set(p41, v181.id, v181)
			end
		end

		return p41
	end,
	[MessageFailedToSend.name] = function(p43, p44) -- line: 443
		-- upvalues: Immutable (copy)
		local v184 = p43[p44.conversationId]

		if v184 then
			local v185 = v184.sendingMessages:Get(p44.messageId)

			if v185 then
				local v186 = Immutable.Set(v185, "failed", true)
				local v187 = v184.sendingMessages:Insert(v186)
				local v188 = Immutable.Set(v184, "sendingMessages", v187)

				p43 = Immutable.Set(p43, v188.id, v188)
			end
		end

		return p43
	end,
	[SetConversationLoadingStatus.name] = function(p45, p46) -- line: 457
		-- upvalues: Immutable (copy)
		local v191 = p45[p46.conversationId]

		if v191 then
			local v192 = Immutable.Set(v191, "initialLoadingStatus", p46.value)

			return Immutable.Set(p45, v192.id, v192)
		end

		return p45
	end,
	[SetUserLeavingConversation.name] = function(p47, p48) -- line: 466
		-- upvalues: Immutable (copy)
		local v195 = p47[p48.id]

		if v195 then
			local v196 = Immutable.Set(v195, "isUserLeaving", p48.isLeaving)

			p47 = Immutable.Set(p47, v196.id, v196)
		end

		return p47
	end,
	[SetPinnedGameForConversation.name] = function(p49, p50) -- line: 474
		-- upvalues: Immutable (copy)
		local conversationId = p50.conversationId
		local v200 = p49[conversationId]

		if v200 then
			local t7 = {
				rootPlaceId = p50.rootPlaceId,
				universeId = p50.universeId
			}
			local v202 = Immutable.JoinDictionaries(v200, {
				pinnedGame = t7
			})

			p49 = Immutable.Set(p49, conversationId, v202)
		end

		return p49
	end,
	[NetworkingChat.GetUserConversations.Succeeded.name] = function(p51, p52) -- line: 492
		-- upvalues: Conversation (copy), updateConversationReducer (copy)
		local responseBody = p52.responseBody

		for _, v in ipairs(responseBody) do
			local v208 = Conversation.fromWeb(v)

			p51 = updateConversationReducer(p51, v208)
		end

		return p51
	end,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = function(p53, p54) -- line: 501
		-- upvalues: ConversationChannels (copy), updateConversationReducer (copy), LuauPolyfill (copy), MessageModel (copy), addMessagesToConversation (copy)
		local responseBody = p54.responseBody

		if responseBody and responseBody.conversations then
			for _, v213 in responseBody.conversations do
				local v214 = ConversationChannels.fromChannelsApi(v213)

				p53 = updateConversationReducer(p53, v214)

				local v215 = v213.messages or {}

				if v215 and #v215 > 0 then
					local t8 = {
						messages = LuauPolyfill.Array.map(v215, function(p55) -- line: 511
							-- upvalues: MessageModel (copy), v214 (copy)
							return MessageModel.fromChannelsApi(p55, v214.id)
						end)
					}

					p53 = addMessagesToConversation(p53, v214.id, t8)
				end
			end
		end

		return p53
	end,
	[NetworkingChat.GetConversations.Succeeded.name] = function(p56, p57) -- line: 526
		-- upvalues: Conversation (copy), updateConversationReducer (copy)
		local responseBody = p57.responseBody

		for _, v in ipairs(responseBody) do
			local v222 = Conversation.fromWeb(v)

			p56 = updateConversationReducer(p56, v222)
		end

		return p56
	end,
	[AppChatNetworking.rodux.GetOlderMessages.Succeeded.name] = function(p58, p59) -- line: 535
		-- upvalues: messagesFromResponseOfChannelsApi (copy), addMessagesToConversation (copy), Immutable (copy)
		local conversation_id = p59.queryArgs.conversation_id
		local responseBody = p59.responseBody
		local v227 = p58[conversation_id]

		if not v227 then
			return p58
		end

		assert(v227, "FFlagLuauTinyControlFlowAnalysis")

		local v228 = v227.previousCursor or nil
		local v229 = v227.nextCursor or nil

		if not responseBody then
			return p58
		end

		local v230 = messagesFromResponseOfChannelsApi(conversation_id, responseBody.messages)
		local v231 = if responseBody.next_cursor ~= "" then responseBody.next_cursor else nil

		if v231 then
			v229 = v231
		end

		if v228 == nil then
			v228 = if responseBody.previous_cursor ~= "" then responseBody.previous_cursor else nil
		end

		local t9 = {
			messages = v230,
			nextCursor = v229,
			previousCursor = v228
		}
		local v233 = addMessagesToConversation(p58, conversation_id, t9)

		if not v231 then
			local v234 = v233[conversation_id]

			if v234 then
				local v235 = Immutable.Set(v234, "fetchedOldestMessage", true)

				v233 = Immutable.Set(v233, v235.id, v235)
			end
		end

		return v233
	end,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = function(p60, p61) -- line: 588
		-- upvalues: messagesFromResponseOfChannelsApi (copy), getShouldMarkConversationUnread (copy), addMessagesToConversation (copy)
		local conversation_id = p61.queryArgs.conversation_id
		local responseBody = p61.responseBody
		local v240 = p60[conversation_id]

		if not v240 then
			return p60
		end

		assert(v240, "FFlagLuauTinyControlFlowAnalysis")

		local v241 = v240.previousCursor or nil
		local v242 = v240.nextCursor or nil

		if not responseBody then
			return p60
		end

		local v243 = messagesFromResponseOfChannelsApi(conversation_id, responseBody.messages)

		if v242 == nil then
			v242 = if responseBody.next_cursor ~= "" then responseBody.next_cursor else nil
		end

		local v244 = if responseBody.previous_cursor ~= "" then responseBody.previous_cursor else nil

		if v244 then
			v241 = v244
		end

		local v245 = getShouldMarkConversationUnread(v240, v243)
		local t10 = {
			messages = v243,
			nextCursor = v242,
			previousCursor = v241,
			shouldMarkConversationUnread = v245
		}

		return (addMessagesToConversation(p60, conversation_id, t10))
	end,
	[NetworkingChat.GetMessages.Succeeded.name] = function(p62, p63) -- line: 630
		-- upvalues: Functional (copy), MessageModel (copy), Players (copy), addMessagesToConversation (copy), Immutable (copy)
		local conversationId = p63.queryArgs.conversationId
		local responseBody = p63.responseBody
		local t11

		if not responseBody then
			t11 = {}
		else
			local id = nil

			t11 = Functional.MapReverse(responseBody, function(p64) -- line: 213
				-- upvalues: MessageModel (copy), conversationId (copy), id (ref)
				local v330 = MessageModel.fromWeb(p64, conversationId, id)

				id = v330.id

				return v330
			end)
		end

		local t12 = {
			messages = t11
		}
		local v254 = t11 and t11[#t11] or nil

		t12.shouldMarkConversationUnread = not (not not v254 and (v254.senderTargetId == tostring(Players.LocalPlayer.UserId) or false))

		local v255 = addMessagesToConversation(p62, conversationId, t12)
		local pageSize = p63.queryArgs.pageSize

		if pageSize and pageSize > #t11 then
			local v257 = v255[conversationId]

			if not v257 then
				return v255
			end

			assert(v257, "FFlagLuauTinyControlFlowAnalysis")

			local v258 = v255[conversationId]

			if v258 then
				local v259 = Immutable.Set(v258, "fetchedOldestMessage", true)

				v255 = Immutable.Set(v255, v259.id, v259)
			end
		end

		return v255
	end,
	[NetworkingChat.GetLatestMessages.Succeeded.name] = function(p65, p66) -- line: 656
		-- upvalues: Functional (copy), MessageModel (copy), addMessagesToConversation (copy)
		local responseBody = p66.responseBody

		for _, v in ipairs(responseBody) do
			local str = tostring(v.conversationId)
			local chatMessages = v.chatMessages
			local t13

			if not chatMessages then
				t13 = {}
			else
				local id = nil

				t13 = Functional.MapReverse(chatMessages, function(p67) -- line: 213
					-- upvalues: MessageModel (copy), str (copy), id (ref)
					local v332 = MessageModel.fromWeb(p67, str, id)

					id = v332.id

					return v332
				end)
			end

			local t14 = {
				messages = t13
			}

			p65 = addMessagesToConversation(p65, str, t14)
		end

		return p65
	end,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = function(p68, p69) -- line: 668
		-- upvalues: ConversationChannels (copy), updateConversationReducer (copy), LuauPolyfill (copy), MessageModel (copy), addMessagesToConversation (copy)
		local v272 = p69.responseBody.conversations[1]

		if not v272 then
			return p68
		end

		local v273 = ConversationChannels.fromChannelsApi(v272)
		local v274 = updateConversationReducer(p68, v273)
		local v275 = v272.messages or {}

		if v275 and #v275 > 0 then
			local t15 = {
				messages = LuauPolyfill.Array.map(v275, function(p70) -- line: 682
					-- upvalues: MessageModel (copy), v273 (copy)
					return MessageModel.fromChannelsApi(p70, v273.id)
				end)
			}

			v274 = addMessagesToConversation(v274, v273.id, t15)
		end

		return v274
	end,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = function(p71, p72) -- line: 695
		-- upvalues: ConversationChannels (copy), updateConversationReducer (copy), LuauPolyfill (copy), MessageModel (copy), addMessagesToConversation (copy)
		local responseBody = p72.responseBody

		if not responseBody or not responseBody.conversations then
			return p71
		end

		for _, v281 in responseBody.conversations do
			local v282 = ConversationChannels.fromChannelsApi(v281)

			p71 = updateConversationReducer(p71, v282)

			local v283 = v281.messages or {}

			if v283 and #v283 > 0 then
				local t16 = {
					messages = LuauPolyfill.Array.map(v283, function(p73) -- line: 707
						-- upvalues: MessageModel (copy), v282 (copy)
						return MessageModel.fromChannelsApi(p73, v282.id)
					end)
				}

				p71 = addMessagesToConversation(p71, v282.id, t16)
			end
		end

		return p71
	end,
	[AppChatNetworking.rodux.MarkConversation.Succeeded.name] = function(p74, p75) -- line: 720
		-- upvalues: markConversationAndMessagesAsRead (copy)
		local v287 = p75.postBody.conversation_ids[1]

		return (markConversationAndMessagesAsRead(p74, v287))
	end,
	[NetworkingChat.MarkAsRead.Succeeded.name] = function(p76, p77) -- line: 724
		-- upvalues: markConversationAndMessagesAsRead (copy)
		local conversationId = p77.postBody.conversationId

		return (markConversationAndMessagesAsRead(p76, conversationId))
	end,
	[AppChatNetworking.rodux.TranslateUserMessage.Succeeded.name] = if not getFFlagAppChatEnableManualTranslation() then nil else function(p78, p79) -- line: 729
		-- upvalues: updateMessageContentToDisplay (copy)
		local content_to_display = p79.responseBody.content_to_display

		if p79.postBody.conversation_id and p79.postBody.message_id then
			return updateMessageContentToDisplay(p78, p79.postBody.conversation_id, p79.postBody.message_id, content_to_display)
		end

		return p78
	end,
	[ReceivedChannelsMigrationConflict.name] = function(_, _) -- line: 745
		return {}
	end,
	[FriendConversationCreated.name] = function(p82, p83) -- line: 748
		-- upvalues: Immutable (copy)
		if p82[p83.oldFriendConversationId] then
			return Immutable.Set(p82, p83.oldFriendConversationId, nil)
		end

		return p82
	end,
	[FriendshipDestroyed.name] = function(p84, p85) -- line: 755
		-- upvalues: ConversationChannels (copy), Immutable (copy)
		local v300 = if p85.userId1 == "localUserId" then if p85.userId2 == "localUserId" then nil else p85.userId2 else p85.userId1

		if not v300 then
			return p84
		end

		assert(v300, "FFlagLuauTinyControlFlowAnalysis")

		local v301 = ConversationChannels.getFriendConversationId({ v300 })

		if p84[v301] then
			return Immutable.Set(p84, v301, nil)
		end

		return p84
	end,
	[NetworkingBlocking.BlockUserById.Succeeded.name] = if not getFFlagAppChatPCMFixBlocking() then nil else function(p86, p87) -- line: 773
		-- upvalues: getOneToOneConversationIdFromFriendId (copy), Immutable (copy), ConversationChannels (copy)
		local str = tostring(p87.namedIds.users)

		if not str then
			return p86
		end

		local v305 = getOneToOneConversationIdFromFriendId(p86, str)
		local v306 = p86

		if v305 and p86[v305] then
			v306 = Immutable.Set(v306, v305, nil)
		end

		local v307 = ConversationChannels.getFriendConversationId({ str })

		if v307 and p86[v307] then
			v306 = Immutable.Set(p86, v307, nil)
		end

		return v306
	end,
	[ReloadedMessagesForConversations.name] = function(t17: {[any]: any}, p88) -- line: 796
		-- upvalues: Cryo (copy), ConversationChannels (copy)
		for _, v311 in p88.conversationIds do
			local v312 = t17[v311]

			t17 = Cryo.Dictionary.join(t17, {
				[v311] = Cryo.Dictionary.join(v312, {
					fetchedOldestMessage = false,
					messages = ConversationChannels.getEmptyMessages(),
					sendingMessages = ConversationChannels.getEmptySendingMessages(),
					previousCursor = Cryo.None,
					nextCursor = Cryo.None
				})
			})
		end

		return t17
	end,
	[ConversationModerationTypeChanged.name] = if not FFlagAppChatEnableDoubleOptIn then nil else function(p89, p90) -- line: 816
		-- upvalues: Immutable (copy)
		local conversationId = p90.conversationId
		local moderationType = p90.moderationType
		local v317 = p89[conversationId]

		if v317 then
			local v318 = Immutable.Set(v317, "moderationType", moderationType)

			return Immutable.Set(p89, conversationId, v318)
		end

		return p89
	end,
	[AppChatNetworking.rodux.RecordModalSequenceResponse.Succeeded.name] = function(p91, p92) -- line: 827
		-- upvalues: Constants (copy), t1 (copy), ConversationChannels (copy), Immutable (copy)
		local postBody = p92.postBody

		if postBody.action_type ~= Constants.ModalAction.Accept then
			return p91
		end

		local v322 = t1[postBody.modal_variant]

		if not v322 then
			return p91
		end

		local v323 = postBody.conversation_id or ConversationChannels.getFriendConversationId({ postBody.friend_id })
		local v324 = v323 and p91[v323]

		if not v324 then
			return p91
		end

		return Immutable.Set(p91, v323, Immutable.Set(v324, v322.field, v322.value))
	end
})
