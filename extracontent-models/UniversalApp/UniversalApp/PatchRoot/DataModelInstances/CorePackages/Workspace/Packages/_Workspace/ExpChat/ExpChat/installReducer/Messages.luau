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
local FFlagExpChatEnablePostProcessRichSystemMessageTextFormat = require(ExpChat.Flags.FFlagExpChatEnablePostProcessRichSystemMessageTextFormat)
local getTextAndTranslation = require(ExpChat.getTextAndTranslation)
local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)
local TextChatService = game:GetService("TextChatService")

function getChatTranslationEnabled() -- line: 68
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 69
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

local function resolveChannelNameForMapOrder(t2: {[any]: any}, t3: {[any]: any}, s1: string?) -- line: 131
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
local function mapByMessageIdInOrderHelper(t4: {[any]: any}, t5: {[any]: any}, s2: string?) -- line: 157
	-- upvalues: isWhiteSpaceOnly (copy), resolveChannelNameForMapOrder (copy), HttpService (copy), Dictionary (copy), FFlagEnableInExpChatRewrite (copy), FFlagExpChatDictation (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), FFlagExpChatPresetChatEnabled (copy), List (copy), FFlagExpChatEnableFOMOUpsell (copy), getFFlagExpChatExcludeFOMORenders (copy)
	if isWhiteSpaceOnly(t5.text) and (t5.status ~= Enum.TextChatMessageStatus.Floodchecked and t5.status ~= Enum.TextChatMessageStatus.MessageTooLong) then
		return t4
	end

	local partOrModel = t5.partOrModel
	local userId = t5.userId
	local messageId = t5.messageId
	local v79 = resolveChannelNameForMapOrder(t4, t5, s2)
	local windowMessagesInOrder = t4.windowMessagesInOrder
	local v81 = t4.windowMessagesInOrderByTabId[v79] or {}
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
		local v90 = Dictionary.join(byMessageId, {
			[messageId] = t6
		})

		if userId and messagesBySenderId[userId] then
			local v91 = List.findWhere(messagesBySenderId[userId], function(p1, _) -- line: 236
				-- upvalues: messageId (copy)
				return p1.messageId == messageId
			end)

			if v91 and v91 > 0 then
				messagesBySenderId = Dictionary.join(messagesBySenderId, {
					[userId] = List.set(messagesBySenderId[userId], v91, t6)
				})
			end
		end

		if t5.status == Enum.TextChatMessageStatus.Floodchecked or t5.status == Enum.TextChatMessageStatus.MessageTooLong then
			windowMessagesInOrder = List.removeIndex(windowMessagesInOrder, List.count(windowMessagesInOrder))
			v81 = List.removeIndex(v81, List.count(v81))
			v90 = Dictionary.removeKey(v90, t5.messageId)

			if userId then
				local v92 = List.findWhere(messagesBySenderId[userId], function(p3, _) -- line: 256
					-- upvalues: messageId (copy)
					return p3.messageId == messageId
				end)

				if v92 and v92 > 0 then
					messagesBySenderId = Dictionary.join(messagesBySenderId, {
						[userId] = List.removeIndex(messagesBySenderId[userId], v92)
					})
				end
			end
		end

		return Dictionary.join(t4, {
			windowMessagesInOrder = windowMessagesInOrder,
			windowMessagesInOrderByTabId = Dictionary.join(t4.windowMessagesInOrderByTabId, {
				[v79] = v81
			}),
			byMessageId = v90,
			messagesBySenderId = messagesBySenderId
		})
	end

	if #windowMessagesInOrder == t4.messageLimit and t5.isVisibleInChatWindow then
		local u93 = windowMessagesInOrder[1]
		local v94 = if not byMessageId[u93] then nil else byMessageId[u93].userId

		windowMessagesInOrder = List.removeIndex(windowMessagesInOrder, 1)

		if v94 then
			if messagesBySenderId ~= nil and messagesBySenderId[v94] then
				local v95 = List.findWhere(messagesBySenderId[v94], function(p5, _) -- line: 284
					-- upvalues: u93 (ref)
					return p5.messageId == u93
				end)

				if v95 and v95 > 0 then
					messagesBySenderId = Dictionary.join(messagesBySenderId, {
						[v94] = List.removeIndex(messagesBySenderId[v94], v95)
					})
				end

				if Dictionary.count(messagesBySenderId[v94]) == 0 then
					messagesBySenderId = Dictionary.removeKey(messagesBySenderId, v94)

					if mockUserIdToPartOrModel[v94] then
						local v96 = mockUserIdToPartOrModel[v94]

						if partOrModelToMockUserId[v96] then
							partOrModelToMockUserId = Dictionary.removeKey(partOrModelToMockUserId, v96)
						end

						mockUserIdToPartOrModel = Dictionary.removeKey(mockUserIdToPartOrModel, v94)
					end
				end
			elseif bubbleMessagesInOrderBySenderId ~= nil and bubbleMessagesInOrderBySenderId[v94] then
				local v97 = Dictionary.join(bubbleMessagesInOrderBySenderId, {
					[v94] = List.removeValue(bubbleMessagesInOrderBySenderId[v94], u93)
				})

				if Dictionary.count(v97[v94]) == 0 then
					Dictionary.removeKey(v97, v94)

					if mockUserIdToPartOrModel[v94] then
						local v98 = mockUserIdToPartOrModel[v94]

						if partOrModelToMockUserId[v98] then
							partOrModelToMockUserId = Dictionary.removeKey(partOrModelToMockUserId, v98)
						end

						mockUserIdToPartOrModel = Dictionary.removeKey(mockUserIdToPartOrModel, v94)
					end
				end
			end
		end

		if #v81 == t4.messageLimit then
			u93 = v81[1]
			v81 = List.removeIndex(v81, 1)
			byMessageId = Dictionary.removeKey(byMessageId, u93)
		end
	end

	if t5.isVisibleInChatWindow then
		windowMessagesInOrder = List.append(windowMessagesInOrder, messageId)
		v81 = List.append(v81, messageId)
	end

	return Dictionary.join(t4, {
		windowMessagesInOrder = windowMessagesInOrder,
		windowMessagesInOrderByTabId = Dictionary.join(t4.windowMessagesInOrderByTabId, {
			[v79] = v81
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
local function globalToggleTranslations(t7: {[any]: any}, p7) -- line: 410
	-- upvalues: getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy), Dictionary (copy)
	local useTranslation = p7.useTranslation
	local byMessageId = t7.byMessageId
	local t8 = {}

	for k, _ in pairs(byMessageId) do
		local v106 = byMessageId[k]

		if v106 ~= nil then
			t8[k] = {
				prefixText = v106.prefixText,
				text = v106.text,
				translation = v106.translation,
				useTranslation = useTranslation,
				messageId = v106.messageId,
				status = v106.status,
				timestamp = v106.timestamp,
				isVisibleInBubbleChat = v106.isVisibleInBubbleChat,
				isVisibleInChatWindow = v106.isVisibleInChatWindow,
				partOrModel = v106.partOrModel,
				shouldOverrideBubbleChatSettings = v106.shouldOverrideBubbleChatSettings,
				bubbleChatMessageProperties = v106.bubbleChatMessageProperties,
				chatWindowMessageProperties = v106.chatWindowMessageProperties,
				userId = v106.userId,
				textChannel = v106.textChannel,
				textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v106.textChatMessageInstance,
				wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v106.wasRewritten,
				originalText = if not FFlagEnableInExpChatRewrite then nil else v106.originalText,
				chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v106.chatActionType,
				presetId = if not FFlagExpChatPresetChatEnabled then nil else v106.presetId,
				presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v106.presetChatVersion
			}
		end
	end

	return Dictionary.join(t7, {
		byMessageId = Dictionary.join(byMessageId, t8)
	})
end
local function individualToggleTranslation(t9: {[any]: any}, p8) -- line: 452
	-- upvalues: Dictionary (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
	local useTranslation = p8.useTranslation
	local messageId = p8.messageId
	local byMessageId = t9.byMessageId
	local v112 = byMessageId[messageId]

	if v112 ~= nil then
		return Dictionary.join(t9, {
			byMessageId = Dictionary.join(byMessageId, {
				[messageId] = {
					prefixText = v112.prefixText,
					text = v112.text,
					translation = v112.translation,
					useTranslation = useTranslation,
					messageId = v112.messageId,
					status = v112.status,
					timestamp = v112.timestamp,
					isVisibleInBubbleChat = v112.isVisibleInBubbleChat,
					isVisibleInChatWindow = v112.isVisibleInChatWindow,
					partOrModel = v112.partOrModel,
					shouldOverrideBubbleChatSettings = v112.shouldOverrideBubbleChatSettings,
					bubbleChatMessageProperties = v112.bubbleChatMessageProperties,
					chatWindowMessageProperties = v112.chatWindowMessageProperties,
					userId = v112.userId,
					textChannel = v112.textChannel,
					textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else v112.textChatMessageInstance,
					wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v112.wasRewritten,
					originalText = if not FFlagEnableInExpChatRewrite then nil else v112.originalText,
					chatActionType = if not FFlagEnableInExpChatSummaryOnLua then nil else v112.chatActionType,
					presetId = if not FFlagExpChatPresetChatEnabled then nil else v112.presetId,
					presetChatVersion = if not FFlagExpChatPresetChatEnabled then nil else v112.presetChatVersion
				}
			})
		})
	end

	return nil
end
local function mapByMessageIdInOrderBubbleChat(t10: {[any]: any}, p9) -- line: 496
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
local function mapByMessageIdInOrder(t12: {[any]: any}, p10) -- line: 519
	-- upvalues: FFlagEnableInExpChatRewrite (copy), getTextAndTranslation (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatPresetChatEnabled (copy), Set (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatDisableUniverseBubbleChat (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), computeNameColor (copy), Players (copy), getFFlagExpChatTelemetryEventTrigger (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), mapByMessageIdInOrderHelper (copy)
	local textChatMessage = p10.textChatMessage
	local v120, v121

	if FFlagEnableInExpChatRewrite then
		v120, v121 = getTextAndTranslation(textChatMessage)
	else
		v120 = if not getFFlagExpChatProtectedChatInternalAPIs() then textChatMessage.Text else textChatMessage.TextInternal
		v121 = if not getFFlagExpChatProtectedChatInternalAPIs() then textChatMessage.Translation else textChatMessage.TranslationInternal
	end

	local v122 = if not textChatMessage.TextSource then nil else tostring(textChatMessage.TextSource.UserId)
	local v123 = v122 == nil or (t12.canLocalUserChat or not not FFlagExpChatPresetChatEnabled and (textChatMessage.PresetId or "") ~= "") and (textChatMessage.Status == Enum.TextChatMessageStatus.Success or textChatMessage.Status == Enum.TextChatMessageStatus.Sending)
	local v124 = not not v122 and Set.has(t12._mutedUserIds, v122)
	local v125 = v123 and not v124
	local v126 = false

	if ((if not FFlagExpChatUseChatConfigStore then t12.isBubbleChatEnabled else GetChatConfigurationStore(false).getIsBubbleChatEnabled(false))) and v125 and (not FFlagEnableInExpChatSummaryOnLua or v122 ~= nil) and (textChatMessage.Status == Enum.TextChatMessageStatus.Success or textChatMessage.Status == Enum.TextChatMessageStatus.Sending) then
		v126 = true
	end

	if FFlagExpChatDisableUniverseBubbleChat and GetFFlagTextChatEnableUniverseChatTabs() and p10.isUniverseChat == true then
		v126 = false
	end

	local v127 = if not getFFlagExpChatProtectedChatInternalAPIs() then textChatMessage.PrefixText else textChatMessage.PrefixTextInternal

	if GetFFlagTextChatEnableUniverseChatTabs() and p10.channelNameOverride and #v127 > 0 then
		v127 = `<font color="#{ ((if not textChatMessage.TextSource then computeNameColor(Players.LocalPlayer.Name) else computeNameColor(textChatMessage.TextSource.Username))):ToHex() }">{ v127 }</font>`
	end

	local t13 = {
		userId = v122,
		prefixText = v127,
		text = v120,
		translation = v121,
		useTranslation = getChatTranslationEnabled(),
		textChannel = textChatMessage.TextChannel,
		messageId = textChatMessage.MessageId,
		status = textChatMessage.Status,
		timestamp = textChatMessage.Timestamp,
		isVisibleInBubbleChat = v126,
		isVisibleInChatWindow = v125,
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
local function mapByMessageIdInOrderLegacyBubbleChat(t14: {[any]: any}, p11) -- line: 631
	-- upvalues: mapByMessageIdInOrderHelper (copy)
	local messageData = p11.messageData
	local v132 = if not messageData.timestamp then DateTime.now() else DateTime.fromUnixTimestampMillis(messageData.timestamp)
	local t15 = {
		prefixText = "",
		shouldOverrideBubbleChatSettings = true,
		isVisibleInBubbleChat = true,
		isVisibleInChatWindow = false,
		userId = messageData.userId,
		text = messageData.text,
		messageId = messageData.id,
		status = Enum.TextChatMessageStatus.Success,
		timestamp = v132,
		partOrModel = messageData.adornee
	}

	return mapByMessageIdInOrderHelper(t14, t15)
end
local function mapByMessageIdInOrderHiddenMessage(t16: {[any]: any}, p12) -- line: 655
	-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), FIntExpChatRandomCharChangeLowerBound (copy), FIntExpChatRandomCharChangeUpperBound (copy), Config (copy), getFFlagExpChatTelemetryEventTrigger (copy), mapByMessageIdInOrderHelper (copy)
	local userMessageIntent = p12.userMessageIntent
	local v137 = string.len(if not getFFlagExpChatProtectedChatInternalAPIs() then userMessageIntent.Text else userMessageIntent.TextInternal)
	local v138 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v137 - 1))
	local v139 = FIntExpChatRandomCharChangeUpperBound
	local v140 = math.random(v138, v139)
	local v141 = string.rep(Config.DOT_TEXT, v137 + v140)
	local t17 = {
		userId = nil,
		isVisibleInBubbleChat = false,
		isVisibleInChatWindow = true,
		isHiddenMessage = true,
		prefixText = Config.LOCK_EMOJI .. " :",
		text = v141,
		textChannel = userMessageIntent.TextChannel,
		messageId = userMessageIntent.MessageId,
		status = userMessageIntent.Status,
		timestamp = userMessageIntent.Timestamp,
		textChatMessageInstance = if not getFFlagExpChatTelemetryEventTrigger() then nil else userMessageIntent
	}

	return mapByMessageIdInOrderHelper(t16, t17)
end
local function mapUniverseChatSystemMessage(t18: {[any]: any}, p13) -- line: 689
	-- upvalues: HttpService (copy), sanitizeForRichText (copy), GetFFlagExpChatSyntheticSystemMessageRichText (copy), generateRichSystemMessageTextFormat (copy), FFlagExpChatDictation (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), mapByMessageIdInOrderHelper (copy), GetFFlagTextChatEnableUniverseChatTabs (copy)
	local guid = HttpService:GenerateGUID(false)
	local v146 = sanitizeForRichText(p13.text)
	local v147 = if not GetFFlagExpChatSyntheticSystemMessageRichText() then v146 else generateRichSystemMessageTextFormat(v146, if not FFlagExpChatDictation then nil else p13.isError, if not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then nil else p13.postProcessMessage)
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
		text = v147,
		messageId = guid,
		timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
		status = Enum.TextChatMessageStatus.Success,
		metadata = p13.metadata
	}

	return mapByMessageIdInOrderHelper(t18, t19, if not GetFFlagTextChatEnableUniverseChatTabs() then nil else p13.channelNameOverride)
end

return Rodux.createReducer(t1, {
	[ChannelTabsConfigurationEnabled.name] = function(t20: {[any]: any}, p14) -- line: 726
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
	[UserMuted.name] = function(t21: {[any]: any}, p15) -- line: 738
		-- upvalues: Dictionary (copy), Set (copy)
		return Dictionary.join(t21, {
			_mutedUserIds = Set.add(t21._mutedUserIds, p15.userId)
		})
	end,
	[UserUnmuted.name] = function(t22: {[any]: any}, p16) -- line: 743
		-- upvalues: Dictionary (copy), Set (copy)
		return Dictionary.join(t22, {
			_mutedUserIds = Set.subtract(t22._mutedUserIds, p16.userId)
		})
	end,
	[PlayerRemoved.name] = function(t23: {[any]: any}, p17) -- line: 748
		-- upvalues: Dictionary (copy), Set (copy)
		local v157 = Dictionary.filter(t23.bubbleMessagesInOrderBySenderId, function(_, p19) -- line: 751
			-- upvalues: p17 (copy)
			return p19 ~= p17.userId
		end)
		local v158 = Dictionary.filter(t23.messagesBySenderId, function(_, p21) -- line: 755
			-- upvalues: p17 (copy)
			return p21 ~= p17.userId
		end)
		local v159 = Set.has(t23._mutedUserIds, p17.userId)

		if #v157 == 0 and (#v158 == 0 and not v159) then
			return t23
		end

		return Dictionary.join(t23, {
			messagesBySenderId = v158,
			_mutedUserIds = Set.subtract(t23._mutedUserIds, p17.userId)
		})
	end,
	[ChatPrivacySettingsReceived.name] = function(t24: {[any]: any}, p22) -- line: 768
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t24, {
			canLocalUserChat = p22.canUserChat
		})
	end,
	[ChatPrivacySettingsFetchFailed.name] = function(t25: {[any]: any}, _) -- line: 771
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t25, {
			canLocalUserChat = false
		})
	end,
	[ConfigurationObjectsLoaded.name] = function(p24, p25) -- line: 774
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p24, {
			isBubbleChatEnabled = not not p25.bubbleChatSettings.Enabled and p25.bubbleChatSettings.Enabled
		})
	end,
	[BubbleChatSettingsChanged.name] = function(p26, p27) -- line: 781
		-- upvalues: Dictionary (copy)
		if p27.property ~= "Enabled" then
			return p26
		end

		local v168 = Dictionary.map(p26.byMessageId, function(p28) -- line: 786
			-- upvalues: Dictionary (copy), p27 (copy)
			if p28.shouldOverrideBubbleChatSettings then
				return p28
			end

			return Dictionary.join(p28, {
				isVisibleInBubbleChat = p27.value and p28.isVisibleInChatWindow
			})
		end)

		return Dictionary.join(p26, {
			byMessageId = v168,
			isBubbleChatEnabled = p27.value
		})
	end,
	[ChatWindowMessagesCleared.name] = function(t26: {[any]: any}, _) -- line: 801
		-- upvalues: Dictionary (copy)
		local v171 = Dictionary.map(t26.byMessageId, function(p30) -- line: 802
			-- upvalues: Dictionary (copy)
			return Dictionary.join(p30, {
				isVisibleInChatWindow = false
			})
		end)

		return Dictionary.join(t26, {
			windowMessagesInOrder = {},
			windowMessagesInOrderByTabId = {},
			byMessageId = v171
		})
	end,
	[ChatTranslationGlobalToggled.name] = globalToggleTranslations,
	[ChatTranslationMessageToggled.name] = individualToggleTranslation,
	[LegacyBubbleCreated.name] = mapByMessageIdInOrderLegacyBubbleChat,
	[LegacyBubbleTextUpdated.name] = function(t27: {[any]: any}, p31) -- line: 816
		-- upvalues: Dictionary (copy), List (copy)
		local byMessageId = t27.byMessageId
		local messagesBySenderId = t27.messagesBySenderId
		local messageId = p31.messageId
		local newText = p31.newText

		if byMessageId[messageId] then
			local v178 = byMessageId[messageId]

			v178.text = newText
			byMessageId = Dictionary.join(byMessageId, {
				[messageId] = v178
			})

			local userId = v178.userId

			if userId and messagesBySenderId[userId] then
				local v180 = List.findWhere(messagesBySenderId[userId], function(p32, _) -- line: 830
					-- upvalues: messageId (copy)
					return p32.messageId == messageId
				end)

				if v180 and v180 > 0 then
					messagesBySenderId = Dictionary.join(messagesBySenderId, {
						[userId] = List.set(messagesBySenderId[userId], v180, v178)
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
	[HiddenMessagesCleared.name] = function(t28: {[any]: any}, _) -- line: 848
		-- upvalues: FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), Dictionary (copy), List (copy)
		if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
			return t28
		end

		local v183 = Dictionary.map(t28.byMessageId, function(p35) -- line: 853
			-- upvalues: Dictionary (copy)
			if p35.isHiddenMessage then
				return Dictionary.join(p35, {
					isVisibleInChatWindow = false
				})
			end

			return p35
		end)
		local v184 = List.filter(t28.windowMessagesInOrder, function(p36) -- line: 863
			-- upvalues: v183 (copy)
			local v202 = v183[p36]

			return v202 and not v202.isHiddenMessage
		end)
		local v185 = Dictionary.map(t28.windowMessagesInOrderByTabId, function(p37) -- line: 870
			-- upvalues: List (copy), v183 (copy)
			return List.filter(p37, function(p38) -- line: 871
				-- upvalues: v183 (copy)
				local v205 = v183[p38]

				return v205 and not v205.isHiddenMessage
			end)
		end)

		return Dictionary.join(t28, {
			windowMessagesInOrder = v184,
			windowMessagesInOrderByTabId = v185,
			byMessageId = v183
		})
	end
})
