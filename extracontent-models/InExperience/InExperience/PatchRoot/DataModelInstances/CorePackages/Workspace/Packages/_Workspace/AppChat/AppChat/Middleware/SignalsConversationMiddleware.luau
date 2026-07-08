local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local Constants = require(AppChat.Constants)
local Conversations = require(AppChat.Conversations)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Conversation = require(AppChat.Models.Conversation)
local MessageModel = require(AppChat.Models.MessageModel)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local GetConversationListStore = require(AppChat.Stores.GetConversationListStore)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local NetworkingBlocking = require(AppChat.Http.NetworkingBlocking)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local ChangedParticipants = require(AppChat.Conversations.Actions.ChangedParticipants)
local ConversationModerationTypeChanged = require(AppChat.Conversations.Actions.ConversationModerationTypeChanged)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local FriendshipDestroyed = require(AppChat.Actions.FriendshipDestroyed)
local HasUnreadMessages = require(AppChat.Conversations.Actions.HasUnreadMessages)
local ReadConversation = require(AppChat.Conversations.Actions.ReadConversation)
local ReceivedChannelsMigrationConflict = require(AppChat.Conversations.Actions.ReceivedChannelsMigrationConflict)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local ReceivedLatestMessages = require(AppChat.Conversations.Actions.ReceivedLatestMessages)
local ReceivedOldestConversation = require(AppChat.Conversations.Actions.ReceivedOldestConversation)
local ReceivedPageConversations = require(AppChat.Conversations.Actions.ReceivedPageConversations)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local RenamedGroupConversation = require(AppChat.Conversations.Actions.RenamedGroupConversation)
local RequestLatestMessages = require(AppChat.Conversations.Actions.RequestLatestMessages)
local RequestPageConversations = require(AppChat.Conversations.Actions.RequestPageConversations)
local ReceivedMessages = Conversations.Actions.ReceivedMessages
local SetConversationLoadingStatus = require(AppChat.Conversations.Actions.SetConversationLoadingStatus)
local SetPinnedGameForConversation = require(AppChat.Conversations.Actions.SetPinnedGameForConversation)
local SetUserLeavingConversation = require(AppChat.Conversations.Actions.SetUserLeavingConversation)
local SetUserTyping = require(AppChat.Conversations.Actions.SetUserTyping)
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local t1 = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	}
}

local function upsertConversationResponse(p1, p2) -- line: 56
	-- upvalues: ConversationChannels (copy)
	if p2 == nil or p2.status == "failed" then
		return
	end

	p1.upsertConversation(ConversationChannels.fromChannelsApi(p2))
end
local function upsertConversationResponses(p3, p4) -- line: 63
	-- upvalues: ConversationChannels (copy)
	if p4 == nil or p4.conversations == nil then
		return
	end

	for _, v90 in p4.conversations do
		if v90 ~= nil and v90.status ~= "failed" then
			p3.upsertConversation(ConversationChannels.fromChannelsApi(v90))
		end
	end
end
local function updateConversation(p5, s1: string?, t2: {[any]: any}) -- line: 72
	-- upvalues: Cryo (copy)
	if s1 == nil then
		return
	end

	local v94 = p5.getConversation(s1, false)

	if v94 == nil then
		return
	end

	p5.upsertConversation(Cryo.Dictionary.join(v94, t2), false)
end
local function getUnixTimestamp(p6) -- line: 83
	if p6 == nil then
		return nil
	end

	if typeof(p6) == "DateTime" then
		return p6.UnixTimestamp
	end

	if type(p6) == "table" and p6.GetUnixTimestamp ~= nil then
		return p6:GetUnixTimestamp()
	end

	return nil
end
local function getDateTimeFromIsoDate(p7) -- line: 96
	if type(p7) ~= "string" then
		return nil
	end

	local ok, result = pcall(function() -- line: 101
		-- upvalues: p7 (copy)
		return DateTime.fromIsoDate(p7)
	end)

	if ok then
		return result
	end

	return nil
end
local function getMessageSentTime(p8) -- line: 107
	if p8.sent ~= nil then
		if type(p8.sent) == "string" then
			local sent = p8.sent

			if type(sent) ~= "string" then
				return nil
			end

			local ok, result = pcall(function() -- line: 101
				-- upvalues: sent (copy)
				return DateTime.fromIsoDate(sent)
			end)

			if ok then
				return result
			end

			return nil
		end

		return p8.sent
	end

	local v103 = p8.created_at or p8.createdAt

	if type(v103) ~= "string" then
		return nil
	end

	local ok, result = pcall(function() -- line: 101
		-- upvalues: v103 (copy)
		return DateTime.fromIsoDate(v103)
	end)

	if ok then
		return result
	end

	return nil
end
local function messagesFromWebResponse(s2: string, t3: {[any]: any}?) -- line: 114
	-- upvalues: MessageModel (copy)
	if t3 == nil then
		return {}
	end

	local id = nil
	local t4 = {}

	for i = #t3, 1, -1 do
		local v111 = t3[i]
		local v112 = MessageModel.fromWeb(v111, s2, id)

		if v112 ~= nil then
			v112.isPreviewable = v111.is_previewable
			v112.isBadgeable = v111.is_badgeable
			id = v112.id
			table.insert(t4, 1, v112)
		end
	end

	return t4
end
local function isMessagePreviewable(p9) -- line: 134
	if p9.isPreviewable ~= nil then
		return p9.isPreviewable
	end

	if p9.is_previewable ~= nil then
		return p9.is_previewable
	end

	return false
end
local function getNewestMessageUnixTime(s3: string?) -- line: 144
	-- upvalues: GetConversationMessageViewModelStore (copy)
	if s3 == nil then
		return 0
	end

	local v115 = GetConversationMessageViewModelStore(false)
	local v116 = v115.conversationMessageListStore.getOrderedIds(s3, false)[1]
	local v117 = v116 and v115.conversationMessageStore.getMessage(v116, false)

	if v117 then
		if v117.sent ~= nil then
			if type(v117.sent) == "string" then
				local sent = v117.sent

				if type(sent) ~= "string" then
					v117 = nil
				else
					local ok, result = pcall(function() -- line: 101
						-- upvalues: sent (copy)
						return DateTime.fromIsoDate(sent)
					end)

					v117 = if not ok then nil else result
				end
			else
				v117 = v117.sent
			end
		else
			local v121 = v117.created_at or v117.createdAt

			if type(v121) ~= "string" then
				v117 = nil
			else
				local ok, result = pcall(function() -- line: 101
					-- upvalues: v121 (copy)
					return DateTime.fromIsoDate(v121)
				end)

				v117 = if not ok then nil else result
			end
		end
	end

	return ((if v117 ~= nil then (if typeof(v117) ~= "DateTime" then (if type(v117) ~= "table" or v117.GetUnixTimestamp == nil then nil else v117:GetUnixTimestamp()) else v117.UnixTimestamp) else nil)) or 0
end
local function shouldMarkConversationUnreadFromMessages(s4: string?, t5: {[any]: any}?) -- line: 158
	-- upvalues: getNewestMessageUnixTime (copy), Players (copy)
	if t5 == nil then
		return false
	end

	local v126 = getNewestMessageUnixTime(s4)
	local str = tostring(Players.LocalPlayer.UserId)

	for _, v129 in t5 do
		local v131

		if v129.sent ~= nil then
			if type(v129.sent) == "string" then
				local sent = v129.sent

				if type(sent) ~= "string" then
					v131 = nil
				else
					local ok, result = pcall(function() -- line: 101
						-- upvalues: sent (copy)
						return DateTime.fromIsoDate(sent)
					end)

					v131 = if not ok then nil else result
				end
			else
				v131 = v129.sent
			end
		else
			local v134 = v129.created_at or v129.createdAt

			if type(v134) ~= "string" then
				v131 = nil
			else
				local ok, result = pcall(function() -- line: 101
					-- upvalues: v134 (copy)
					return DateTime.fromIsoDate(v134)
				end)

				v131 = if not ok then nil else result
			end
		end

		local v137 = if v131 ~= nil then if typeof(v131) ~= "DateTime" then if type(v131) ~= "table" or v131.GetUnixTimestamp == nil then nil else v131:GetUnixTimestamp() else v131.UnixTimestamp else nil
		local v138 = v129.sender_user_id or v129.senderTargetId

		if v137 ~= nil and v126 < v137 and v138 ~= nil and str ~= tostring(v138) and v129.is_badgeable == true then
			return true
		end
	end

	return false
end
local function getPreviewMessageUnixTime(p10) -- line: 181
	-- upvalues: GetConversationMessageViewModelStore (copy)
	if p10.previewMessageId == nil then
		return 0
	end

	local v140 = GetConversationMessageViewModelStore(false).conversationMessageStore.getMessage(p10.previewMessageId, false)

	if v140 then
		if v140.sent ~= nil then
			if type(v140.sent) == "string" then
				local sent = v140.sent

				if type(sent) ~= "string" then
					v140 = nil
				else
					local ok, result = pcall(function() -- line: 101
						-- upvalues: sent (copy)
						return DateTime.fromIsoDate(sent)
					end)

					v140 = if not ok then nil else result
				end
			else
				v140 = v140.sent
			end
		else
			local v144 = v140.created_at or v140.createdAt

			if type(v144) ~= "string" then
				v140 = nil
			else
				local ok, result = pcall(function() -- line: 101
					-- upvalues: v144 (copy)
					return DateTime.fromIsoDate(v144)
				end)

				v140 = if not ok then nil else result
			end
		end
	end

	return ((if v140 ~= nil then (if typeof(v140) ~= "DateTime" then (if type(v140) ~= "table" or v140.GetUnixTimestamp == nil then nil else v140:GetUnixTimestamp()) else v140.UnixTimestamp) else nil)) or 0
end
local function updateConversationLastUpdatedFromMessages(p11, s5: string?, t6: {[any]: any}?, b1: boolean?) -- line: 192
	-- upvalues: GetConversationMessageViewModelStore (copy), Cryo (copy)
	if s5 == nil or t6 == nil then
		return
	end

	local v151 = p11.getConversation(s5, false)

	if v151 == nil then
		return
	end

	local v152 = nil
	local id = nil
	local n1

	if v151.previewMessageId == nil then
		n1 = 0
	else
		local v155 = GetConversationMessageViewModelStore(false).conversationMessageStore.getMessage(v151.previewMessageId, false)

		if v155 then
			if v155.sent ~= nil then
				if type(v155.sent) == "string" then
					local sent = v155.sent

					if type(sent) ~= "string" then
						v155 = nil
					else
						local ok, result = pcall(function() -- line: 101
							-- upvalues: sent (copy)
							return DateTime.fromIsoDate(sent)
						end)

						v155 = if not ok then nil else result
					end
				else
					v155 = v155.sent
				end
			else
				local v159 = v155.created_at or v155.createdAt

				if type(v159) ~= "string" then
					v155 = nil
				else
					local ok, result = pcall(function() -- line: 101
						-- upvalues: v159 (copy)
						return DateTime.fromIsoDate(v159)
					end)

					v155 = if not ok then nil else result
				end
			end
		end

		n1 = ((if v155 ~= nil then (if typeof(v155) ~= "DateTime" then (if type(v155) ~= "table" or v155.GetUnixTimestamp == nil then nil else v155:GetUnixTimestamp()) else v155.UnixTimestamp) else nil)) or 0
	end

	local lastUpdated = v151.lastUpdated
	local v163 = ((if lastUpdated ~= nil then (if typeof(lastUpdated) ~= "DateTime" then (if type(lastUpdated) ~= "table" or lastUpdated.GetUnixTimestamp == nil then nil else lastUpdated:GetUnixTimestamp()) else lastUpdated.UnixTimestamp) else nil)) or 0

	for _, v165 in t6 do
		if v165 ~= nil and if v165.isPreviewable == nil then v165.is_previewable ~= nil and v165.is_previewable else v165.isPreviewable then
			local v167

			if v165.sent ~= nil then
				if type(v165.sent) == "string" then
					local sent = v165.sent

					if type(sent) ~= "string" then
						v167 = nil
					else
						local ok, result = pcall(function() -- line: 101
							-- upvalues: sent (copy)
							return DateTime.fromIsoDate(sent)
						end)

						v167 = if not ok then nil else result
					end
				else
					v167 = v165.sent
				end
			else
				local v170 = v165.created_at or v165.createdAt

				if type(v170) ~= "string" then
					v167 = nil
				else
					local ok, result = pcall(function() -- line: 101
						-- upvalues: v170 (copy)
						return DateTime.fromIsoDate(v170)
					end)

					v167 = if not ok then nil else result
				end
			end

			local v173 = if v167 ~= nil then if typeof(v167) ~= "DateTime" then if type(v167) ~= "table" or v167.GetUnixTimestamp == nil then nil else v167:GetUnixTimestamp() else v167.UnixTimestamp else nil

			if v173 ~= nil and n1 < v173 then
				n1 = v173
				v152 = v167
				id = v165.id
			end
		end
	end

	if v152 ~= nil then
		local t7 = {
			previewMessageId = id
		}

		if v163 < n1 then
			t7.lastUpdated = v152
		end

		if b1 then
			t7.hasUnreadMessages = true
		end

		if s5 == nil then
			return
		end

		local v175 = p11.getConversation(s5, false)

		if v175 == nil then
			return
		end

		p11.upsertConversation(Cryo.Dictionary.join(v175, t7), false)

		return
	end

	if b1 then
		local t8 = {
			hasUnreadMessages = true
		}

		if s5 == nil then
			return
		end

		local v177 = p11.getConversation(s5, false)

		if v177 == nil then
			return
		end

		p11.upsertConversation(Cryo.Dictionary.join(v177, t8), false)
	end
end
local function handleCreateConversationSucceeded(p12, p13) -- line: 243
	-- upvalues: ConversationChannels (copy)
	local responseBody = p12.responseBody
	local v181 = responseBody and (responseBody.conversations and responseBody.conversations[1])

	if v181 ~= nil then
		if v181.status == "failed" then
			return
		end

		p13.upsertConversation(ConversationChannels.fromChannelsApi(v181))
	end
end
local function handleDuplicateConversationSucceeded(p14, p15) -- line: 249
	-- upvalues: ConversationChannels (copy)
	local responseBody = p14.responseBody
	local v185 = responseBody and (responseBody.conversations and responseBody.conversations[1])

	if v185 ~= nil then
		if v185.status == "failed" then
			return
		end

		p15.upsertConversation(ConversationChannels.fromChannelsApi(v185))
	end
end
local function handleGetUserConversationsSucceeded(p16, p17) -- line: 253
	-- upvalues: ConversationChannels (copy)
	local responseBody = p16.responseBody

	if responseBody ~= nil and responseBody.conversations ~= nil then
		for _, v190 in responseBody.conversations do
			if v190 ~= nil and v190.status ~= "failed" then
				p17.upsertConversation(ConversationChannels.fromChannelsApi(v190))
			end
		end
	end

	local v191 = p16.responseBody and p16.responseBody.next_cursor
	local t9 = {
		isFetchingConversations = false
	}

	if v191 == nil or v191 == "" then
		t9.oldestConversationIsFetched = true
	end

	p17.setListStatus(t9)
end
local function handleGetUserConversationsFailed(_, p19) -- line: 265
	p19.setListStatus({
		isFetchingConversations = false
	})
end
local function handleGetConversationDetailsSucceeded(p20, p21) -- line: 271
	-- upvalues: ConversationChannels (copy)
	local responseBody = p20.responseBody

	if responseBody ~= nil then
		if responseBody.conversations == nil then
			return
		end

		for _, v199 in responseBody.conversations do
			if v199 ~= nil and v199.status ~= "failed" then
				p21.upsertConversation(ConversationChannels.fromChannelsApi(v199))
			end
		end
	end
end
local function handleLegacyGetUserConversationsSucceeded(p22, p23) -- line: 275
	-- upvalues: Conversation (copy)
	local responseBody = p22.responseBody

	if responseBody == nil then
		return
	end

	for _, v in ipairs(responseBody) do
		p23.upsertConversation(Conversation.fromWeb(v))
	end

	p23.setListStatus({
		isFetchingConversations = false
	})

	local v205 = p22.queryArgs and p22.queryArgs.pageSize

	if v205 ~= nil and v205 > #responseBody then
		p23.setListStatus({
			oldestConversationIsFetched = true
		})
	end
end
local function handleReceivedConversation(p24, p25) -- line: 294
	p25.upsertConversation(p24.conversation)
end
local function handleRemovedConversation(p26, p27) -- line: 298
	if p26.conversationId then
		p27.removeConversation(p26.conversationId)
	end
end
local function handleRenamedGroupConversation(p28, p29) -- line: 304
	-- upvalues: Cryo (copy)
	local conversationId = p28.conversationId
	local t10 = {
		lastUpdated = p28.lastUpdated,
		title = p28.title,
		isDefaultTitle = p28.isDefaultTitle
	}

	if conversationId == nil then
		return
	end

	local v214 = p29.getConversation(conversationId, false)

	if v214 == nil then
		return
	end

	p29.upsertConversation(Cryo.Dictionary.join(v214, t10), false)
end
local function handleChangedParticipants(p30, p31) -- line: 312
	-- upvalues: Cryo (copy)
	local conversationId = p30.conversationId
	local t11 = {
		participants = p30.participants,
		lastUpdated = p30.lastUpdated,
		title = p30.title
	}

	if conversationId == nil then
		return
	end

	local v219 = p31.getConversation(conversationId, false)

	if v219 == nil then
		return
	end

	p31.upsertConversation(Cryo.Dictionary.join(v219, t11), false)
end
local function handleHasUnreadMessages(p32, p33) -- line: 320
	-- upvalues: Cryo (copy)
	local v222 = p32.conversation and p32.conversation.id
	local t12 = {
		hasUnreadMessages = true
	}

	if v222 == nil then
		return
	end

	local v224 = p33.getConversation(v222, false)

	if v224 == nil then
		return
	end

	p33.upsertConversation(Cryo.Dictionary.join(v224, t12), false)
end
local function handleReadConversation(p34, p35) -- line: 326
	-- upvalues: Cryo (copy)
	local conversationId = p34.conversationId
	local t13 = {
		hasUnreadMessages = false
	}

	if conversationId == nil then
		return
	end

	local v229 = p35.getConversation(conversationId, false)

	if v229 == nil then
		return
	end

	p35.upsertConversation(Cryo.Dictionary.join(v229, t13), false)
end
local function handleMarkConversationSucceeded(p36, p37) -- line: 332
	-- upvalues: Cryo (copy)
	local v232 = p36.postBody and p36.postBody.conversation_ids

	if v232 == nil then
		return
	end

	for _, v234 in v232 do
		local t14 = {
			hasUnreadMessages = false
		}

		if v234 ~= nil then
			local v236 = p37.getConversation(v234, false)

			if v236 ~= nil then
				p37.upsertConversation(Cryo.Dictionary.join(v236, t14), false)
			end
		end
	end
end
local function handleLegacyMarkAsReadSucceeded(p38, p39) -- line: 344
	-- upvalues: Cryo (copy)
	local v239 = p38.postBody and p38.postBody.conversationId
	local t15 = {
		hasUnreadMessages = false
	}

	if v239 == nil then
		return
	end

	local v241 = p39.getConversation(v239, false)

	if v241 == nil then
		return
	end

	p39.upsertConversation(Cryo.Dictionary.join(v241, t15), false)
end
local function handleSetUserTyping(p40, p41) -- line: 350
	local v244 = p40.conversationId and p41.getConversation(p40.conversationId, false)

	if v244 == nil then
		return
	end

	local v245 = table.clone(v244.usersTyping or {})

	v245[p40.userId] = p40.value
	p41.setUsersTyping(p40.conversationId, v245)
end
local function handleSetConversationLoadingStatus(p42, p43) -- line: 360
	-- upvalues: Cryo (copy)
	local conversationId = p42.conversationId
	local t16 = {
		initialLoadingStatus = p42.value
	}

	if conversationId == nil then
		return
	end

	local v250 = p43.getConversation(conversationId, false)

	if v250 == nil then
		return
	end

	p43.upsertConversation(Cryo.Dictionary.join(v250, t16), false)
end
local function handleSetUserLeavingConversation(p44, p45) -- line: 366
	-- upvalues: Cryo (copy)
	local id = p44.id
	local t17 = {
		isUserLeaving = p44.isLeaving
	}

	if id == nil then
		return
	end

	local v255 = p45.getConversation(id, false)

	if v255 == nil then
		return
	end

	p45.upsertConversation(Cryo.Dictionary.join(v255, t17), false)
end
local function handleSetPinnedGameForConversation(p46, p47) -- line: 372
	-- upvalues: Cryo (copy)
	local conversationId = p46.conversationId
	local t18 = {
		pinnedGame = {
			rootPlaceId = p46.rootPlaceId,
			universeId = p46.universeId
		}
	}

	if conversationId == nil then
		return
	end

	local v260 = p47.getConversation(conversationId, false)

	if v260 == nil then
		return
	end

	p47.upsertConversation(Cryo.Dictionary.join(v260, t18), false)
end
local function handleConversationModerationTypeChanged(p48, p49) -- line: 381
	-- upvalues: Cryo (copy)
	local conversationId = p48.conversationId
	local t19 = {
		moderationType = p48.moderationType
	}

	if conversationId == nil then
		return
	end

	local v265 = p49.getConversation(conversationId, false)

	if v265 == nil then
		return
	end

	p49.upsertConversation(Cryo.Dictionary.join(v265, t19), false)
end
local function handleRecordModalSequenceResponseSucceeded(p50, p51) -- line: 387
	-- upvalues: Constants (copy), t1 (copy), ConversationChannels (copy), Cryo (copy)
	local postBody = p50.postBody

	if postBody == nil or postBody.action_type ~= Constants.ModalAction.Accept then
		return
	end

	local v269 = t1[postBody.modal_variant]

	if v269 == nil then
		return
	end

	local v270 = postBody.conversation_id or ConversationChannels.getFriendConversationId({ postBody.friend_id })
	local t20 = {
		[v269.field] = v269.value
	}

	if v270 == nil then
		return
	end

	local v272 = p51.getConversation(v270, false)

	if v272 == nil then
		return
	end

	p51.upsertConversation(Cryo.Dictionary.join(v272, t20), false)
end
local function handleFriendConversationCreated(p52, p53) -- line: 404
	if p52.oldFriendConversationId then
		p53.removeConversation(p52.oldFriendConversationId)
	end
end
local function handleFriendshipDestroyed(p54, p55) -- line: 410
	-- upvalues: ConversationChannels (copy)
	local v277 = if p54.userId1 == "localUserId" then if p54.userId2 == "localUserId" then nil else p54.userId2 else p54.userId1

	if v277 == nil then
		return
	end

	p55.removeConversation(ConversationChannels.getFriendConversationId({ v277 }))
end
local function handleBlockUserByIdSucceeded(p56, p57) -- line: 421
	-- upvalues: ConversationChannels (copy)
	local v280 = p56.namedIds and p56.namedIds.users

	if v280 == nil then
		return
	end

	local str = tostring(v280)

	for _, v283 in p57.getConversations(false) do
		local v284 = v283.participants or {}

		if v283.type == ConversationChannels.Type.OneToOne and table.find(v284, str) then
			p57.removeConversation(v283.id)
		end
	end

	p57.removeConversation(ConversationChannels.getFriendConversationId({ str }))
end
local function handleParticipantMetadataSucceeded(p58, p59) -- line: 437
	local responseBody = p58.responseBody

	if responseBody == nil or responseBody.conversation_participants_metadata == nil then
		return
	end

	for v288, v289 in responseBody.conversation_participants_metadata do
		local t21 = {}

		for v291, v292 in v289.participants_metadata do
			t21[v291] = {
				isPending = v292.is_pending,
				isBlocked = v292.is_blocked,
				isInviter = v292.is_inviter,
				isInvited = v292.is_invited
			}
		end

		p59.setParticipantMetadata(v288, t21)
	end
end
local function handleRequestPageConversations(_, p61) -- line: 457
	p61.setListStatus({
		isFetchingConversations = true
	})
end
local function handleReceivedPageConversations(_, p63) -- line: 463
	p63.setListStatus({
		isFetchingConversations = false
	})
end
local function handleRequestLatestMessages(_, _) -- line: 469
	-- upvalues: GetConversationListStore (copy)
	GetConversationListStore(false).setLatestMessagesFetching(true)
end
local function handleReceivedLatestMessages(_, _) -- line: 473
	-- upvalues: GetConversationListStore (copy)
	GetConversationListStore(false).setLatestMessagesFetching(false)
end
local function handleReceivedMessages(p68, p69) -- line: 477
	-- upvalues: updateConversationLastUpdatedFromMessages (copy)
	updateConversationLastUpdatedFromMessages(p69, p68.conversationId, p68.messages, p68.shouldMarkConversationUnread)
end
local function handleGetNewerMessagesSucceeded(p70, p71) -- line: 486
	-- upvalues: updateConversationLastUpdatedFromMessages (copy), shouldMarkConversationUnreadFromMessages (copy)
	local v305 = p70.queryArgs and p70.queryArgs.conversation_id
	local responseBody = p70.responseBody
	local v307 = responseBody and responseBody.messages

	updateConversationLastUpdatedFromMessages(p71, v305, v307, (shouldMarkConversationUnreadFromMessages(v305, v307)))
end
local function handleGetLatestMessagesSucceeded(p72, p73) -- line: 498
	-- upvalues: updateConversationLastUpdatedFromMessages (copy), messagesFromWebResponse (copy)
	local responseBody = p72.responseBody

	if responseBody == nil then
		return
	end

	for _, v in ipairs(responseBody) do
		local str = tostring(v.conversationId)

		updateConversationLastUpdatedFromMessages(p73, str, (messagesFromWebResponse(str, v.chatMessages)))
	end
end
local function handleReceivedOldestConversation(_, p75) -- line: 514
	p75.setListStatus({
		oldestConversationIsFetched = true
	})
end
local function handleReceivedChannelsMigrationConflict(_, p77) -- line: 520
	-- upvalues: GetConversationListStore (copy)
	p77.clear()
	GetConversationListStore(false).setLatestMessagesFetching(false)
end

local t22 = {
	[AppChatNetworking.rodux.CreateConversation.Succeeded.name] = handleCreateConversationSucceeded,
	[AppChatNetworking.rodux.DuplicateConversation.Succeeded.name] = handleDuplicateConversationSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Succeeded.name] = handleGetUserConversationsSucceeded,
	[AppChatNetworking.rodux.GetUserConversations.Failed.name] = handleGetUserConversationsFailed,
	[AppChatNetworking.rodux.GetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MultiGetConversationDetails.Succeeded.name] = handleGetConversationDetailsSucceeded,
	[AppChatNetworking.rodux.MarkConversation.Succeeded.name] = handleMarkConversationSucceeded,
	[AppChatNetworking.rodux.GetConversationsParticipantsMetadata.Succeeded.name] = handleParticipantMetadataSucceeded,
	[AppChatNetworking.rodux.RecordModalSequenceResponse.Succeeded.name] = handleRecordModalSequenceResponseSucceeded,
	[NetworkingChat.GetUserConversations.Succeeded.name] = handleLegacyGetUserConversationsSucceeded,
	[NetworkingChat.GetUserConversations.Failed.name] = handleGetUserConversationsFailed,
	[NetworkingChat.GetConversations.Succeeded.name] = handleLegacyGetUserConversationsSucceeded,
	[NetworkingChat.GetConversations.Failed.name] = handleGetUserConversationsFailed,
	[NetworkingChat.GetLatestMessages.Succeeded.name] = handleGetLatestMessagesSucceeded,
	[NetworkingChat.MarkAsRead.Succeeded.name] = handleLegacyMarkAsReadSucceeded,
	[NetworkingBlocking.BlockUserById.Succeeded.name] = handleBlockUserByIdSucceeded,
	[ReceivedConversation.name] = handleReceivedConversation,
	[ReceivedMessages.name] = handleReceivedMessages,
	[RemovedConversation.name] = handleRemovedConversation,
	[RenamedGroupConversation.name] = handleRenamedGroupConversation,
	[ChangedParticipants.name] = handleChangedParticipants,
	[HasUnreadMessages.name] = handleHasUnreadMessages,
	[ReadConversation.name] = handleReadConversation,
	[SetUserTyping.name] = handleSetUserTyping,
	[SetConversationLoadingStatus.name] = handleSetConversationLoadingStatus,
	[SetUserLeavingConversation.name] = handleSetUserLeavingConversation,
	[SetPinnedGameForConversation.name] = handleSetPinnedGameForConversation,
	[ConversationModerationTypeChanged.name] = handleConversationModerationTypeChanged,
	[FriendConversationCreated.name] = handleFriendConversationCreated,
	[FriendshipDestroyed.name] = handleFriendshipDestroyed,
	[RequestPageConversations.name] = handleRequestPageConversations,
	[ReceivedPageConversations.name] = handleReceivedPageConversations,
	[RequestLatestMessages.name] = handleRequestLatestMessages,
	[ReceivedLatestMessages.name] = handleReceivedLatestMessages,
	[AppChatNetworking.rodux.GetNewerMessages.Succeeded.name] = handleGetNewerMessagesSucceeded,
	[ReceivedOldestConversation.name] = handleReceivedOldestConversation,
	[ReceivedChannelsMigrationConflict.name] = handleReceivedChannelsMigrationConflict
}

local function SignalsConversationMiddleware(p78, _) -- line: 565
	-- upvalues: FFlagAppChatConversationStore (copy), t22 (copy), GetConversationStore (copy)
	return function(p80) -- line: 566
		-- upvalues: p78 (copy), FFlagAppChatConversationStore (copy), t22 (copy), GetConversationStore (copy)
		local v321 = p78(p80)

		if not FFlagAppChatConversationStore then
			return v321
		end

		local v322 = t22[p80.type]

		if v322 then
			v322(p80, GetConversationStore(false))
		end

		return v321
	end
end

return SignalsConversationMiddleware
