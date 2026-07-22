local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Rodux = require(ExpChatParent.Rodux)
local llama = require(ExpChatParent.llama)
local List = llama.List
local Dictionary = llama.Dictionary
local Set = llama.Set
local None = llama.None
local isWhiteSpaceOnly = require(ExpChat.isWhiteSpaceOnly)
local sanitizeForRichText = require(ExpChat.sanitizeForRichText)
local generateRichSystemMessageTextFormat = require(ExpChat.generateRichSystemMessageTextFormat)
local Config = require(ExpChat.Config)

require(ExpChat.TextChatMessageChatActionType)

local Actions = ExpChat.Actions
local IncomingMessageReceived = require(Actions.IncomingMessageReceived)
local UniverseChatSystemMessageAdded = require(Actions.UniverseChatSystemMessageAdded)
local IncomingBubbleChatMessageReceived = require(Actions.IncomingBubbleChatMessageReceived)
local OutgoingMessageSent = require(Actions.OutgoingMessageSent)
local UserMuted = ExpChatShared.Actions.UserMuted
local UserUnmuted = ExpChatShared.Actions.UserUnmuted
local PlayerRemoved = ExpChatShared.Actions.PlayerRemoved
local ChatPrivacySettingsReceived = require(Actions.ChatPrivacySettingsReceived)
local ChatPrivacySettingsFetchFailed = require(Actions.ChatPrivacySettingsFetchFailed)
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local BubbleChatSettingsChanged = require(Actions.BubbleChatSettingsChanged)
local ChatWindowMessagesCleared = ExpChatShared.Actions.ChatWindowMessagesCleared
local ChatTranslationGlobalToggled = require(Actions.ChatTranslationGlobalToggled)
local ChatTranslationMessageToggled = require(ExpChat.Actions.ChatTranslationMessageToggled)
local LegacyBubbleCreated = require(ExpChat.Actions.LegacyBubbleCreated)
local LegacyBubbleTextUpdated = require(ExpChat.Actions.LegacyBubbleTextUpdated)
local HiddenMessageReceived = require(ExpChat.Actions.HiddenMessageReceived)
local HiddenMessagesCleared = require(ExpChat.Actions.HiddenMessagesCleared)
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)
local FFlagExpChatEnableFOMOUpsell = require(ExpChat.Flags.FFlagExpChatEnableFOMOUpsell)
local FFlagExpChatClearHiddenMessagesPostAgeCheck = require(ExpChat.Flags.FFlagExpChatClearHiddenMessagesPostAgeCheck)
local FIntExpChatRandomCharChangeLowerBound = require(ExpChat.Flags.FIntExpChatRandomCharChangeLowerBound)
local FIntExpChatRandomCharChangeUpperBound = require(ExpChat.Flags.FIntExpChatRandomCharChangeUpperBound)
local FFlagEnableInExpChatRewrite = require(ExpChat.Flags.FFlagEnableInExpChatRewrite)
local FFlagEnableInExpChatSummaryOnLua = require(ExpChat.Flags.FFlagEnableInExpChatSummaryOnLua)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local SharedFlags = require(ExpChatParent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local computeNameColor = require(ExpChatParent.ChatUIPrimitives).Utils.computeNameColor
local getFFlagExpChatExcludeFOMORenders = require(ExpChat.Flags.getFFlagExpChatExcludeFOMORenders)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDisableUniverseBubbleChat = ExpChatShared.Flags.FFlagExpChatDisableUniverseBubbleChat
local GetFFlagExpChatSyntheticSystemMessageRichText = ExpChatShared.Flags.GetFFlagExpChatSyntheticSystemMessageRichText
local getTextAndTranslation = require(ExpChat.getTextAndTranslation)
local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local TextChatService = game:GetService("TextChatService")

function getChatTranslationEnabled() -- line: 66
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 67
		-- upvalues: TextChatService (copy)
		return TextChatService.ChatTranslationEnabled
	end)

	return ok and result
end

local t1 = {
	canLocalUserChat = false,
	isBubbleChatEnabled = false,
	channelTabsConfigurationEnabled = false,
	messageLimit = 50,
	_mutedUserIds = {},
	windowMessagesInOrder = {},
	windowMessagesInOrderByTabId = {},
	byMessageId = {},
	bubbleMessagesInOrderBySenderId = {},
	mockUserIdToPartOrModel = {},
	partOrModelToMockUserId = {},
	messagesBySenderId = {}
}

local function resolveChannelNameForMapOrder(t2: {[any]: any}, t3: {[any]: any}, s1: string?) -- line: 129
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), None (copy)
	if GetFFlagTextChatEnableUniverseChatTabs() then
		if s1 then
			return s1
		end

		if t3.textChannel then
			if t3.textChannel.Name == "RBXSystem" or not t2.channelTabsConfigurationEnabled then
				return "RBXGeneral"
			end

			return t3.textChannel.Name
		end

		return None
	end

	if t3.textChannel then
		if t3.textChannel.Name == "RBXSystem" then
			return "RBXGeneral"
		end

		return t3.textChannel.Name
	end

	return None
end
local function mapByMessageIdInOrderHelper(t4: {[any]: any}, t5: {[any]: any}, s2: string?) -- line: 155
	-- upvalues: isWhiteSpaceOnly (copy), resolveChannelNameForMapOrder (copy), HttpService (copy), Dictionary (copy), FFlagEnableInExpChatRewrite (copy), FFlagExpChatDictation (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FFlagExpChatPresetChatEnabled (copy), List (copy), FFlagExpChatEnableFOMOUpsell (copy), getFFlagExpChatExcludeFOMORenders (copy)
	if isWhiteSpaceOnly(t5.text) and (t5.status ~= Enum.TextChatMessageStatus.Floodchecked and t5.status ~= Enum.TextChatMessageStatus.MessageTooLong) then
		return t4
	end

	local partOrModel = t5.partOrModel
	local userId = t5.userId
	local messageId = t5.messageId
	local v78 = resolveChannelNameForMapOrder(t4, t5, s2)
	local windowMessagesInOrder = t4.windowMessagesInOrder
	local v80 = t4.windowMessagesInOrderByTabId[v78] or {}
	local byMessageId = t4.byMessageId
	local bubbleMessagesInOrderBySenderId = t4.bubbleMessagesInOrderBySenderId
	local mockUserIdToPartOrModel = t4.mockUserIdToPartOrModel
	local partOrModelToMockUserId = t4.partOrModelToMockUserId
	local messagesBySenderId = t4.messagesBySenderId

	if not userId and partOrModel then
		userId = partOrModelToMockUserId[partOrModel]

		if not userId then
			userId = HttpService:GenerateGUID(false)
			mockUserIdToPartOrModel = Dictionary.join(mockUserIdToPartOrModel, {
				[userId] = partOrModel
			})
			partOrModelToMockUserId = Dictionary.join(partOrModelToMockUserId, {
				[partOrModel] = userId
			})
		end
	end

	local wasRewritten = nil
	local originalText = nil

	if FFlagEnableInExpChatRewrite then
		wasRewritten = t5.wasRewritten
		originalText = t5.originalText
	end

	if byMessageId[messageId] then
		local t6 = {
			userId = userId,
			prefixText = t5.prefixText,
			text = t5.text,
			translation = t5.translation,
			useTranslation = t5.useTranslation,
			textChannel = t5.textChannel,
			messageId = messageId,
			status = t5.status,
			timestamp = t5.timestamp,
			isVisibleInBubbleChat = t5.isVisibleInBubbleChat,
			isVisibleInChatWindow = t5.isVisibleInChatWindow,
			shouldOverrideBubbleChatSettings = t5.shouldOverrideBubbleChatSettings,
			bubbleChatMessageProperties = t5.bubbleChatMessageProperties,
			chatWindowMessageProperties = t5.chatWindowMessageProperties,
			metadata = if not FFlagExpChatDictation then nil else t5.metadata,
			textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else t5.textChatMessageInstance,
			wasRewritten = wasRewritten,
			originalText = originalText,
			chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else t5.chatActionType,
			isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else t5.isUniverseChat,
			presetId = if not FFlagExpChatPresetChatEnabled then nil else t5.presetId,
			presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else t5.presetChatVersion
		}
		local v89 = Dictionary.join(byMessageId, {
			[messageId] = t6
		})

		if userId and messagesBySenderId[userId] then
			local v90 = List.findWhere(messagesBySenderId[userId], function(p1, _) -- line: 234
				-- upvalues: messageId (copy)
				return p1.messageId == messageId
			end)

			if v90 and v90 > 0 then
				messagesBySenderId = Dictionary.join(messagesBySenderId, {
					[userId] = List.set(messagesBySenderId[userId], v90, t6)
				})
			end
		end

		if t5.status == Enum.TextChatMessageStatus.Floodchecked or t5.status == Enum.TextChatMessageStatus.MessageTooLong then
			windowMessagesInOrder = List.removeIndex(windowMessagesInOrder, List.count(windowMessagesInOrder))
			v80 = List.removeIndex(v80, List.count(v80))
			v89 = Dictionary.removeKey(v89, t5.messageId)

			if userId then
				local v91 = List.findWhere(messagesBySenderId[userId], function(p3, _) -- line: 254
					-- upvalues: messageId (copy)
					return p3.messageId == messageId
				end)

				if v91 and v91 > 0 then
					messagesBySenderId = Dictionary.join(messagesBySenderId, {
						[userId] = List.removeIndex(messagesBySenderId[userId], v91)
					})
				end
			end
		end

		return Dictionary.join(t4, {
			windowMessagesInOrder = windowMessagesInOrder,
			windowMessagesInOrderByTabId = Dictionary.join(t4.windowMessagesInOrderByTabId, {
				[v78] = v80
			}),
			byMessageId = v89,
			messagesBySenderId = messagesBySenderId
		})
	end

	if #windowMessagesInOrder == t4.messageLimit and t5.isVisibleInChatWindow then
		local u92 = windowMessagesInOrder[1]
		local v93 = if not byMessageId[u92] then nil else byMessageId[u92].userId

		windowMessagesInOrder = List.removeIndex(windowMessagesInOrder, 1)

		if v93 then
			if messagesBySenderId ~= nil and messagesBySenderId[v93] then
				local v94 = List.findWhere(messagesBySenderId[v93], function(p5, _) -- line: 282
					-- upvalues: u92 (ref)
					return p5.messageId == u92
				end)

				if v94 and v94 > 0 then
					messagesBySenderId = Dictionary.join(messagesBySenderId, {
						[v93] = List.removeIndex(messagesBySenderId[v93], v94)
					})
				end

				if Dictionary.count(messagesBySenderId[v93]) == 0 then
					messagesBySenderId = Dictionary.removeKey(messagesBySenderId, v93)

					if mockUserIdToPartOrModel[v93] then
						local v95 = mockUserIdToPartOrModel[v93]

						if partOrModelToMockUserId[v95] then
							partOrModelToMockUserId = Dictionary.removeKey(partOrModelToMockUserId, v95)
						end

						mockUserIdToPartOrModel = Dictionary.removeKey(mockUserIdToPartOrModel, v93)
					end
				end
			elseif bubbleMessagesInOrderBySenderId ~= nil and bubbleMessagesInOrderBySenderId[v93] then
				local v96 = Dictionary.join(bubbleMessagesInOrderBySenderId, {
					[v93] = List.removeValue(bubbleMessagesInOrderBySenderId[v93], u92)
				})

				if Dictionary.count(v96[v93]) == 0 then
					Dictionary.removeKey(v96, v93)

					if mockUserIdToPartOrModel[v93] then
						local v97 = mockUserIdToPartOrModel[v93]

						if partOrModelToMockUserId[v97] then
							partOrModelToMockUserId = Dictionary.removeKey(partOrModelToMockUserId, v97)
						end

						mockUserIdToPartOrModel = Dictionary.removeKey(mockUserIdToPartOrModel, v93)
					end
				end
			end
		end

		if #v80 == t4.messageLimit then
			u92 = v80[1]
			v80 = List.removeIndex(v80, 1)
			byMessageId = Dictionary.removeKey(byMessageId, u92)
		end
	end

	if t5.isVisibleInChatWindow then
		windowMessagesInOrder = List.append(windowMessagesInOrder, messageId)
		v80 = List.append(v80, messageId)
	end

	return Dictionary.join(t4, {
		windowMessagesInOrder = windowMessagesInOrder,
		windowMessagesInOrderByTabId = Dictionary.join(t4.windowMessagesInOrderByTabId, {
			[v78] = v80
		}),
		byMessageId = Dictionary.join(byMessageId, {
			[messageId] = {
				userId = userId,
				prefixText = t5.prefixText,
				text = t5.text,
				translation = t5.translation,
				useTranslation = t5.useTranslation,
				messageId = messageId,
				status = t5.status,
				timestamp = t5.timestamp,
				isVisibleInBubbleChat = t5.isVisibleInBubbleChat,
				isVisibleInChatWindow = t5.isVisibleInChatWindow,
				partOrModel = partOrModel,
				shouldOverrideBubbleChatSettings = t5.shouldOverrideBubbleChatSettings,
				bubbleChatMessageProperties = t5.bubbleChatMessageProperties,
				chatWindowMessageProperties = t5.chatWindowMessageProperties,
				textChannel = t5.textChannel,
				metadata = if not FFlagExpChatDictation then nil else t5.metadata,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else t5.textChatMessageInstance,
				isHiddenMessage = if not FFlagExpChatEnableFOMOUpsell and not getFFlagExpChatExcludeFOMORenders() then nil else t5.isHiddenMessage,
				wasRewritten = wasRewritten,
				originalText = originalText,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else t5.chatActionType,
				isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else t5.isUniverseChat,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else t5.presetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else t5.presetChatVersion
			}
		}),
		mockUserIdToPartOrModel = mockUserIdToPartOrModel,
		partOrModelToMockUserId = partOrModelToMockUserId,
		messagesBySenderId = if not userId then nil else Dictionary.join(messagesBySenderId, {
			[userId] = List.append(messagesBySenderId[userId] or {}, {
				userId = userId,
				prefixText = t5.prefixText,
				text = t5.text,
				translation = t5.translation,
				useTranslation = t5.useTranslation,
				messageId = messageId,
				status = t5.status,
				timestamp = t5.timestamp,
				isVisibleInBubbleChat = t5.isVisibleInBubbleChat,
				isVisibleInChatWindow = t5.isVisibleInChatWindow,
				partOrModel = partOrModel,
				shouldOverrideBubbleChatSettings = t5.shouldOverrideBubbleChatSettings,
				bubbleChatMessageProperties = t5.bubbleChatMessageProperties,
				chatWindowMessageProperties = t5.chatWindowMessageProperties,
				textChannel = t5.textChannel,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else t5.textChatMessageInstance,
				wasRewritten = wasRewritten,
				originalText = originalText,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else t5.chatActionType,
				isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else t5.isUniverseChat,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else t5.presetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else t5.presetChatVersion
			})
		})
	})
end
local function globalToggleTranslations(t7: {[any]: any}, p7) -- line: 408
	-- upvalues: getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy), Dictionary (copy)
	local useTranslation = p7.useTranslation
	local byMessageId = t7.byMessageId
	local t8 = {}

	for k, _ in pairs(byMessageId) do
		local v105 = byMessageId[k]

		if v105 ~= nil then
			t8[k] = {
				prefixText = v105.prefixText,
				text = v105.text,
				translation = v105.translation,
				useTranslation = useTranslation,
				messageId = v105.messageId,
				status = v105.status,
				timestamp = v105.timestamp,
				isVisibleInBubbleChat = v105.isVisibleInBubbleChat,
				isVisibleInChatWindow = v105.isVisibleInChatWindow,
				partOrModel = v105.partOrModel,
				shouldOverrideBubbleChatSettings = v105.shouldOverrideBubbleChatSettings,
				bubbleChatMessageProperties = v105.bubbleChatMessageProperties,
				chatWindowMessageProperties = v105.chatWindowMessageProperties,
				userId = v105.userId,
				textChannel = v105.textChannel,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v105.textChatMessageInstance,
				wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v105.wasRewritten,
				originalText = if not FFlagEnableInExpChatRewrite then nil else v105.originalText,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v105.chatActionType,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else v105.presetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v105.presetChatVersion
			}
		end
	end

	return Dictionary.join(t7, {
		byMessageId = Dictionary.join(byMessageId, t8)
	})
end
local function individualToggleTranslation(t9: {[any]: any}, p8) -- line: 450
	-- upvalues: Dictionary (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
	local useTranslation = p8.useTranslation
	local messageId = p8.messageId
	local byMessageId = t9.byMessageId
	local v111 = byMessageId[messageId]

	if v111 ~= nil then
		return Dictionary.join(t9, {
			byMessageId = Dictionary.join(byMessageId, {
				[messageId] = {
					prefixText = v111.prefixText,
					text = v111.text,
					translation = v111.translation,
					useTranslation = useTranslation,
					messageId = v111.messageId,
					status = v111.status,
					timestamp = v111.timestamp,
					isVisibleInBubbleChat = v111.isVisibleInBubbleChat,
					isVisibleInChatWindow = v111.isVisibleInChatWindow,
					partOrModel = v111.partOrModel,
					shouldOverrideBubbleChatSettings = v111.shouldOverrideBubbleChatSettings,
					bubbleChatMessageProperties = v111.bubbleChatMessageProperties,
					chatWindowMessageProperties = v111.chatWindowMessageProperties,
					userId = v111.userId,
					textChannel = v111.textChannel,
					textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v111.textChatMessageInstance,
					wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v111.wasRewritten,
					originalText = if not FFlagEnableInExpChatRewrite then nil else v111.originalText,
					chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v111.chatActionType,
					presetId = if not FFlagExpChatPresetChatEnabled then nil else v111.presetId,
					presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v111.presetChatVersion
				}
			})
		})
	end

	return nil
end
local function mapByMessageIdInOrderBubbleChat(t10: {[any]: any}, p9) -- line: 494
	-- upvalues: mapByMessageIdInOrderHelper (copy)
	local bubbleChatMessageTable = p9.bubbleChatMessageTable
	local t11 = {
		prefixText = "",
		shouldOverrideBubbleChatSettings = true,
		isVisibleInBubbleChat = true,
		isVisibleInChatWindow = false,
		userId = bubbleChatMessageTable.bubbleChatMessageUserId,
		text = bubbleChatMessageTable.message,
		translation = bubbleChatMessageTable.translation,
		useTranslation = getChatTranslationEnabled(),
		messageId = bubbleChatMessageTable.bubbleChatMessageId,
		status = Enum.TextChatMessageStatus.Success,
		timestamp = bubbleChatMessageTable.timestamp,
		partOrModel = bubbleChatMessageTable.partOrModel,
		bubbleChatMessageProperties = bubbleChatMessageTable.bubbleChatMessageProperties
	}

	return mapByMessageIdInOrderHelper(t10, t11)
end
local function mapByMessageIdInOrder(t12: {[any]: any}, p10) -- line: 517
	-- upvalues: FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatPresetChatEnabled (copy), Set (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), computeNameColor (copy), Players (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), mapByMessageIdInOrderHelper (copy)
	local textChatMessage = p10.textChatMessage
	local v119, v120

	if FFlagEnableInExpChatRewrite then
		v119, v120 = getTextAndTranslation(textChatMessage)
	else
		v119 = if not getFFlagExpChatProtectedChatInternalAPIs() then textChatMessage.Text else textChatMessage.TextInternal
		v120 = if not getFFlagExpChatProtectedChatInternalAPIs() then textChatMessage.Translation else textChatMessage.TranslationInternal
	end

	local v121 = if not textChatMessage.TextSource then nil else tostring(textChatMessage.TextSource.UserId)
	local v122 = v121 == nil or (t12.canLocalUserChat or not not FFlagExpChatPresetChatEnabled and (textChatMessage.PresetId or "") ~= "") and (textChatMessage.Status == Enum.TextChatMessageStatus.Success or textChatMessage.Status == Enum.TextChatMessageStatus.Sending)
	local v123 = not not v121 and Set.has(t12._mutedUserIds, v121)
	local v124 = v122 and not v123
	local v125 = false

	if ((if not FFlagExpChatUseChatConfigStore then t12.isBubbleChatEnabled else GetChatConfigurationStore(false).getIsBubbleChatEnabled(false))) and v124 and (not FFlagEnableInExpChatSummaryOnLua or v121 ~= nil) and (textChatMessage.Status == Enum.TextChatMessageStatus.Success or textChatMessage.Status == Enum.TextChatMessageStatus.Sending) then
		v125 = true
	end

	if FFlagExpChatDisableUniverseBubbleChat and GetFFlagTextChatEnableUniverseChatTabs() and p10.isUniverseChat == true then
		v125 = false
	end

	local v126 = if not getFFlagExpChatProtectedChatInternalAPIs() then textChatMessage.PrefixText else textChatMessage.PrefixTextInternal

	if GetFFlagTextChatEnableUniverseChatTabs() and p10.channelNameOverride and #v126 > 0 then
		v126 = `<font color="#{ ((if not textChatMessage.TextSource then computeNameColor(Players.LocalPlayer.Name) else computeNameColor(textChatMessage.TextSource.Username))):ToHex() }">{ v126 }</font>`
	end

	local t13 = {
		userId = v121,
		prefixText = v126,
		text = v119,
		translation = v120,
		useTranslation = getChatTranslationEnabled(),
		textChannel = textChatMessage.TextChannel,
		messageId = textChatMessage.MessageId,
		status = textChatMessage.Status,
		timestamp = textChatMessage.Timestamp,
		isVisibleInBubbleChat = v125,
		isVisibleInChatWindow = v124,
		bubbleChatMessageProperties = textChatMessage.BubbleChatMessageProperties,
		chatWindowMessageProperties = textChatMessage.ChatWindowMessageProperties,
		textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else textChatMessage,
		wasRewritten = if not FFlagEnableInExpChatRewrite then nil else textChatMessage.WasRewritten,
		originalText = if not FFlagEnableInExpChatRewrite then nil else textChatMessage.OriginalText,
		chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else textChatMessage.ChatActionType,
		isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else p10.isUniverseChat,
		presetId = if not FFlagExpChatPresetChatEnabled then nil else textChatMessage.PresetId,
		presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else textChatMessage.PresetChatVersion
	}

	return mapByMessageIdInOrderHelper(t12, t13, if not GetFFlagTextChatEnableUniverseChatTabs() then nil else p10.channelNameOverride)
end
local function mapByMessageIdInOrderLegacyBubbleChat(t14: {[any]: any}, p11) -- line: 629
	-- upvalues: mapByMessageIdInOrderHelper (copy)
	local messageData = p11.messageData
	local v131 = if not messageData.timestamp then DateTime.now() else DateTime.fromUnixTimestampMillis(messageData.timestamp)
	local t15 = {
		prefixText = "",
		shouldOverrideBubbleChatSettings = true,
		isVisibleInBubbleChat = true,
		isVisibleInChatWindow = false,
		userId = messageData.userId,
		text = messageData.text,
		messageId = messageData.id,
		status = Enum.TextChatMessageStatus.Success,
		timestamp = v131,
		partOrModel = messageData.adornee
	}

	return mapByMessageIdInOrderHelper(t14, t15)
end
local function mapByMessageIdInOrderHiddenMessage(t16: {[any]: any}, p12) -- line: 653
	-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), getFFlagExpChatTelemetryEventTrigger (copy), mapByMessageIdInOrderHelper (copy)
	local userMessageIntent = p12.userMessageIntent
	local v136 = string.len(if not getFFlagExpChatProtectedChatInternalAPIs() then userMessageIntent.Text else userMessageIntent.TextInternal)
	local v137 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v136 - 1))
	local v138 = FIntExpChatRandomCharChangeUpperBound
	local v139 = math.random(v137, v138)
	local v140 = string.rep(Config.DOT_TEXT, v136 + v139)
	local t17 = {
		userId = nil,
		isVisibleInBubbleChat = false,
		isVisibleInChatWindow = true,
		isHiddenMessage = true,
		prefixText = Config.LOCK_EMOJI .. " :",
		text = v140,
		textChannel = userMessageIntent.TextChannel,
		messageId = userMessageIntent.MessageId,
		status = userMessageIntent.Status,
		timestamp = userMessageIntent.Timestamp,
		textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else userMessageIntent
	}

	return mapByMessageIdInOrderHelper(t16, t17)
end
local function mapUniverseChatSystemMessage(t18: {[any]: any}, p13) -- line: 687
	-- upvalues: HttpService (copy), sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), mapByMessageIdInOrderHelper (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local guid = HttpService:GenerateGUID(false)
	local v145 = sanitizeForRichText(p13.text)
	local v146 = if not GetFFlagExpChatSyntheticSystemMessageRichText() then v145 else generateRichSystemMessageTextFormat(v145, if not FFlagExpChatDictation then nil else p13.isError, p13.postProcessMessage)
	local t19 = {
		userId = nil,
		prefixText = "",
		translation = nil,
		useTranslation = false,
		isVisibleInChatWindow = true,
		isVisibleInBubbleChat = false,
		textChannel = nil,
		bubbleChatMessageProperties = nil,
		chatWindowMessageProperties = nil,
		textChatMessageInstance = nil,
		partOrModel = nil,
		text = v146,
		messageId = guid,
		timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
		status = Enum.TextChatMessageStatus.Success,
		metadata = p13.metadata
	}

	return mapByMessageIdInOrderHelper(t18, t19, if not GetFFlagTextChatEnableUniverseChatTabs() then nil else p13.channelNameOverride)
end

return Rodux.createReducer(t1, {
	[ChannelTabsConfigurationEnabled.name] = function(t20: {[any]: any}, p14) -- line: 724
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), Dictionary (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return t20
		end

		return Dictionary.join(t20, {
			channelTabsConfigurationEnabled = p14.enabled
		})
	end,
	[IncomingMessageReceived.name] = mapByMessageIdInOrder,
	[IncomingBubbleChatMessageReceived.name] = mapByMessageIdInOrderBubbleChat,
	[OutgoingMessageSent.name] = mapByMessageIdInOrder,
	[UserMuted.name] = function(t21: {[any]: any}, p15) -- line: 736
		-- upvalues: Dictionary (copy), Set (copy)
		return Dictionary.join(t21, {
			_mutedUserIds = Set.add(t21._mutedUserIds, p15.userId)
		})
	end,
	[UserUnmuted.name] = function(t22: {[any]: any}, p16) -- line: 741
		-- upvalues: Dictionary (copy), Set (copy)
		return Dictionary.join(t22, {
			_mutedUserIds = Set.subtract(t22._mutedUserIds, p16.userId)
		})
	end,
	[PlayerRemoved.name] = function(t23: {[any]: any}, p17) -- line: 746
		-- upvalues: Dictionary (copy), Set (copy)
		local v156 = Dictionary.filter(t23.bubbleMessagesInOrderBySenderId, function(_, p19) -- line: 749
			-- upvalues: p17 (copy)
			return p19 ~= p17.userId
		end)
		local v157 = Dictionary.filter(t23.messagesBySenderId, function(_, p21) -- line: 753
			-- upvalues: p17 (copy)
			return p21 ~= p17.userId
		end)
		local v158 = Set.has(t23._mutedUserIds, p17.userId)

		if #v156 == 0 and (#v157 == 0 and not v158) then
			return t23
		end

		return Dictionary.join(t23, {
			messagesBySenderId = v157,
			_mutedUserIds = Set.subtract(t23._mutedUserIds, p17.userId)
		})
	end,
	[ChatPrivacySettingsReceived.name] = function(t24: {[any]: any}, p22) -- line: 766
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t24, {
			canLocalUserChat = p22.canUserChat
		})
	end,
	[ChatPrivacySettingsFetchFailed.name] = function(t25: {[any]: any}, _) -- line: 769
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t25, {
			canLocalUserChat = false
		})
	end,
	[ConfigurationObjectsLoaded.name] = function(p24, p25) -- line: 772
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p24, {
			isBubbleChatEnabled = not not p25.bubbleChatSettings.Enabled and p25.bubbleChatSettings.Enabled
		})
	end,
	[BubbleChatSettingsChanged.name] = function(p26, p27) -- line: 779
		-- upvalues: Dictionary (copy)
		if p27.property ~= "Enabled" then
			return p26
		end

		local v167 = Dictionary.map(p26.byMessageId, function(p28) -- line: 784
			-- upvalues: Dictionary (copy), p27 (copy)
			if p28.shouldOverrideBubbleChatSettings then
				return p28
			end

			return Dictionary.join(p28, {
				isVisibleInBubbleChat = p27.value and p28.isVisibleInChatWindow
			})
		end)

		return Dictionary.join(p26, {
			byMessageId = v167,
			isBubbleChatEnabled = p27.value
		})
	end,
	[ChatWindowMessagesCleared.name] = function(t26: {[any]: any}, _) -- line: 799
		-- upvalues: Dictionary (copy)
		local v170 = Dictionary.map(t26.byMessageId, function(p30) -- line: 800
			-- upvalues: Dictionary (copy)
			return Dictionary.join(p30, {
				isVisibleInChatWindow = false
			})
		end)

		return Dictionary.join(t26, {
			windowMessagesInOrder = {},
			windowMessagesInOrderByTabId = {},
			byMessageId = v170
		})
	end,
	[ChatTranslationGlobalToggled.name] = globalToggleTranslations,
	[ChatTranslationMessageToggled.name] = individualToggleTranslation,
	[LegacyBubbleCreated.name] = mapByMessageIdInOrderLegacyBubbleChat,
	[LegacyBubbleTextUpdated.name] = function(t27: {[any]: any}, p31) -- line: 814
		-- upvalues: Dictionary (copy), List (copy)
		local byMessageId = t27.byMessageId
		local messagesBySenderId = t27.messagesBySenderId
		local messageId = p31.messageId
		local newText = p31.newText

		if byMessageId[messageId] then
			local v177 = byMessageId[messageId]

			v177.text = newText
			byMessageId = Dictionary.join(byMessageId, {
				[messageId] = v177
			})

			local userId = v177.userId

			if userId and messagesBySenderId[userId] then
				local v179 = List.findWhere(messagesBySenderId[userId], function(p32, _) -- line: 828
					-- upvalues: messageId (copy)
					return p32.messageId == messageId
				end)

				if v179 and v179 > 0 then
					messagesBySenderId = Dictionary.join(messagesBySenderId, {
						[userId] = List.set(messagesBySenderId[userId], v179, v177)
					})
				end
			end
		end

		return Dictionary.join(t27, {
			byMessageId = byMessageId,
			messagesBySenderId = messagesBySenderId
		})
	end,
	[HiddenMessageReceived.name] = mapByMessageIdInOrderHiddenMessage,
	[UniverseChatSystemMessageAdded.name] = mapUniverseChatSystemMessage,
	[HiddenMessagesCleared.name] = function(t28: {[any]: any}, _) -- line: 846
		-- upvalues: FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), Dictionary (copy), List (copy)
		if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
			return t28
		end

		local v182 = Dictionary.map(t28.byMessageId, function(p35) -- line: 851
			-- upvalues: Dictionary (copy)
			if p35.isHiddenMessage then
				return Dictionary.join(p35, {
					isVisibleInChatWindow = false
				})
			end

			return p35
		end)
		local v183 = List.filter(t28.windowMessagesInOrder, function(p36) -- line: 861
			-- upvalues: v182 (copy)
			local v201 = v182[p36]

			return v201 and not v201.isHiddenMessage
		end)
		local v184 = Dictionary.map(t28.windowMessagesInOrderByTabId, function(p37) -- line: 868
			-- upvalues: List (copy), v182 (copy)
			return List.filter(p37, function(p38) -- line: 869
				-- upvalues: v182 (copy)
				local v204 = v182[p38]

				return v204 and not v204.isHiddenMessage
			end)
		end)

		return Dictionary.join(t28, {
			windowMessagesInOrder = v183,
			windowMessagesInOrderByTabId = v184,
			byMessageId = v182
		})
	end
})
