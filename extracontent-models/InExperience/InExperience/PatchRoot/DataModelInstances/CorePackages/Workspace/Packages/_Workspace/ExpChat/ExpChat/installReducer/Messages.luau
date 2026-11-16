local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local shouldRenderTextChannelInDefaultWindow = ExpChatShared.shouldRenderTextChannelInDefaultWindow
local getTextChannelDisplayMode = ExpChatShared.getTextChannelDisplayMode
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local list = llama.List
local dictionary = llama.Dictionary
local set = llama.Set
local none = llama.None

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
local FFlagExpChatFixLocalUserVerifiedBadge = require(ExpChat.Flags.FFlagExpChatFixLocalUserVerifiedBadge)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled

local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local computeNameColor = ChatUIPrimitives.Utils.computeNameColor
local getFFlagExpChatExcludeFOMORenders = require(ExpChat.Flags.getFFlagExpChatExcludeFOMORenders)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDisableUniverseBubbleChat = ExpChatShared.Flags.FFlagExpChatDisableUniverseBubbleChat
local isGlobalBubbleChatEnabled = require(ExpChat.isGlobalBubbleChatEnabled)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local GetFFlagExpChatSyntheticSystemMessageRichText = ExpChatShared.Flags.GetFFlagExpChatSyntheticSystemMessageRichText
local getTextAndTranslation = require(ExpChat.getTextAndTranslation)

local ChannelTabsConfigurationEnabled = require(Actions.ChannelTabsConfigurationEnabled)

local TextChatService = game:GetService("TextChatService")

function getChatTranslationEnabled()
	local success, result = pcall(function()
		return TextChatService.ChatTranslationEnabled
	end)

	return success and result
end

local function resolveChannelNameForMapOrder(data, data2, p: string?)
	if GetFFlagTextChatEnableUniverseChatTabs() then
		if p then
			return p
		end

		if not data2.textChannel then
			return none
		end

		if data2.textChannel.Name == "RBXSystem" or not data.channelTabsConfigurationEnabled then
			return "RBXGeneral"
		end
	else
		if not data2.textChannel then
			return none
		end

		if data2.textChannel.Name == "RBXSystem" then
			return "RBXGeneral"
		end
	end

	return data2.textChannel.Name
end

local function mapByMessageIdInOrderHelper(data, data2, p: string?)
	if
		isWhiteSpaceOnly(data2.text)
		and data2.status ~= Enum.TextChatMessageStatus.Floodchecked
		and data2.status ~= Enum.TextChatMessageStatus.MessageTooLong
	then
		return data
	end

	local partOrModel = data2.partOrModel
	local userId2 = data2.userId
	local messageId = data2.messageId

	local channelNameForMapOrder = resolveChannelNameForMapOrder(data, data2, p)

	local windowMessagesInOrder = data.windowMessagesInOrder
	local v = data.windowMessagesInOrderByTabId[channelNameForMapOrder] or {}
	local byMessageId = data.byMessageId
	local bubbleMessagesInOrderBySenderId = data.bubbleMessagesInOrderBySenderId
	local mockUserIdToPartOrModel = data.mockUserIdToPartOrModel
	local partOrModelToMockUserId = data.partOrModelToMockUserId
	local messagesBySenderId = data.messagesBySenderId

	if not userId2 and partOrModel then
		userId2 = partOrModelToMockUserId[partOrModel]

		if not userId2 then
			userId2 = HttpService:GenerateGUID(false)
			mockUserIdToPartOrModel = dictionary.join(mockUserIdToPartOrModel, {
				[userId2] = partOrModel
			})

			partOrModelToMockUserId = dictionary.join(partOrModelToMockUserId, {
				[partOrModel] = userId2
			})
		end
	end

	local wasRewritten, originalText

	if FFlagEnableInExpChatRewrite then
		wasRewritten = data2.wasRewritten
		originalText = data2.originalText
	end

	if byMessageId[messageId] then
		local v2 = {
			userId = userId2,
			prefixText = data2.prefixText,
			text = data2.text,
			translation = data2.translation,
			useTranslation = data2.useTranslation,
			textChannel = data2.textChannel,
			messageId = messageId,
			status = data2.status,
			timestamp = data2.timestamp,
			isVisibleInBubbleChat = data2.isVisibleInBubbleChat,
			isVisibleInChatWindow = data2.isVisibleInChatWindow,
			shouldOverrideBubbleChatSettings = data2.shouldOverrideBubbleChatSettings,
			bubbleChatMessageProperties = data2.bubbleChatMessageProperties,
			chatWindowMessageProperties = data2.chatWindowMessageProperties,
			metadata = 0,
			textChatMessageInstance = 0,
			wasRewritten = 0,
			originalText = 0,
			chatActionType = 0,
			isUniverseChat = 0,
			presetId = 0,
			presetChatVersion = 0
		}
		local metadata

		if FFlagExpChatDictation then
			metadata = data2.metadata
		end

		v2.metadata = metadata
		local textChatMessageInstance

		if getFFlagExpChatTelemetryEventTrigger() then
			textChatMessageInstance = data2.textChatMessageInstance
		end

		v2.textChatMessageInstance = textChatMessageInstance

		v2.wasRewritten = wasRewritten
		v2.originalText = originalText
		local chatActionType

		if FFlagEnableInExpChatSummaryOnLua then
			chatActionType = data2.chatActionType
		end

		v2.chatActionType = chatActionType
		v2.isUniverseChat = data2.isUniverseChat
		local presetId

		if FFlagExpChatPresetChatEnabled then
			presetId = data2.presetId
		end

		v2.presetId = presetId
		local presetChatVersion

		if FFlagExpChatPresetChatEnabled then
			presetChatVersion = data2.presetChatVersion
		end

		v2.presetChatVersion = presetChatVersion

		local joined = dictionary.join(byMessageId, { [messageId] = v2 })

		if userId2 and messagesBySenderId[userId2] then
			local where = list.findWhere(messagesBySenderId[userId2], function(p2, _): boolean
				return p2.messageId == messageId
			end)

			if where and where > 0 then
				messagesBySenderId = dictionary.join(messagesBySenderId, {
					[userId2] = list.set(messagesBySenderId[userId2], where, v2)
				})
			end
		end

		if
			data2.status == Enum.TextChatMessageStatus.Floodchecked
			or data2.status == Enum.TextChatMessageStatus.MessageTooLong
		then
			windowMessagesInOrder = list.removeIndex(windowMessagesInOrder, list.count(windowMessagesInOrder))

			v = list.removeIndex(v, list.count(v))
			joined = dictionary.removeKey(joined, data2.messageId)

			if userId2 then
				local where = list.findWhere(messagesBySenderId[userId2], function(p2, _): boolean
					return p2.messageId == messageId
				end)

				if where and where > 0 then
					messagesBySenderId = dictionary.join(messagesBySenderId, {
						[userId2] = list.removeIndex(messagesBySenderId[userId2], where)
					})
				end
			end
		end

		return dictionary.join(data, {
			windowMessagesInOrder = windowMessagesInOrder,
			windowMessagesInOrderByTabId = dictionary.join(data.windowMessagesInOrderByTabId, {
				[channelNameForMapOrder] = v
			}),
			byMessageId = joined,
			messagesBySenderId = messagesBySenderId
		})
	else
		if #windowMessagesInOrder == data.messageLimit and data2.isVisibleInChatWindow then
			local v2 = windowMessagesInOrder[1]
			local userId

			if byMessageId[v2] then
				userId = byMessageId[v2].userId
			end

			windowMessagesInOrder = list.removeIndex(windowMessagesInOrder, 1)

			if userId then
				if messagesBySenderId == nil or not messagesBySenderId[userId] then
					if bubbleMessagesInOrderBySenderId ~= nil and bubbleMessagesInOrderBySenderId[userId] then
						local joined = dictionary.join(bubbleMessagesInOrderBySenderId, {
							[userId] = list.removeValue(bubbleMessagesInOrderBySenderId[userId], v2)
						})

						if dictionary.count(joined[userId]) == 0 then
							dictionary.removeKey(joined, userId)

							if mockUserIdToPartOrModel[userId] then
								local partOrModel2 = mockUserIdToPartOrModel[userId]

								if partOrModelToMockUserId[partOrModel2] then
									partOrModelToMockUserId = dictionary.removeKey(partOrModelToMockUserId, partOrModel2)
								end

								mockUserIdToPartOrModel = dictionary.removeKey(mockUserIdToPartOrModel, userId)
							end
						end
					end
				else
					local where = list.findWhere(messagesBySenderId[userId], function(p2, _): boolean
						return p2.messageId == v2
					end)

					if where and where > 0 then
						messagesBySenderId = dictionary.join(messagesBySenderId, {
							[userId] = list.removeIndex(messagesBySenderId[userId], where)
						})
					end

					if dictionary.count(messagesBySenderId[userId]) == 0 then
						messagesBySenderId = dictionary.removeKey(messagesBySenderId, userId)

						if mockUserIdToPartOrModel[userId] then
							local partOrModel2 = mockUserIdToPartOrModel[userId]

							if partOrModelToMockUserId[partOrModel2] then
								partOrModelToMockUserId = dictionary.removeKey(partOrModelToMockUserId, partOrModel2)
							end

							mockUserIdToPartOrModel = dictionary.removeKey(mockUserIdToPartOrModel, userId)
						end
					end
				end
			end

			if #v == data.messageLimit then
				v2 = v[1]
				v = list.removeIndex(v, 1)
				byMessageId = dictionary.removeKey(byMessageId, v2)
			end
		end

		if data2.isVisibleInChatWindow then
			windowMessagesInOrder = list.append(windowMessagesInOrder, messageId)
			v = list.append(v, messageId)
		end

		local join = dictionary.join
		local v2 = {
			windowMessagesInOrder = windowMessagesInOrder,
			windowMessagesInOrderByTabId = dictionary.join(data.windowMessagesInOrderByTabId, {
				[channelNameForMapOrder] = v
			}),
			byMessageId = 0,
			mockUserIdToPartOrModel = 0,
			partOrModelToMockUserId = 0,
			messagesBySenderId = 0
		}

		local join2 = dictionary.join
		local v3 = {
			userId = userId2,
			prefixText = data2.prefixText,
			text = data2.text,
			translation = data2.translation,
			useTranslation = data2.useTranslation,
			messageId = messageId,
			status = data2.status,
			timestamp = data2.timestamp,
			isVisibleInBubbleChat = data2.isVisibleInBubbleChat,
			isVisibleInChatWindow = data2.isVisibleInChatWindow,
			partOrModel = partOrModel,
			shouldOverrideBubbleChatSettings = data2.shouldOverrideBubbleChatSettings,
			bubbleChatMessageProperties = data2.bubbleChatMessageProperties,
			chatWindowMessageProperties = data2.chatWindowMessageProperties,
			textChannel = data2.textChannel,
			metadata = 0,
			textChatMessageInstance = 0,
			isHiddenMessage = 0,
			wasRewritten = 0,
			originalText = 0,
			chatActionType = 0,
			isUniverseChat = 0,
			presetId = 0,
			presetChatVersion = 0
		}
		local metadata

		if FFlagExpChatDictation then
			metadata = data2.metadata
		end

		v3.metadata = metadata
		local textChatMessageInstance

		if getFFlagExpChatTelemetryEventTrigger() then
			textChatMessageInstance = data2.textChatMessageInstance
		end

		v3.textChatMessageInstance = textChatMessageInstance
		local isHiddenMessage

		if FFlagExpChatEnableFOMOUpsell or getFFlagExpChatExcludeFOMORenders() then
			isHiddenMessage = data2.isHiddenMessage
		end

		v3.isHiddenMessage = isHiddenMessage

		v3.wasRewritten = wasRewritten
		v3.originalText = originalText
		local chatActionType

		if FFlagEnableInExpChatSummaryOnLua then
			chatActionType = data2.chatActionType
		end

		v3.chatActionType = chatActionType
		v3.isUniverseChat = data2.isUniverseChat
		local presetId

		if FFlagExpChatPresetChatEnabled then
			presetId = data2.presetId
		end

		v3.presetId = presetId
		local presetChatVersion

		if FFlagExpChatPresetChatEnabled then
			presetChatVersion = data2.presetChatVersion
		end

		v3.presetChatVersion = presetChatVersion
		v2.byMessageId = join2(byMessageId, { [messageId] = v3 })

		v2.mockUserIdToPartOrModel = mockUserIdToPartOrModel
		v2.partOrModelToMockUserId = partOrModelToMockUserId
		local joined

		if userId2 then
			local join3 = dictionary.join
			local append = list.append
			local v4 = messagesBySenderId[userId2] or {}
			local v5 = {
				userId = userId2,
				prefixText = data2.prefixText,
				text = data2.text,
				translation = data2.translation,
				useTranslation = data2.useTranslation,
				messageId = messageId,
				status = data2.status,
				timestamp = data2.timestamp,
				isVisibleInBubbleChat = data2.isVisibleInBubbleChat,
				isVisibleInChatWindow = data2.isVisibleInChatWindow,
				partOrModel = partOrModel,
				shouldOverrideBubbleChatSettings = data2.shouldOverrideBubbleChatSettings,
				bubbleChatMessageProperties = data2.bubbleChatMessageProperties,
				chatWindowMessageProperties = data2.chatWindowMessageProperties,
				textChannel = data2.textChannel,
				textChatMessageInstance = 0,
				wasRewritten = 0,
				originalText = 0,
				chatActionType = 0,
				isUniverseChat = 0,
				presetId = 0,
				presetChatVersion = 0
			}
			local textChatMessageInstance2

			if getFFlagExpChatTelemetryEventTrigger() then
				textChatMessageInstance2 = data2.textChatMessageInstance
			end

			v5.textChatMessageInstance = textChatMessageInstance2

			v5.wasRewritten = wasRewritten
			v5.originalText = originalText
			local chatActionType2

			if FFlagEnableInExpChatSummaryOnLua then
				chatActionType2 = data2.chatActionType
			end

			v5.chatActionType = chatActionType2
			v5.isUniverseChat = data2.isUniverseChat
			local presetId2

			if FFlagExpChatPresetChatEnabled then
				presetId2 = data2.presetId
			end

			v5.presetId = presetId2
			local presetChatVersion2

			if FFlagExpChatPresetChatEnabled then
				presetChatVersion2 = data2.presetChatVersion
			end

			v5.presetChatVersion = presetChatVersion2
			joined = join3(messagesBySenderId, { [userId2] = append(v4, v5) })
		end

		v2.messagesBySenderId = joined
		return join(data, v2)
	end
end

local function globalToggleTranslations(p, p2)
	local useTranslation = p2.useTranslation
	local byMessageId = p.byMessageId
	local v = {}

	for k, _ in pairs(byMessageId) do
		local v2 = byMessageId[k]

		if v2 == nil then
			continue
		end

		local v3 = {
			prefixText = v2.prefixText,
			text = v2.text,
			translation = v2.translation,
			useTranslation = useTranslation,
			messageId = v2.messageId,
			status = v2.status,
			timestamp = v2.timestamp,
			isVisibleInBubbleChat = v2.isVisibleInBubbleChat,
			isVisibleInChatWindow = v2.isVisibleInChatWindow,
			partOrModel = v2.partOrModel,
			shouldOverrideBubbleChatSettings = v2.shouldOverrideBubbleChatSettings,
			bubbleChatMessageProperties = v2.bubbleChatMessageProperties,
			chatWindowMessageProperties = v2.chatWindowMessageProperties,
			userId = v2.userId,
			textChannel = v2.textChannel,
			textChatMessageInstance = 0,
			wasRewritten = 0,
			originalText = 0,
			chatActionType = 0,
			presetId = 0,
			presetChatVersion = 0
		}
		local textChatMessageInstance

		if getFFlagExpChatTelemetryEventTrigger() then
			textChatMessageInstance = v2.textChatMessageInstance
		end

		v3.textChatMessageInstance = textChatMessageInstance
		local wasRewritten

		if FFlagEnableInExpChatRewrite then
			wasRewritten = v2.wasRewritten
		end

		v3.wasRewritten = wasRewritten
		local originalText

		if FFlagEnableInExpChatRewrite then
			originalText = v2.originalText
		end

		v3.originalText = originalText
		local chatActionType

		if FFlagEnableInExpChatSummaryOnLua then
			chatActionType = v2.chatActionType
		end

		v3.chatActionType = chatActionType
		local presetId

		if FFlagExpChatPresetChatEnabled then
			presetId = v2.presetId
		end

		v3.presetId = presetId
		local presetChatVersion

		if FFlagExpChatPresetChatEnabled then
			presetChatVersion = v2.presetChatVersion
		end

		v3.presetChatVersion = presetChatVersion
		v[k] = v3
	end

	return dictionary.join(p, {
		byMessageId = dictionary.join(byMessageId, v)
	})
end

local function individualToggleTranslation(p, p2)
	local useTranslation = p2.useTranslation
	local messageId = p2.messageId
	local byMessageId = p.byMessageId

	local v = byMessageId[messageId]

	if v == nil then
		return nil
	end

	local join = dictionary.join
	local join2 = dictionary.join
	local v2 = {
		prefixText = v.prefixText,
		text = v.text,
		translation = v.translation,
		useTranslation = useTranslation,
		messageId = v.messageId,
		status = v.status,
		timestamp = v.timestamp,
		isVisibleInBubbleChat = v.isVisibleInBubbleChat,
		isVisibleInChatWindow = v.isVisibleInChatWindow,
		partOrModel = v.partOrModel,
		shouldOverrideBubbleChatSettings = v.shouldOverrideBubbleChatSettings,
		bubbleChatMessageProperties = v.bubbleChatMessageProperties,
		chatWindowMessageProperties = v.chatWindowMessageProperties,
		userId = v.userId,
		textChannel = v.textChannel,
		textChatMessageInstance = 0,
		wasRewritten = 0,
		originalText = 0,
		chatActionType = 0,
		presetId = 0,
		presetChatVersion = 0
	}
	local textChatMessageInstance

	if getFFlagExpChatTelemetryEventTrigger() then
		textChatMessageInstance = v.textChatMessageInstance
	end

	v2.textChatMessageInstance = textChatMessageInstance
	local wasRewritten

	if FFlagEnableInExpChatRewrite then
		wasRewritten = v.wasRewritten
	end

	v2.wasRewritten = wasRewritten
	local originalText

	if FFlagEnableInExpChatRewrite then
		originalText = v.originalText
	end

	v2.originalText = originalText
	local chatActionType

	if FFlagEnableInExpChatSummaryOnLua then
		chatActionType = v.chatActionType
	end

	v2.chatActionType = chatActionType
	local presetId

	if FFlagExpChatPresetChatEnabled then
		presetId = v.presetId
	end

	v2.presetId = presetId
	local presetChatVersion

	if FFlagExpChatPresetChatEnabled then
		presetChatVersion = v.presetChatVersion
	end

	v2.presetChatVersion = presetChatVersion
	return join(p, {
		byMessageId = join2(byMessageId, { [messageId] = v2 })
	})
end

local function mapByMessageIdInOrderBubbleChat(p, p2)
	local bubbleChatMessageTable = p2.bubbleChatMessageTable

	return mapByMessageIdInOrderHelper(p, {
		userId = bubbleChatMessageTable.bubbleChatMessageUserId,
		prefixText = "",
		text = bubbleChatMessageTable.message,
		translation = bubbleChatMessageTable.translation,
		useTranslation = getChatTranslationEnabled(),
		messageId = bubbleChatMessageTable.bubbleChatMessageId,
		status = Enum.TextChatMessageStatus.Success,
		timestamp = bubbleChatMessageTable.timestamp,
		partOrModel = bubbleChatMessageTable.partOrModel,
		shouldOverrideBubbleChatSettings = true,
		isVisibleInBubbleChat = true,
		isVisibleInChatWindow = false,
		bubbleChatMessageProperties = bubbleChatMessageTable.bubbleChatMessageProperties
	})
end

local function mapByMessageIdInOrder(data, data2)
	local textChatMessage = data2.textChatMessage
	local text, translation

	if FFlagEnableInExpChatRewrite then
		text, translation = getTextAndTranslation(textChatMessage)
	else
		if getFFlagExpChatProtectedChatInternalAPIs() then
			text = textChatMessage.TextInternal
		else
			text = textChatMessage.Text
		end

		if getFFlagExpChatProtectedChatInternalAPIs() then
			translation = textChatMessage.TranslationInternal
		else
			translation = textChatMessage.Translation
		end
	end

	local userId

	if textChatMessage.TextSource then
		userId = tostring(textChatMessage.TextSource.UserId)
	elseif FFlagExpChatFixLocalUserVerifiedBadge and data2.type == OutgoingMessageSent.name and Players.LocalPlayer then
		userId = tostring(Players.LocalPlayer.UserId)
	end

	local v

	if userId == nil then
		v = true
	elseif data.canLocalUserChat or FFlagExpChatPresetChatEnabled and (textChatMessage.PresetId or "") ~= "" then
		v = textChatMessage.Status == Enum.TextChatMessageStatus.Success
			or textChatMessage.Status == Enum.TextChatMessageStatus.Sending
	else
		v = false
	end

	local v2

	if userId then
		v2 = set.has(data._mutedUserIds, userId)
	else
		v2 = false
	end

	local isVisibleInChatWindow = v and not v2
	local isVisibleInBubbleChat = false
	local v3

	if FFlagExpChatUseChatConfigStore then
		v3 = GetChatConfigurationStore(false).getIsBubbleChatEnabled(false)
	else
		v3 = data.isBubbleChatEnabled
	end

	isVisibleInBubbleChat = v3
		and isVisibleInChatWindow
		and (not FFlagEnableInExpChatSummaryOnLua or userId ~= nil)
		and (textChatMessage.Status == Enum.TextChatMessageStatus.Success or textChatMessage.Status == Enum.TextChatMessageStatus.Sending)
		and true
		or false

	if
		FFlagExpChatDisableUniverseBubbleChat
		and GetFFlagTextChatEnableUniverseChatTabs()
		and data2.isUniverseChat == true
		and not (FFlagExpChatGlobalTabDefault and isGlobalBubbleChatEnabled())
	then
		isVisibleInBubbleChat = false
	end

	if
		not data2.isUniverseChat
		and data2.channelNameOverride == nil
		and not shouldRenderTextChannelInDefaultWindow(textChatMessage.TextChannel, getTextChannelDisplayMode())
	then
		isVisibleInChatWindow = false
	end

	local prefixText

	if getFFlagExpChatProtectedChatInternalAPIs() then
		prefixText = textChatMessage.PrefixTextInternal
	else
		prefixText = textChatMessage.PrefixText
	end

	if GetFFlagTextChatEnableUniverseChatTabs() and data2.channelNameOverride and #prefixText > 0 then
		local v4

		if textChatMessage.TextSource then
			v4 = computeNameColor(textChatMessage.TextSource.Username)
		else
			v4 = computeNameColor(Players.LocalPlayer.Name)
		end

		prefixText = `<font color="#{v4:ToHex()}">{prefixText}</font>`
	end

	local v4 = {
		userId = userId,
		prefixText = prefixText,
		text = text,
		translation = translation,
		useTranslation = getChatTranslationEnabled(),
		textChannel = textChatMessage.TextChannel,
		messageId = textChatMessage.MessageId,
		status = textChatMessage.Status,
		timestamp = textChatMessage.Timestamp,
		isVisibleInBubbleChat = isVisibleInBubbleChat,
		isVisibleInChatWindow = isVisibleInChatWindow,
		bubbleChatMessageProperties = textChatMessage.BubbleChatMessageProperties,
		chatWindowMessageProperties = textChatMessage.ChatWindowMessageProperties,
		textChatMessageInstance = 0,
		wasRewritten = 0,
		originalText = 0,
		chatActionType = 0,
		isUniverseChat = 0,
		presetId = 0,
		presetChatVersion = 0
	}
	local textChatMessageInstance

	if getFFlagExpChatTelemetryEventTrigger() then
		textChatMessageInstance = textChatMessage
	end

	v4.textChatMessageInstance = textChatMessageInstance
	local wasRewritten

	if FFlagEnableInExpChatRewrite then
		wasRewritten = textChatMessage.WasRewritten
	end

	v4.wasRewritten = wasRewritten
	local originalText

	if FFlagEnableInExpChatRewrite then
		originalText = textChatMessage.OriginalText
	end

	v4.originalText = originalText
	local chatActionType

	if FFlagEnableInExpChatSummaryOnLua then
		chatActionType = textChatMessage.ChatActionType
	end

	v4.chatActionType = chatActionType
	v4.isUniverseChat = data2.isUniverseChat
	local presetId

	if FFlagExpChatPresetChatEnabled then
		presetId = textChatMessage.PresetId
	end

	v4.presetId = presetId
	local presetChatVersion

	if FFlagExpChatPresetChatEnabled then
		presetChatVersion = textChatMessage.PresetChatVersion
	end

	v4.presetChatVersion = presetChatVersion
	local v5

	if GetFFlagTextChatEnableUniverseChatTabs() then
		v5 = data2.channelNameOverride
	end

	return mapByMessageIdInOrderHelper(data, v4, v5)
end

local function mapByMessageIdInOrderLegacyBubbleChat(p, p2)
	local messageData = p2.messageData
	local timestamp

	if messageData.timestamp then
		timestamp = DateTime.fromUnixTimestampMillis(messageData.timestamp)
	else
		timestamp = DateTime.now()
	end

	return mapByMessageIdInOrderHelper(p, {
		userId = messageData.userId,
		prefixText = "",
		text = messageData.text,
		messageId = messageData.id,
		status = Enum.TextChatMessageStatus.Success,
		timestamp = timestamp,
		partOrModel = messageData.adornee,
		shouldOverrideBubbleChatSettings = true,
		isVisibleInBubbleChat = true,
		isVisibleInChatWindow = false
	})
end

local function mapByMessageIdInOrderHiddenMessage(p, p2)
	local userMessageIntent = p2.userMessageIntent
	local v

	if getFFlagExpChatProtectedChatInternalAPIs() then
		v = userMessageIntent.TextInternal
	else
		v = userMessageIntent.Text
	end

	local v2 = string.len(v)

	local v3 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v2 - 1))

	local v4 = math.random(v3, FIntExpChatRandomCharChangeUpperBound)
	local text = string.rep(Config.DOT_TEXT, v2 + v4)

	local v5 = {
		userId = nil,
		prefixText = Config.LOCK_EMOJI .. " :",
		text = text,
		textChannel = userMessageIntent.TextChannel,
		messageId = userMessageIntent.MessageId,
		status = userMessageIntent.Status,
		timestamp = userMessageIntent.Timestamp,
		isVisibleInBubbleChat = false,
		isVisibleInChatWindow = true,
		textChatMessageInstance = 0,
		isHiddenMessage = true
	}

	if not getFFlagExpChatTelemetryEventTrigger() then
		userMessageIntent = nil
	end

	v5.textChatMessageInstance = userMessageIntent

	return mapByMessageIdInOrderHelper(p, v5)
end

local function mapUniverseChatSystemMessage(p, data)
	local guid = HttpService:GenerateGUID(false)
	local text = sanitizeForRichText(data.text)

	if GetFFlagExpChatSyntheticSystemMessageRichText() then
		local v

		if FFlagExpChatDictation then
			v = data.isError
		end

		text = generateRichSystemMessageTextFormat(text, v, data.postProcessMessage)
	end

	local v = {
		userId = nil,
		prefixText = "",
		text = text,
		translation = nil,
		useTranslation = false,
		messageId = guid,
		timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
		status = Enum.TextChatMessageStatus.Success,
		isVisibleInChatWindow = true,
		isVisibleInBubbleChat = false,
		textChannel = nil,
		bubbleChatMessageProperties = nil,
		chatWindowMessageProperties = nil,
		textChatMessageInstance = nil,
		partOrModel = nil,
		metadata = data.metadata
	}
	local v2

	if GetFFlagTextChatEnableUniverseChatTabs() then
		v2 = data.channelNameOverride
	end

	return mapByMessageIdInOrderHelper(p, v, v2)
end

return Rodux.createReducer({
	canLocalUserChat = false,
	isBubbleChatEnabled = false,
	_mutedUserIds = {},
	channelTabsConfigurationEnabled = false,
	messageLimit = 50,
	windowMessagesInOrder = {},
	windowMessagesInOrderByTabId = {},
	byMessageId = {},
	bubbleMessagesInOrderBySenderId = {},
	mockUserIdToPartOrModel = {},
	partOrModelToMockUserId = {},
	messagesBySenderId = {}
}, {
	[ChannelTabsConfigurationEnabled.name] = function(p, p2)
		if GetFFlagTextChatEnableUniverseChatTabs() then
			return dictionary.join(p, { channelTabsConfigurationEnabled = p2.enabled })
		end

		return p
	end,
	[IncomingMessageReceived.name] = mapByMessageIdInOrder,
	[IncomingBubbleChatMessageReceived.name] = mapByMessageIdInOrderBubbleChat,
	[OutgoingMessageSent.name] = mapByMessageIdInOrder,
	[UserMuted.name] = function(p, p2)
		return dictionary.join(p, {
			_mutedUserIds = set.add(p._mutedUserIds, p2.userId)
		})
	end,
	[UserUnmuted.name] = function(p, p2)
		return dictionary.join(p, {
			_mutedUserIds = set.subtract(p._mutedUserIds, p2.userId)
		})
	end,
	[PlayerRemoved.name] = function(data, p)
		local filtered = dictionary.filter(data.bubbleMessagesInOrderBySenderId, function(_, p2): boolean
			return p2 ~= p.userId
		end)

		local filtered2 = dictionary.filter(data.messagesBySenderId, function(_, p2): boolean
			return p2 ~= p.userId
		end)

		local v = not set.has(data._mutedUserIds, p.userId)

		if #filtered == 0 and #filtered2 == 0 and v then
			return data
		end

		return dictionary.join(data, {
			messagesBySenderId = filtered2,
			_mutedUserIds = set.subtract(data._mutedUserIds, p.userId)
		})
	end,
	[ChatPrivacySettingsReceived.name] = function(p, p2)
		return dictionary.join(p, { canLocalUserChat = p2.canUserChat })
	end,
	[ChatPrivacySettingsFetchFailed.name] = function(p, _)
		return dictionary.join(p, { canLocalUserChat = false })
	end,
	[ConfigurationObjectsLoaded.name] = function(p, p2)
		local join = dictionary.join
		local isBubbleChatEnabled

		if p2.bubbleChatSettings.Enabled then
			isBubbleChatEnabled = p2.bubbleChatSettings.Enabled
		else
			isBubbleChatEnabled = false
		end

		return join(p, { isBubbleChatEnabled = isBubbleChatEnabled })
	end,
	[BubbleChatSettingsChanged.name] = function(p, p2)
		if p2.property ~= "Enabled" then
			return p
		end

		local mapped = dictionary.map(p.byMessageId, function(p3)
			if p3.shouldOverrideBubbleChatSettings then
				return p3
			end

			return dictionary.join(p3, {
				isVisibleInBubbleChat = p2.value and p3.isVisibleInChatWindow
			})
		end)

		return dictionary.join(p, { byMessageId = mapped, isBubbleChatEnabled = p2.value })
	end,
	[ChatWindowMessagesCleared.name] = function(p, _)
		local mapped = dictionary.map(p.byMessageId, function(p2)
			return dictionary.join(p2, { isVisibleInChatWindow = false })
		end)

		return dictionary.join(p, {
			windowMessagesInOrder = {},
			windowMessagesInOrderByTabId = {},
			byMessageId = mapped
		})
	end,
	[ChatTranslationGlobalToggled.name] = globalToggleTranslations,
	[ChatTranslationMessageToggled.name] = individualToggleTranslation,
	[LegacyBubbleCreated.name] = mapByMessageIdInOrderLegacyBubbleChat,
	[LegacyBubbleTextUpdated.name] = function(p, p2)
		local byMessageId = p.byMessageId
		local messagesBySenderId = p.messagesBySenderId
		local messageId = p2.messageId
		local newText = p2.newText

		if byMessageId[messageId] then
			local v = byMessageId[messageId]
			v.text = newText
			byMessageId = dictionary.join(byMessageId, { [messageId] = v })

			local userId = v.userId

			if userId and messagesBySenderId[userId] then
				local where = list.findWhere(messagesBySenderId[userId], function(p3, _): boolean
					return p3.messageId == messageId
				end)

				if where and where > 0 then
					messagesBySenderId = dictionary.join(messagesBySenderId, {
						[userId] = list.set(messagesBySenderId[userId], where, v)
					})
				end
			end
		end

		return dictionary.join(p, {
			byMessageId = byMessageId,
			messagesBySenderId = messagesBySenderId
		})
	end,
	[HiddenMessageReceived.name] = mapByMessageIdInOrderHiddenMessage,
	[UniverseChatSystemMessageAdded.name] = mapUniverseChatSystemMessage,
	[HiddenMessagesCleared.name] = function(data, _)
		if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
			return data
		end

		local mapped = dictionary.map(data.byMessageId, function(p)
			if p.isHiddenMessage then
				return dictionary.join(p, { isVisibleInChatWindow = false })
			end

			return p
		end)

		local filtered = list.filter(data.windowMessagesInOrder, function(p)
			local v = mapped[p]
			return v and not v.isHiddenMessage
		end)

		local mapped2 = dictionary.map(data.windowMessagesInOrderByTabId, function(p)
			return list.filter(p, function(p2)
				local v = mapped[p2]
				return v and not v.isHiddenMessage
			end)
		end)

		return dictionary.join(data, {
			windowMessagesInOrder = filtered,
			windowMessagesInOrderByTabId = mapped2,
			byMessageId = mapped
		})
	end
})
