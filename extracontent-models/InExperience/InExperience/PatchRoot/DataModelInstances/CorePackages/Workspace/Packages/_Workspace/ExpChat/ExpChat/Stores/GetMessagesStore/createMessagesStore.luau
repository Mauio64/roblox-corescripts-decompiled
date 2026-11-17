local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local SignalsExperimental = require(parent.SignalsExperimental)
local SharedFlags = require(parent.SharedFlags)
local isWhiteSpaceOnly = require(ExpChat.isWhiteSpaceOnly)

local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local computeNameColor = ChatUIPrimitives.Utils.computeNameColor
require(ExpChat.TextChatMessageChatActionType)
local ExpChatShared = require(ExpChat.Parent.ExpChatShared)
local shouldRenderTextChannelInDefaultWindow = ExpChatShared.shouldRenderTextChannelInDefaultWindow
local getTextChannelDisplayMode = ExpChatShared.getTextChannelDisplayMode
local getTextAndTranslation = require(ExpChat.getTextAndTranslation)
local getServerTimeNowMillis = require(ExpChat.BubbleChat.Helpers.getServerTimeNowMillis)
local Config = require(ExpChat.Config)
local sanitizeForRichText = require(ExpChat.sanitizeForRichText)
local generateRichSystemMessageTextFormat = require(ExpChat.generateRichSystemMessageTextFormat)

local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local llama = require(parent.llama)
local list = llama.List
local dictionary = llama.Dictionary
local set = llama.Set

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local createProxy = SignalsExperimental.createProxy
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagEnableInExpChatRewrite = require(ExpChat.Flags.FFlagEnableInExpChatRewrite)
local FFlagEnableInExpChatSummaryOnLua = require(ExpChat.Flags.FFlagEnableInExpChatSummaryOnLua)
local FIntExpChatRandomCharChangeLowerBound = require(ExpChat.Flags.FIntExpChatRandomCharChangeLowerBound)
local FIntExpChatRandomCharChangeUpperBound = require(ExpChat.Flags.FIntExpChatRandomCharChangeUpperBound)
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)

local FFlagExpChatClearHiddenMessagesPostAgeCheck = require(ExpChat.Flags.FFlagExpChatClearHiddenMessagesPostAgeCheck)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local FFlagExpChatDisableUniverseBubbleChat = ExpChatShared.Flags.FFlagExpChatDisableUniverseBubbleChat
local isGlobalBubbleChatEnabled = require(ExpChat.isGlobalBubbleChatEnabled)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local GetFFlagExpChatSyntheticSystemMessageRichText = ExpChatShared.Flags.GetFFlagExpChatSyntheticSystemMessageRichText

local FFlagExpChatMessagesStoreKeepInByMessageId = require(ExpChat.Flags.FFlagExpChatMessagesStoreKeepInByMessageId)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation
local FFlagExpChatMessagesStoreBatch = require(ExpChat.Flags.FFlagExpChatMessagesStoreBatch)
local FFlagExpChatMessagesStoreUseProxy = require(ExpChat.Flags.FFlagExpChatMessagesStoreUseProxy)
local FFlagExpChatMessagesStoreMemoryCleanup = require(ExpChat.Flags.FFlagExpChatMessagesStoreMemoryCleanup)

local FFlagExpChatEvictFloodcheckedFromWindowOrder = require(ExpChat.Flags.FFlagExpChatEvictFloodcheckedFromWindowOrder)
local FFlagExpChatFixLocalUserVerifiedBadge = require(ExpChat.Flags.FFlagExpChatFixLocalUserVerifiedBadge)
local isBorderlessBubbleChatEnabled = require(ExpChat.isBorderlessBubbleChatEnabled)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiEffectExperimentation = SocialExperiments.ExpChatPresetChatEmojiEffectExperimentation
local logPresetChatEmojiEffectExposure = require(ExpChat.PresetChat.logPresetChatEmojiEffectExposure)
local FFlagExpChatRenderHistoricalMessages = require(ExpChat.Flags.FFlagExpChatRenderHistoricalMessages)
local FFlagExpChatMessageHistoryExperiment = SharedFlags.FFlagExpChatMessageHistoryExperiment
local SocialExperiments2 = require(parent.SocialExperiments)
local ExpChatMessageHistoryExperimentation = SocialExperiments2.ExpChatMessageHistoryExperimentation

function getChatTranslationEnabled()
	return TextChatService.ChatTranslationEnabled
end

local function createMessagesStore(callback)
	local v = {
		canLocalUserChat = false,
		isBubbleChatEnabled = false,
		mutedUserIds = {},
		messageLimit = 50,
		windowMessagesInOrder = {},
		windowMessagesInOrderByTabId = {},
		byMessageId = {},
		mockUserIdToPartOrModel = {},
		partOrModelToMockUserId = {},
		messagesBySenderId = {},
		messageComponentRingBuffer = {},
		nextMessageComponentPointer = 1
	}

	local signal, v2 = createSignal(v.byMessageId)
	local result

	if FFlagExpChatMessagesStoreUseProxy then
		result = createProxy({})
	else
		result = nil
	end

	local signal2, v3 = createSignal(v.messagesBySenderId)
	local v4

	if FFlagExpChatMessagesStoreUseProxy then
		v4 = createProxy({})
	else
		v4 = nil
	end

	local signal3, v5 = createSignal(v.windowMessagesInOrder)

	local signal4, v6 = createSignal(v.windowMessagesInOrderByTabId)
	local signal5, v7 = createSignal(v.mutedUserIds)
	local getMutedUserIds

	if callback == nil then
		getMutedUserIds = signal5
	else
		getMutedUserIds = createComputed(function(p)
			local v8 = signal5(p)
			local v9 = callback(p)
			local clone = table.clone(v8)

			for k in v9 do
				clone[k] = true
			end

			return clone
		end)
	end

	local signal6, setCanLocalUserChat = createSignal(v.canLocalUserChat)
	local signal7, _ = createSignal(v.isBubbleChatEnabled)
	local signal8, v8 = createSignal(v.mockUserIdToPartOrModel)
	local signal9, v9 = createSignal(v.partOrModelToMockUserId)

	local signal10, setChannelTabsConfigurationEnabled = createSignal(false)

	local signal11, v10 = createSignal(v.messageComponentRingBuffer)

	local signal12, v11 = createSignal(v.nextMessageComponentPointer)

	local v12 = {}

	local total = 0
	local total2 = 0

	local v13 = {}

	local signal13, setActiveChannelFilter = createSignal(nil)

	local updateNextMessageComponent
	local repopulateMessageComponents
	local flag = false
	local flag2 = false

	local v14 = {}

	local function readByMessageId() -- 7 equivalent calls inferred from this helper
		if FFlagExpChatMessagesStoreUseProxy then
			return result
		end

		return signal(false)
	end

	local function readByMessageIdReactive(p) -- 5 equivalent calls inferred from this helper
		if FFlagExpChatMessagesStoreUseProxy then
			return result(p)
		end

		return signal(p)
	end

	local function writeByMessageId(messageId: string, p)
		if FFlagExpChatMessagesStoreUseProxy then
			result[messageId] = p
		elseif p == nil then
			v2(function(p2)
				return dictionary.removeKey(p2, messageId)
			end)
		else
			v2(function(p2)
				return dictionary.join(p2, { [messageId] = p })
			end)
		end
	end

	local function updateByMessageId(p: string, callback2)
		if FFlagExpChatMessagesStoreUseProxy then
			local v15 = result[p]

			local v16 = v15 and callback2(v15)

			if v16 then
				result[p] = v16
			end
		else
			v2(function(options)
				if not (options and options[p]) then
					return options or {}
				end

				local v15 = callback2(options[p])

				if v15 then
					return dictionary.join(options, { [p] = v15 })
				end

				return options
			end)
		end
	end

	local function forEachByMessageId(fn)
		if not FFlagExpChatMessagesStoreUseProxy then
			v2(function(items)
				if not items then
					return {}
				end

				local result2 = {}

				for k, item in items do
					result2[k] = fn(k, item) or item
				end

				return result2
			end)

			return
		end

		for k in result do
			local v15 = result[k]

			if not v15 then
				continue
			end

			local v16 = fn(k, v15)

			if v16 then
				result[k] = v16
			end
		end
	end

	local function readMessagesBySenderIdReactive(p) -- 2 equivalent calls inferred from this helper
		if FFlagExpChatMessagesStoreUseProxy then
			return v4(p)
		end

		return signal2(p)
	end

	local function writeMessagesBySenderId(p: string, p2)
		if FFlagExpChatMessagesStoreUseProxy then
			v4[p] = p2
		elseif p2 == nil then
			v3(function(p3)
				return dictionary.removeKey(p3, p)
			end)
		else
			v3(function(p3)
				return dictionary.join(p3, { [p] = p2 })
			end)
		end
	end

	local function updateMessagesBySenderId(userId: string, fn) -- 4 equivalent calls inferred from this helper
		if not FFlagExpChatMessagesStoreUseProxy then
			v3(function(p)
				local v15 = fn(p[userId])

				if v15 == nil then
					return dictionary.removeKey(p, userId)
				end

				return dictionary.join(p, { [userId] = v15 })
			end)

			return
		end

		v4[userId] = fn(v4[userId])
	end

	local function resolveChannelNameForMapOrder(state, channelNameOverride: string?)
		if GetFFlagTextChatEnableUniverseChatTabs() then
			if channelNameOverride then
				return channelNameOverride
			end

			if not state.textChannel then
				return nil
			end

			if state.textChannel.Name == "RBXSystem" or not signal10(false) then
				return "RBXGeneral"
			end
		else
			if not state.textChannel then
				return nil
			end

			if state.textChannel.Name == "RBXSystem" then
				return "RBXGeneral"
			end
		end

		return state.textChannel.Name
	end

	local function maybeBatch(callback2) -- 7 equivalent calls inferred from this helper
		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(callback2)
		else
			callback2()
		end
	end

	local function batchWrites(callback2)
		if flag then
			maybeBatch(callback2) -- inferred equivalent call
		else
			flag = true
			flag2 = false
			maybeBatch(callback2) -- inferred equivalent call
			flag = false

			if flag2 then
				flag2 = false
				repopulateMessageComponents()
			end
		end
	end

	local function isHistoricalWindowMessage(p: string): boolean -- 3 equivalent calls inferred from this helper
		local v15 = readByMessageId() -- inferred equivalent call
		local v16 = v15 and v15[p]
		return v16 ~= nil and v16.isHistorical == true
	end

	local function countHistoricalPrefix(list2, callback2)
		local count = 0

		for _, item in ipairs(list2) do
			local v15 = callback2(item)

			if v15 and v15.isHistorical then
				count += 1
			else
				break
			end
		end

		return count
	end

	local getHistoricalWindowMessageCount

	if FFlagExpChatRenderHistoricalMessages then
		getHistoricalWindowMessageCount = createComputed(function(p)
			local v15 = readByMessageIdReactive(p) -- inferred equivalent call
			return countHistoricalPrefix(signal3(p), function(p2)
				return v15[p2]
			end)
		end)
	end

	local function insertWindowMessageIdInOrder(list2, messageId: string, isHistorical: boolean?)
		if not (FFlagExpChatRenderHistoricalMessages and isHistorical) then
			return list.append(list2, messageId)
		end

		local v15 = readByMessageId() -- inferred equivalent call
		local v16 = countHistoricalPrefix(list2, function(p)
			return v15[p]
		end)

		if v16 == #list2 then
			return list.append(list2, messageId)
		end

		return list.insert(list2, v16 + 1, messageId)
	end

	local function capHistoricalPrefix(list2, p)
		if not p.isHistorical then
			return list2
		end

		local historyArm = ExpChatMessageHistoryExperimentation.getHistoryArm(signal6(false))
		local v15 = readByMessageId() -- inferred equivalent call

		local function resolve(p2: string) -- 1 equivalent call inferred from this helper
			if p2 == p.messageId then
				return p
			end

			return v15 and v15[p2]
		end

		local v16 = countHistoricalPrefix(list2, resolve)
		local v17 = not historyArm and 0 or historyArm.maxCount
		local v18 = not historyArm and 0 or historyArm.maxAgeSeconds
		local v19 = math.max(1, v16 - v17 + 1)

		if v18 > 0 then
			local v20 = workspace:GetServerTimeNow() - v18

			for i = v19, v16 do
				local v21 = resolve(list2[i]) -- inferred equivalent call

				if v21 and v20 <= v21.timestamp.UnixTimestamp then
					break
				end

				v19 = i + 1
			end
		end

		if v19 == 1 then
			return list2
		end

		if #list2 < v19 then
			return {}
		end

		return list.slice(list2, v19)
	end

	local function shouldDropHistoricalAtLimit(state) -- 1 equivalent call inferred from this helper
		local v15 = signal3(false)
		local v16

		if state.isHistorical == true then
			v16 = state.isVisibleInChatWindow

			if v16 then
				if #v15 >= v.messageLimit then
					return not isHistoricalWindowMessage(v15[1]) -- inferred equivalent call
				end

				return false
			end
		else
			return false
		end

		return v16
	end

	local function syncPoolForInsert(messageId: string, flag3: boolean) -- 1 equivalent call inferred from this helper
		if not (flag3 or flag2) then
			updateNextMessageComponent(messageId)
		elseif flag then
			flag2 = true
		else
			repopulateMessageComponents()
		end
	end

	local function keepHistoricalFlag(state)
		if isHistoricalWindowMessage(state.messageId) then -- inferred equivalent call
			return dictionary.join(state, { isHistorical = true })
		end

		return state
	end

	local function addMessage(state) -- 5 equivalent calls inferred from this helper
		local function fn()
			local v15 = readByMessageId() -- inferred equivalent call

			if isBorderlessBubbleChatEnabled() then
				local v16 = v15 and v15[state.messageId]

				state.bubbleChatReceivedAtMillis = v16 and v16.bubbleChatReceivedAtMillis or getServerTimeNowMillis()
			end

			if v15 and v15[state.messageId] then
				if
					FFlagExpChatEvictFloodcheckedFromWindowOrder
					and (state.status == Enum.TextChatMessageStatus.Floodchecked or state.status == Enum.TextChatMessageStatus.MessageTooLong)
				then
					v5(function(p)
						return list.filter(p, function(p2): boolean
							return p2 ~= state.messageId
						end)
					end)

					local channelNameForMapOrder = resolveChannelNameForMapOrder(state, state.channelNameOverride)

					if channelNameForMapOrder then
						v6(function(p)
							local v16 = p[channelNameForMapOrder]

							if not v16 then
								return p
							end

							local filtered = list.filter(v16, function(p2): boolean
								return p2 ~= state.messageId
							end)

							return dictionary.join(p, { [channelNameForMapOrder] = filtered })
						end)
					end

					local messageId = state.messageId

					if FFlagExpChatMessagesStoreUseProxy then
						result[messageId] = nil
					else
						v2(function(p)
							return dictionary.removeKey(p, messageId)
						end)
					end

					if state.userId then
						local function fn2(p)
							if not p then
								return nil
							end

							local filtered

							if FFlagExpChatMessagesStoreMemoryCleanup then
								filtered = list.filter(p, function(p2): boolean
									return p2 ~= state.messageId
								end)
							else
								filtered = list.filter(p, function(p2): boolean
									return p2.messageId ~= state.messageId
								end)
							end

							if #filtered == 0 then
								return nil
							end

							return filtered
						end

						updateMessagesBySenderId(state.userId, fn2) -- inferred equivalent call
					end
				else
					if FFlagExpChatRenderHistoricalMessages then
						writeByMessageId(state.messageId, keepHistoricalFlag(state))
					else
						writeByMessageId(state.messageId, state)
					end

					if not FFlagExpChatMessagesStoreMemoryCleanup and state.userId then
						local function fn2(list2)
							if not list2 then
								return nil
							end

							local v16 = nil

							for i, item in ipairs(list2) do
								if item.messageId == state.messageId then
									v16 = i
									break
								end
							end

							if v16 then
								return list.set(list2, v16, state)
							end

							return list2
						end

						updateMessagesBySenderId(state.userId, fn2) -- inferred equivalent call
					end
				end
			else
				if FFlagExpChatRenderHistoricalMessages and shouldDropHistoricalAtLimit(state) then -- inferred equivalent call
					return
				end

				local userId = state.userId
				local partOrModel = state.partOrModel

				if not userId and partOrModel then
					userId = signal9(false)[partOrModel]

					if not userId then
						userId = HttpService:GenerateGUID(false)

						v8(function(p)
							return dictionary.join(p, { [userId] = partOrModel })
						end)

						v9(function(p)
							return dictionary.join(p, { [partOrModel] = userId })
						end)
					end
				end

				local v16

				if userId == state.userId then
					v16 = state
				else
					v16 = dictionary.join(state, { userId = userId })
				end

				local v17 = nil

				if GetFFlagTextChatEnableUniverseChatTabs() and v16.channelNameOverride then
					v17 = v16.channelNameOverride
				elseif v16.textChannel then
					v17 = (v16.textChannel.Name == "RBXSystem" or GetFFlagTextChatEnableUniverseChatTabs() and not signal10(false))
						and "RBXGeneral"
						or v16.textChannel.Name
				end

				if v16.isVisibleInChatWindow then
					local v18 = signal3(false)

					local v19 = v17 and signal4(false)[v17] or {}

					if #v18 >= v.messageLimit then
						local v20 = v18[1]
						local v21 = v15 and v15[v20]

						if v21 then
							if not FFlagExpChatMessagesStoreKeepInByMessageId then
								if FFlagExpChatMessagesStoreUseProxy then
									result[v20] = nil
								else
									v2(function(p)
										return dictionary.removeKey(p, v20)
									end)
								end
							end

							if v21.userId then
								local function fn2(p)
									if not p then
										return nil
									end

									local filtered

									if FFlagExpChatMessagesStoreMemoryCleanup then
										filtered = list.filter(p, function(p2): boolean
											return p2 ~= v20
										end)
									else
										filtered = list.filter(p, function(p2): boolean
											return p2.messageId ~= v20
										end)
									end

									if #filtered ~= 0 then
										return filtered
									end

									local v22 = signal8(false)

									if v22[v21.userId] then
										local v23 = v22[v21.userId]

										v9(function(p2)
											return dictionary.removeKey(p2, v23)
										end)

										v8(function(p2)
											return dictionary.removeKey(p2, v21.userId)
										end)
									end

									return nil
								end

								updateMessagesBySenderId(v21.userId, fn2) -- inferred equivalent call
							end

							v5(function(p)
								return list.removeIndex(p, 1)
							end)

							if FFlagExpChatMessagesStoreMemoryCleanup then
								v14[v20] = nil
							end
						end
					end

					local v20 = v17 and #v19 >= v.messageLimit and v19[1]

					if v20 then
						v6(function(p)
							local v21 = p[v17] or {}
							local v22 = list.removeIndex(v21, 1)
							return dictionary.join(p, { [v17] = v22 })
						end)

						if v15 and v15[v20] then
							if FFlagExpChatMessagesStoreUseProxy then
								result[v20] = nil
							else
								v2(function(p)
									return dictionary.removeKey(p, v20)
								end)
							end
						end

						if FFlagExpChatMessagesStoreMemoryCleanup then
							v14[v20] = nil
						end
					end
				end

				writeByMessageId(v16.messageId, v16)

				if v16.userId then
					local function fn2(options)
						local v18 = options or {}

						local flag3 = false

						if FFlagExpChatMessagesStoreMemoryCleanup then
							for _, v19 in ipairs(v18) do
								if v19 == v16.messageId then
									flag3 = true
									break
								end
							end
						else
							for _, v19 in ipairs(v18) do
								if v19.messageId == v16.messageId then
									flag3 = true
									break
								end
							end
						end

						if flag3 then
							return v18
						end

						local v19

						if FFlagExpChatMessagesStoreMemoryCleanup then
							v19 = v16.messageId
						else
							v19 = v16
						end

						return list.append(v18, v19)
					end

					updateMessagesBySenderId(v16.userId, fn2) -- inferred equivalent call
				end

				local v18 = false

				if v16.isVisibleInChatWindow then
					v5(function(p)
						local v19 = insertWindowMessageIdInOrder(p, v16.messageId, v16.isHistorical)
						v18 = v18 or v19[#v19] ~= v16.messageId

						if not FFlagExpChatMessageHistoryExperiment then
							return v19
						end

						local v20 = capHistoricalPrefix(v19, v16)
						v18 = v18 or #v20 < #v19
						return v20
					end)

					if v17 then
						v6(function(p)
							local v19 = insertWindowMessageIdInOrder(p[v17] or {}, v16.messageId, v16.isHistorical)

							v18 = v18 or v19[#v19] ~= v16.messageId

							if FFlagExpChatMessageHistoryExperiment then
								v19 = capHistoricalPrefix(v19, v16)
							end

							return dictionary.join(p, { [v17] = v19 })
						end)
					end

					if FFlagExpChatEnableV2ChatWindow then
						local v19 = signal13(false)

						if v19 == nil or v17 == v19 then
							syncPoolForInsert(v16.messageId, v18) -- inferred equivalent call
						end
					end
				end
			end
		end

		maybeBatch(fn) -- inferred equivalent call
	end

	local v15 = {}

	local function getUserMessageCache(p: string)
		local v16 = tostring(p)

		if v15[v16] then
			return v15[v16]
		end

		v15[v16] = {}

		if not FFlagExpChatMessagesStoreMemoryCleanup then
			v15[v16].messages = createComputed(function(p2)
				return readMessagesBySenderIdReactive(p2)[v16] or {} -- inferred equivalent call
			end)
		end

		if FFlagExpChatMessagesStoreMemoryCleanup then
			v15[v16].bubbleMessages = createComputed(function(p2)
				local v17 = readMessagesBySenderIdReactive(p2)[v16] or {} -- inferred equivalent call
				local v18 = readByMessageIdReactive(p2) -- inferred equivalent call
				local v19 = getMutedUserIds(p2)
				local result2 = {}

				for _, v20 in ipairs(v17) do
					local v21 = v18[v20]

					if not v21 then
						continue
					end

					local v22

					if v21.userId then
						v22 = set.has(v19, v21.userId) or false
					else
						v22 = false
					end

					if not v21.isVisibleInBubbleChat or v22 then
						continue
					end

					table.insert(result2, v21)
				end

				return result2
			end)
		else
			v15[v16].bubbleMessages = createComputed(function(p2)
				local messages = v15[v16].messages(p2)
				local v17 = getMutedUserIds(p2)
				local messages2 = {}

				for _, message in ipairs(messages) do
					local v18

					if message.userId then
						v18 = set.has(v17, message.userId) or false
					else
						v18 = false
					end

					if not message.isVisibleInBubbleChat or v18 then
						continue
					end

					table.insert(messages2, message)
				end

				return messages2
			end)
		end

		if not FFlagExpChatMessagesStoreMemoryCleanup then
			v15[v16].lastMessage = createComputed(function(p2)
				local messages = v15[v16].messages(p2)

				if #messages > 0 then
					return messages[#messages]
				end

				return nil
			end)
		end

		return v15[v16]
	end

	local function getUserMessages(p: string)
		return getUserMessageCache(p).messages
	end

	local function getUserLastMessage(p: string)
		return getUserMessageCache(p).lastMessage
	end

	local function createMessagesArraySignal()
		return createComputed(function(p)
			local v16 = readByMessageIdReactive(p) -- inferred equivalent call

			if not v16 then
				return {}
			end

			local result2 = {}

			for _, v17 in v16 do
				table.insert(result2, v17)
			end

			return result2
		end)
	end

	local function addSystemMessage(p: string, channelNameOverride: string, metadata: string?, callback2, flag3: boolean?, textChannel)
		local text = sanitizeForRichText(p)

		if GetFFlagExpChatSyntheticSystemMessageRichText() then
			if not FFlagExpChatDictation then
				flag3 = nil
			end

			text = generateRichSystemMessageTextFormat(text, flag3, callback2)
		end

		local v16 = {
			userId = nil,
			prefixText = "",
			text = text,
			translation = nil,
			useTranslation = false,
			messageId = HttpService:GenerateGUID(false),
			timestamp = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000),
			status = Enum.TextChatMessageStatus.Success,
			isVisibleInChatWindow = true,
			isVisibleInBubbleChat = false,
			shouldOverrideBubbleChatSettings = false,
			textChannel = textChannel,
			bubbleChatMessageProperties = nil,
			chatWindowMessageProperties = nil,
			textChatMessageInstance = nil,
			partOrModel = nil,
			channelNameOverride = 0,
			metadata = 0
		}

		if textChannel ~= nil then
			channelNameOverride = nil
		end

		v16.channelNameOverride = channelNameOverride
		v16.metadata = metadata
		addMessage(v16) -- inferred equivalent call
	end

	local function formatPrefixForUniverseChatTabs(list2: string, p: string?, data)
		if not GetFFlagTextChatEnableUniverseChatTabs() or not p or #list2 == 0 then
			return list2
		end

		local v16

		if data.TextSource then
			v16 = computeNameColor(data.TextSource.Username)
		else
			v16 = computeNameColor(not Players.LocalPlayer and "" or Players.LocalPlayer.Name)
		end

		return `<font color="#{v16:ToHex()}">{list2}</font>`
	end

	local function handleIncomingOrOutgoingMessage(data, flag3: boolean, p: string?, isUniverseChat: boolean?, isHistorical: boolean?)
		local text, translation

		if FFlagEnableInExpChatRewrite then
			text, translation = getTextAndTranslation(data)
		else
			if getFFlagExpChatProtectedChatInternalAPIs() then
				text = data.TextInternal
			else
				text = data.Text
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				translation = data.TranslationInternal
			else
				translation = data.Translation
			end
		end

		if
			isWhiteSpaceOnly(text)
			and data.Status ~= Enum.TextChatMessageStatus.Floodchecked
			and data.Status ~= Enum.TextChatMessageStatus.MessageTooLong
		then
			return
		end

		local userId

		if data.TextSource then
			userId = tostring(data.TextSource.UserId)
		elseif FFlagExpChatFixLocalUserVerifiedBadge and flag3 and Players.LocalPlayer then
			userId = tostring(Players.LocalPlayer.UserId)
		end

		if not readByMessageId() then -- inferred equivalent call
			return
		end

		local v16 = signal6(false)
		local v17

		if userId == nil then
			v17 = true
		elseif v16 or FFlagExpChatPresetChatEnabled and (data.PresetId or "") ~= "" then
			v17 = data.Status == Enum.TextChatMessageStatus.Success or data.Status == Enum.TextChatMessageStatus.Sending
		else
			v17 = false
		end

		local v18

		if userId and getMutedUserIds(false) then
			v18 = set.has(getMutedUserIds(false), userId)
		else
			v18 = false
		end

		local isVisibleInChatWindow = v17 and not v18
		local isVisibleInBubbleChat = false
		local v19

		if FFlagExpChatUseChatConfigStore then
			v19 = GetChatConfigurationStore(false).getIsBubbleChatEnabled(false)
		else
			local store = ExpChatShared.context and ExpChatShared.context.store

			if store then
				v19 = store:getState().Messages.isBubbleChatEnabled
			else
				v19 = signal7(false)
			end
		end

		isVisibleInBubbleChat = v19
			and isVisibleInChatWindow
			and (not FFlagEnableInExpChatSummaryOnLua or userId ~= nil)
			and (data.Status == Enum.TextChatMessageStatus.Success or data.Status == Enum.TextChatMessageStatus.Sending)
			and true
			or false

		if
			FFlagExpChatDisableUniverseBubbleChat
			and GetFFlagTextChatEnableUniverseChatTabs()
			and isUniverseChat == true
			and not (FFlagExpChatGlobalTabDefault and isGlobalBubbleChatEnabled())
		then
			isVisibleInBubbleChat = false
		end

		if data.Status ~= Enum.TextChatMessageStatus.Success and data.Status ~= Enum.TextChatMessageStatus.Sending then
			isVisibleInBubbleChat = false
			isVisibleInChatWindow = false
		end

		if isHistorical then
			isVisibleInBubbleChat = false
		end

		if
			not isUniverseChat
			and p == nil
			and not shouldRenderTextChannelInDefaultWindow(data.TextChannel, getTextChannelDisplayMode())
		then
			isVisibleInChatWindow = false
		end

		local v20

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v20 = data.PrefixTextInternal
		else
			v20 = data.PrefixText
		end

		local v21 = {
			userId = userId,
			prefixText = formatPrefixForUniverseChatTabs(v20, p, data),
			text = text,
			translation = translation,
			useTranslation = getChatTranslationEnabled() and translation ~= nil,
			messageId = data.MessageId,
			status = data.Status,
			timestamp = data.Timestamp,
			shouldOverrideBubbleChatSettings = false,
			isVisibleInBubbleChat = isVisibleInBubbleChat,
			isVisibleInChatWindow = isVisibleInChatWindow,
			textChannel = data.TextChannel,
			bubbleChatMessageProperties = data.BubbleChatMessageProperties,
			chatWindowMessageProperties = data.ChatWindowMessageProperties,
			textChatMessageInstance = 0,
			partOrModel = 0,
			wasRewritten = 0,
			originalText = 0,
			isHistorical = 0,
			channelNameOverride = 0,
			chatActionType = 0,
			isUniverseChat = 0,
			presetId = 0,
			presetChatVersion = 0
		}
		local textChatMessageInstance

		if getFFlagExpChatTelemetryEventTrigger() then
			textChatMessageInstance = data
		end

		v21.textChatMessageInstance = textChatMessageInstance
		local partOrModel

		if data.TextSource then
			partOrModel = data.TextSource.Parent or nil
		end

		v21.partOrModel = partOrModel
		local wasRewritten

		if FFlagEnableInExpChatRewrite then
			wasRewritten = data.WasRewritten
		end

		v21.wasRewritten = wasRewritten
		local originalText

		if FFlagEnableInExpChatRewrite then
			originalText = data.OriginalText
		end

		v21.originalText = originalText
		v21.isHistorical = isHistorical
		v21.channelNameOverride = GetFFlagTextChatEnableUniverseChatTabs() and p or nil
		local chatActionType

		if FFlagEnableInExpChatSummaryOnLua then
			chatActionType = data.ChatActionType
		end

		v21.chatActionType = chatActionType
		v21.isUniverseChat = isUniverseChat
		local presetId

		if FFlagExpChatPresetChatEnabled then
			presetId = data.PresetId
		end

		v21.presetId = presetId
		local presetChatVersion

		if FFlagExpChatPresetChatEnabled then
			presetChatVersion = data.PresetChatVersion
		end

		v21.presetChatVersion = presetChatVersion
		local v22 = readByMessageId() -- inferred equivalent call
		local v23 = v22 and v22[v21.messageId] ~= nil

		if isHistorical and v23 then
			return
		end

		if FFlagExpChatMessageHistoryExperiment and isHistorical then
			ExpChatMessageHistoryExperimentation.logExposure(signal6(false))
		end

		if v21.isVisibleInChatWindow or v21.isVisibleInBubbleChat or v23 then
			addMessage(v21) -- inferred equivalent call
		end

		if ExpChatPresetChatEmojiEffectExperimentation.isExperimentEnabled then
			logPresetChatEmojiEffectExposure(v21)
		end
	end

	local function handleIncomingBubbleChatMessage(data)
		local v16 = {
			userId = data.bubbleChatMessageUserId,
			prefixText = "",
			text = data.message,
			translation = data.translation,
			useTranslation = getChatTranslationEnabled(),
			textChannel = nil,
			messageId = data.bubbleChatMessageId,
			status = Enum.TextChatMessageStatus.Success,
			timestamp = data.timestamp,
			partOrModel = data.partOrModel,
			shouldOverrideBubbleChatSettings = true,
			isVisibleInBubbleChat = true,
			isVisibleInChatWindow = false,
			bubbleChatMessageProperties = data.bubbleChatMessageProperties,
			chatWindowMessageProperties = nil
		}
		addMessage(v16) -- inferred equivalent call

		if ExpChatPresetChatEmojiEffectExperimentation.isExperimentEnabled then
			logPresetChatEmojiEffectExposure(v16)
		end
	end

	local function handleHiddenMessageReceived(textChatMessageInstance)
		local v16

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v16 = textChatMessageInstance.TextInternal
		else
			v16 = textChatMessageInstance.Text
		end

		local v17 = string.len(v16)

		local v18 = math.max(FIntExpChatRandomCharChangeLowerBound, -(v17 - 1))

		local v19 = math.random(v18, FIntExpChatRandomCharChangeUpperBound)
		local text = string.rep(Config.DOT_TEXT, v17 + v19)

		local v20 = {
			userId = nil,
			prefixText = Config.LOCK_EMOJI .. " :",
			text = text,
			textChannel = textChatMessageInstance.TextChannel,
			messageId = textChatMessageInstance.MessageId,
			status = textChatMessageInstance.Status,
			timestamp = textChatMessageInstance.Timestamp,
			isVisibleInBubbleChat = false,
			isVisibleInChatWindow = true,
			textChatMessageInstance = 0,
			isHiddenMessage = true
		}

		if not getFFlagExpChatTelemetryEventTrigger() then
			textChatMessageInstance = nil
		end

		v20.textChatMessageInstance = textChatMessageInstance
		addMessage(v20) -- inferred equivalent call
	end

	local function clearWindowMessages()
		local function doClearWindowMessages()
			forEachByMessageId(function(_, p)
				return dictionary.join(p, { isVisibleInChatWindow = false })
			end)

			v5(function(_)
				return {}
			end)

			v6(function(_)
				return {}
			end)

			if FFlagExpChatEnableV2ChatWindow then
				v11(1)
				total = 0
				total2 = 0
				local v16 = signal11(false)

				for _, v17 in ipairs(v16) do
					local v18 = v12[v17]

					if v18 then
						v18.setter(nil)
					end
				end
			end
		end

		maybeBatch(doClearWindowMessages) -- inferred equivalent call
	end

	local function rebuildMessageWithTranslation(data, useTranslation: boolean)
		local v16 = {
			prefixText = data.prefixText,
			text = data.text,
			translation = data.translation,
			useTranslation = useTranslation,
			messageId = data.messageId,
			status = data.status,
			timestamp = data.timestamp,
			bubbleChatReceivedAtMillis = 0,
			isVisibleInBubbleChat = 0,
			isVisibleInChatWindow = 0,
			partOrModel = 0,
			shouldOverrideBubbleChatSettings = 0,
			bubbleChatMessageProperties = 0,
			chatWindowMessageProperties = 0,
			textChatMessageInstance = 0,
			userId = 0,
			textChannel = 0,
			wasRewritten = 0,
			originalText = 0,
			chatActionType = 0,
			presetId = 0,
			presetChatVersion = 0,
			isHistorical = 0
		}
		local bubbleChatReceivedAtMillis

		if isBorderlessBubbleChatEnabled() then
			bubbleChatReceivedAtMillis = data.bubbleChatReceivedAtMillis
		end

		v16.bubbleChatReceivedAtMillis = bubbleChatReceivedAtMillis

		v16.isVisibleInBubbleChat = data.isVisibleInBubbleChat
		v16.isVisibleInChatWindow = data.isVisibleInChatWindow
		v16.partOrModel = data.partOrModel
		v16.shouldOverrideBubbleChatSettings = data.shouldOverrideBubbleChatSettings
		v16.bubbleChatMessageProperties = data.bubbleChatMessageProperties
		v16.chatWindowMessageProperties = data.chatWindowMessageProperties
		local textChatMessageInstance

		if getFFlagExpChatTelemetryEventTrigger() then
			textChatMessageInstance = data.textChatMessageInstance
		end

		v16.textChatMessageInstance = textChatMessageInstance

		v16.userId = data.userId
		v16.textChannel = data.textChannel
		local wasRewritten

		if FFlagEnableInExpChatRewrite then
			wasRewritten = data.wasRewritten
		end

		v16.wasRewritten = wasRewritten
		local originalText

		if FFlagEnableInExpChatRewrite then
			originalText = data.originalText
		end

		v16.originalText = originalText
		local chatActionType

		if FFlagEnableInExpChatSummaryOnLua then
			chatActionType = data.chatActionType
		end

		v16.chatActionType = chatActionType
		local presetId

		if FFlagExpChatPresetChatEnabled then
			presetId = data.presetId
		end

		v16.presetId = presetId
		local presetChatVersion

		if FFlagExpChatPresetChatEnabled then
			presetChatVersion = data.presetChatVersion
		end

		v16.presetChatVersion = presetChatVersion
		local isHistorical

		if FFlagExpChatRenderHistoricalMessages then
			isHistorical = data.isHistorical
		end

		v16.isHistorical = isHistorical
		return v16
	end

	local function handleLegacyBubbleCreated(data)
		local timestamp = data.timestamp
		local timestamp2

		if timestamp then
			timestamp2 = DateTime.fromUnixTimestampMillis(timestamp)
		else
			timestamp2 = DateTime.now()
		end

		addMessage({ -- inferred equivalent call
			userId = data.userId,
			prefixText = "",
			text = data.text,
			messageId = data.id,
			status = Enum.TextChatMessageStatus.Success,
			timestamp = timestamp2,
			partOrModel = data.adornee,
			shouldOverrideBubbleChatSettings = true,
			isVisibleInBubbleChat = true,
			isVisibleInChatWindow = false,
			translation = nil,
			useTranslation = false,
			textChannel = nil,
			bubbleChatMessageProperties = nil,
			chatWindowMessageProperties = nil
		})
	end

	updateNextMessageComponent = function(p: string)
		local v16 = signal11(false)

		if #v16 == 0 then
			return
		end

		local v17 = signal12(false)
		local v18 = v16[v17]

		if not v18 then
			v11(1)
			return
		end

		local v19 = v12[v18]

		if v19 then
			v19.setter(p)
		end

		local v20 = FFlagEnableInExpChatRewrite and 10 or 1
		local v21 = v13[v18]

		if FFlagExpChatRenderHistoricalMessages then
			if isHistoricalWindowMessage(p) then -- inferred equivalent call
				total2 += v20

				if v21 then
					v21.setter(total2 + -1000000)
				end
			else
				total += v20

				if v21 then
					v21.setter(total)
				end
			end
		else
			total += v20

			if v21 then
				v21.setter(total)
			end
		end

		v11(v17 % #v16 + 1)
	end

	repopulateMessageComponents = function()
		local function doRepopulate()
			local v16 = signal13(false)
			local v17

			if v16 then
				v17 = signal4(false)[v16] or {}
			else
				v17 = signal3(false)
			end

			v11(1)
			total = 0
			total2 = 0

			for _, v18 in ipairs(v17) do
				updateNextMessageComponent(v18)
			end

			local v18 = signal11(false)

			if #v17 < #v18 then
				for i = signal12(false), #v18 do
					local v19 = v12[v18[i]]

					if v19 then
						v19.setter(nil)
					end
				end
			end
		end

		maybeBatch(doRepopulate) -- inferred equivalent call
	end

	local getByMessageId

	if FFlagExpChatMessagesStoreUseProxy then
		getByMessageId = result
	else
		getByMessageId = signal
	end

	local getMessages

	if not FFlagExpChatMessagesStoreMemoryCleanup then
		getMessages = createComputed(function(p)
			local v16 = readByMessageIdReactive(p) -- inferred equivalent call

			if not v16 then
				return {}
			end

			local result2 = {}

			for _, v17 in v16 do
				table.insert(result2, v17)
			end

			return result2
		end)
	end

	local getMessagesBySenderId

	if FFlagExpChatMessagesStoreUseProxy then
		getMessagesBySenderId = v4
	else
		getMessagesBySenderId = signal2
	end

	local messagesStore = {}
	messagesStore.getByMessageId = getByMessageId
	messagesStore.getMessages = getMessages
	messagesStore.getMessagesBySenderId = getMessagesBySenderId
	messagesStore.getWindowMessagesInOrder = signal3
	messagesStore.getWindowMessagesInOrderByTabId = signal4
	messagesStore.getHistoricalWindowMessageCount = getHistoricalWindowMessageCount
	messagesStore.getMutedUserIds = getMutedUserIds
	messagesStore.getCanLocalUserChat = signal6
	messagesStore.getIsBubbleChatEnabled = signal7
	messagesStore.getMockUserIdToPartOrModel = signal8
	messagesStore.getPartOrModelToMockUserId = signal9

	function messagesStore.getMessage(p: string)
		if FFlagExpChatMessagesStoreUseProxy then
			return function(p2)
				return readByMessageIdReactive(p2)[p] -- inferred equivalent call
			end
		end

		if not v14[p] then
			v14[p] = createComputed(function(p2)
				local v16 = signal(p2)

				if v16 and v16[p] then
					return v16[p]
				end

				return nil
			end)
		end

		return v14[p]
	end

	if FFlagExpChatMessagesStoreMemoryCleanup then
		getUserMessages = nil
	end

	messagesStore.getUserMessages = getUserMessages

	function messagesStore.getUserBubbleMessages(p: string)
		return getUserMessageCache(p).bubbleMessages
	end

	if FFlagExpChatMessagesStoreMemoryCleanup then
		getUserLastMessage = nil
	end

	messagesStore.getUserLastMessage = getUserLastMessage

	function messagesStore.registerMessageComponent(p: string)
		if v12[p] then
			return v12[p].getter
		end

		local signal14, setter = createSignal(nil)
		v12[p] = { getter = signal14, setter = setter }

		local signal15, setter2 = createSignal(0)
		v13[p] = { getter = signal15, setter = setter2 }

		v10(function(p2)
			return list.append(p2, p)
		end)

		return v12[p].getter
	end

	function messagesStore.unregisterMessageComponent(p: string)
		local v16 = signal11(false)
		local v17 = nil

		for i, v18 in ipairs(v16) do
			if v18 == p then
				v17 = i
				break
			end
		end

		if v12[p] then
			v12[p] = nil
		end

		if v13[p] then
			v13[p] = nil
		end

		if v17 then
			local function doUnregister()
				v10(function(p2)
					return list.filter(p2, function(p3): boolean
						return p3 ~= p
					end)
				end)

				local v18 = signal11(false)
				local v19 = signal12(false)

				if #v18 == 0 then
					v11(1)
				elseif v17 < v19 then
					v11(v19 - 1)
				elseif #v18 < v19 then
					v11(1)
				end
			end

			maybeBatch(doUnregister) -- inferred equivalent call
		end
	end
	messagesStore.repopulateMessageComponents = repopulateMessageComponents

	function messagesStore.getMessageComponentSignal(p: string)
		local v16 = v12[p]
		return if v16 then v16.getter else nil
	end

	function messagesStore.getLayoutOrderSignal(p: string)
		local v16 = v13[p]
		return if v16 then v16.getter else nil
	end
	messagesStore.updateNextMessageComponent = updateNextMessageComponent
	messagesStore.getMessageComponentRingBuffer = signal11
	messagesStore.getNextMessageComponentPointer = signal12
	messagesStore.setActiveChannelFilter = setActiveChannelFilter
	messagesStore.getActiveChannelFilter = signal13

	messagesStore.setCanLocalUserChat = setCanLocalUserChat

	function messagesStore.muteUser(p: string)
		v7(function(p2)
			if p2 then
				return (set.add(p2, p))
			end

			return {}
		end)
	end

	function messagesStore.unmuteUser(p: string)
		v7(function(p2)
			if p2 then
				return (set.subtract(p2, p))
			end

			return {}
		end)
	end

	function messagesStore.handlePlayerRemoved(p: string)
		local v16 = tostring(p)

		local function doHandlePlayerRemoved()
			local v17 = v16

			if FFlagExpChatMessagesStoreUseProxy then
				v4[v17] = nil
			else
				v3(function(p2)
					return dictionary.removeKey(p2, v17)
				end)
			end

			if FFlagExpChatMessagesStoreMemoryCleanup then
				v15[v16] = nil
			end

			v7(function(p2)
				if not p2 then
					return {}
				end

				local v18 = not set.has(p2, v16)
				local v19

				if FFlagExpChatMessagesStoreUseProxy then
					v19 = v4
				else
					v19 = signal2(false)
				end

				if #(v19[v16] or {}) == 0 and v18 then
					return p2
				end

				local v20 = signal8(false)

				if v20[v16] then
					local v21 = v20[v16]

					v9(function(p3)
						return dictionary.removeKey(p3, v21)
					end)

					v8(function(p3)
						return dictionary.removeKey(p3, v16)
					end)
				end

				return set.subtract(p2, v16)
			end)
		end

		if FFlagExpChatMessagesStoreBatch then
			SignalsExperimental.batch(doHandlePlayerRemoved)
			return
		end

		if FFlagExpChatMessagesStoreUseProxy then
			v4[v16] = nil
		else
			v3(function(p2)
				return dictionary.removeKey(p2, v16)
			end)
		end

		if FFlagExpChatMessagesStoreMemoryCleanup then
			v15[v16] = nil
		end

		v7(function(p2)
			if not p2 then
				return {}
			end

			local v17 = not set.has(p2, v16)
			local v18

			if FFlagExpChatMessagesStoreUseProxy then
				v18 = v4
			else
				v18 = signal2(false)
			end

			if #(v18[v16] or {}) == 0 and v17 then
				return p2
			end

			local v19 = signal8(false)

			if v19[v16] then
				local v20 = v19[v16]

				v9(function(p3)
					return dictionary.removeKey(p3, v20)
				end)

				v8(function(p3)
					return dictionary.removeKey(p3, v16)
				end)
			end

			return set.subtract(p2, v16)
		end)
	end
	messagesStore.clearWindowMessages = clearWindowMessages

	function messagesStore.toggleGlobalTranslation(flag3: boolean)
		local function doToggleGlobalTranslation()
			forEachByMessageId(function(_, p)
				return rebuildMessageWithTranslation(p, flag3)
			end)
		end

		maybeBatch(doToggleGlobalTranslation) -- inferred equivalent call
	end

	function messagesStore.toggleMessageTranslation(useTranslation: boolean, p: string)
		local function fn(p2)
			return rebuildMessageWithTranslation(p2, useTranslation)
		end

		if FFlagExpChatMessagesStoreUseProxy then
			local v16 = result[p]

			local v17 = v16 and rebuildMessageWithTranslation(v16, useTranslation)

			if v17 then
				result[p] = v17
			end
		else
			v2(function(options)
				if not (options and options[p]) then
					return options or {}
				end

				local v16 = fn(options[p])

				if v16 then
					return dictionary.join(options, { [p] = v16 })
				end

				return options
			end)
		end
	end

	messagesStore.handleIncomingOrOutgoingMessage = handleIncomingOrOutgoingMessage
	messagesStore.batchWrites = batchWrites
	messagesStore.handleIncomingBubbleChatMessage = handleIncomingBubbleChatMessage
	messagesStore.handleLegacyBubbleCreated = handleLegacyBubbleCreated

	function messagesStore.handleLegacyBubbleTextUpdated(p: string, text: string)
		local function fn(p2) -- 1 equivalent call inferred from this helper
			return dictionary.join(p2, { text = text })
		end

		if FFlagExpChatMessagesStoreUseProxy then
			local v16 = result[p]

			local v17 = v16 and fn(v16) -- inferred equivalent call

			if v17 then
				result[p] = v17
			end
		else
			v2(function(options)
				if not (options and options[p]) then
					return options or {}
				end

				local v16 = fn(options[p])

				if v16 then
					return dictionary.join(options, { [p] = v16 })
				end

				return options
			end)
		end
	end
	messagesStore.handleHiddenMessageReceived = handleHiddenMessageReceived

	function messagesStore.handleHiddenMessagesCleared()
		if not FFlagExpChatClearHiddenMessagesPostAgeCheck then
			return
		end

		forEachByMessageId(function(_, p)
			if p and p.isHiddenMessage then
				return dictionary.join(p, { isVisibleInChatWindow = false })
			end

			return nil
		end)

		local function isNotHidden(p: string)
			local v16 = readByMessageId()[p] -- inferred equivalent call

			return v16 and not v16.isHiddenMessage
		end

		v5(function(p)
			return list.filter(p, isNotHidden)
		end)

		v6(function(p)
			return dictionary.map(p, function(p2)
				return list.filter(p2, isNotHidden)
			end)
		end)
	end
	messagesStore.addSystemMessage = addSystemMessage
	messagesStore.getChannelTabsConfigurationEnabled = signal10
	messagesStore.setChannelTabsConfigurationEnabled = setChannelTabsConfigurationEnabled
	return messagesStore
end

return createMessagesStore
