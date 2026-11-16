local LocalizationService = game:GetService("LocalizationService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)
local DomLocators = require(AppChat.Utils.DomLocators)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)
require(AppChat.Stores.GetConversationStore.createConversationStore)

require(AppChat.Stores.GetConversationMessageStore.createConversationMessageStore)

require(AppChat.Stores.GetConversationMessageListStore.createConversationMessageListStore)
local getPreciseUnixTimestamp = require(AppChat.Utils.getPreciseUnixTimestamp)
local Enums = require(AppChat.MessageData.Enums)
require(AppChat.MessageData.Types)
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local FFlagAppChatDerivedConversationLatestActivity = require(AppChat.Flags.FFlagAppChatDerivedConversationLatestActivity)

local MessageType = Enums.MessageType
local MessageVisibility = Enums.MessageVisibility

local function getFirstCardAltText(list)
	if type(list) ~= "table" or type(list[1]) ~= "table" then
		return nil
	end

	if type(list[1].alt_text) == "string" then
		return list[1].alt_text
	end

	return nil
end

local function getContentFirstLine(value: string?) -- 2 equivalent calls inferred from this helper
	if type(value) ~= "string" then
		return ""
	end

	local parts = value:split("\n")
	return parts and parts[1] or ""
end

local function getHiddenMessageText() -- 1 equivalent call inferred from this helper
	return Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
end

local function getUnixTime(value)
	if value == nil then
		return nil
	end

	if typeof(value) == "DateTime" then
		return value.UnixTimestamp
	end

	if type(value) == "table" and value.GetUnixTimestamp ~= nil then
		return value:GetUnixTimestamp()
	end

	return nil
end

local function getLatestUnixTime(conversation, p) -- 1 equivalent call inferred from this helper
	local preciseUnixTimestamp = getPreciseUnixTimestamp(conversation.lastUpdated)
	local v

	if p ~= nil then
		v = getPreciseUnixTimestamp(p.created_at)
	end

	if v == nil or preciseUnixTimestamp ~= nil and not (preciseUnixTimestamp < v) then
		return preciseUnixTimestamp
	end

	return v
end

local function isNewerPreviewThanServer(conversation, p): boolean -- 1 equivalent call inferred from this helper
	local preciseUnixTimestamp = getPreciseUnixTimestamp(conversation.lastUpdated)
	local preciseUnixTimestamp2 = getPreciseUnixTimestamp(p.created_at)
	return preciseUnixTimestamp2 ~= nil
		and (preciseUnixTimestamp == nil or preciseUnixTimestamp <= preciseUnixTimestamp2)
end

local function getSubtitle(conversation, data)
	if data == nil then
		return getContentFirstLine(conversation.previewContent) -- inferred equivalent call
	else
		local v

		if data.visibility == MessageVisibility.Hidden then
			v = getHiddenMessageText() -- inferred equivalent call
		else
			v = data.preview_content or data.content_to_display or data.content
		end

		if v == nil and data.type == MessageType.System then
			local cards = data.cards

			if type(cards) == "table" and type(cards[1]) == "table" and type(cards[1].alt_text) == "string" then
				v = cards[1].alt_text
			else
				v = nil
			end
		end

		return getContentFirstLine(v) -- inferred equivalent call
	end
end

local function getTitle(p) -- 3 equivalent calls inferred from this helper
	return getConversationTitle(p) or ""
end

local function getLocatorTitle(conversation) -- 1 equivalent call inferred from this helper
	return conversation.title or getTitle(conversation) -- inferred equivalent call
end

local function getCachedGetter(p, p2: string, p3: string, callback)
	local computeds = p[p2]

	if computeds then
		local v = computeds[p3]

		if v ~= nil then
			return v
		end
	else
		computeds = {}
		p[p2] = computeds
	end

	local computed = Signals.createComputed(callback)
	computeds[p3] = computed
	return computed
end

local function createConversationViewModelStore(p, p2, p3)
	local v = {}

	local function getTitleGetter(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)

			if conversation == nil then
				return nil
			end

			return getTitle(conversation) -- inferred equivalent call
		end

		local v3 = v2[p4]

		if v3 then
			local title = v3.title

			if title ~= nil then
				return title
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local title = Signals.createComputed(fn)
		v3.title = title
		return title
	end

	local function getNewestPreviewableMessageGetter(p4: string)
		local v2 = v
		local function fn(p5)
			for _, v3 in p3.getOrderedIds(p4, p5) do
				local message = p2.getMessage(v3, p5)

				if message ~= nil and message.is_previewable == true then
					return message
				end
			end

			return nil
		end

		local v3 = v2[p4]

		if v3 then
			local newestPreviewableMessage = v3.newestPreviewableMessage

			if newestPreviewableMessage ~= nil then
				return newestPreviewableMessage
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local newestPreviewableMessage = Signals.createComputed(fn)
		v3.newestPreviewableMessage = newestPreviewableMessage
		return newestPreviewableMessage
	end

	local function getSubtitleGetter(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)

			if conversation == nil then
				return ""
			end

			if FFlagAppChatDerivedConversationLatestActivity then
				local v3 = p4
				local v4 = v
				local function fn2(p6)
					for _, v5 in p3.getOrderedIds(v3, p6) do
						local message = p2.getMessage(v5, p6)

						if message ~= nil and message.is_previewable == true then
							return message
						end
					end

					return nil
				end

				local v5 = v4[v3]
				local newestPreviewableMessage

				if v5 then
					newestPreviewableMessage = v5.newestPreviewableMessage

					if newestPreviewableMessage == nil then
						newestPreviewableMessage = Signals.createComputed(fn2)
						v5.newestPreviewableMessage = newestPreviewableMessage
					end
				else
					v5 = {}
					v4[v3] = v5

					newestPreviewableMessage = Signals.createComputed(fn2)
					v5.newestPreviewableMessage = newestPreviewableMessage
				end

				local v6 = newestPreviewableMessage(p5)

				if v6 ~= nil and isNewerPreviewThanServer(conversation, v6) then -- inferred equivalent call
					return (getSubtitle(conversation, v6))
				end
			end

			local v3

			if conversation.previewMessageId ~= nil then
				v3 = p2.getMessage(conversation.previewMessageId, p5)
			end

			return (getSubtitle(conversation, v3))
		end

		local v3 = v2[p4]

		if v3 then
			local subtitle = v3.subtitle

			if subtitle ~= nil then
				return subtitle
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local subtitle = Signals.createComputed(fn)
		v3.subtitle = subtitle
		return subtitle
	end

	local function getIsSubtitlePending(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)
			return conversation ~= nil and useIsUserPending(conversation)
		end

		local v3 = v2[p4]

		if v3 then
			local isSubtitlePending = v3.isSubtitlePending

			if isSubtitlePending ~= nil then
				return isSubtitlePending
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local isSubtitlePending = Signals.createComputed(fn)
		v3.isSubtitlePending = isSubtitlePending
		return isSubtitlePending
	end

	local function getHasUnreadMessages(p4: string)
		local v2 = v
		local function fn(p5): boolean
			local conversation = p.getConversation(p4, p5)
			return conversation ~= nil and conversation.hasUnreadMessages == true
		end

		local v3 = v2[p4]

		if v3 then
			local hasUnreadMessages = v3.hasUnreadMessages

			if hasUnreadMessages ~= nil then
				return hasUnreadMessages
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local hasUnreadMessages = Signals.createComputed(fn)
		v3.hasUnreadMessages = hasUnreadMessages
		return hasUnreadMessages
	end

	local function getHasGroupUp(p4: string)
		local v2 = v
		local function fn(p5): boolean
			local conversation = p.getConversation(p4, p5)
			return conversation ~= nil and conversation.hasGroupUp == true
		end

		local v3 = v2[p4]

		if v3 then
			local hasGroupUp = v3.hasGroupUp

			if hasGroupUp ~= nil then
				return hasGroupUp
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local hasGroupUp = Signals.createComputed(fn)
		v3.hasGroupUp = hasGroupUp
		return hasGroupUp
	end

	local function getShouldShowOSA(p4: string)
		local v2 = v
		local function fn(p5): boolean
			local conversation = p.getConversation(p4, p5)
			return conversation ~= nil and shouldShowOSAForConversation(conversation) == true
		end

		local v3 = v2[p4]

		if v3 then
			local shouldShowOSA = v3.shouldShowOSA

			if shouldShowOSA ~= nil then
				return shouldShowOSA
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local shouldShowOSA = Signals.createComputed(fn)
		v3.shouldShowOSA = shouldShowOSA
		return shouldShowOSA
	end

	local function getShouldShowU13ChatOptIn(p4: string)
		local v2 = v
		local function fn(p5): boolean
			local conversation = p.getConversation(p4, p5)
			return conversation ~= nil and shouldShowU13ChatOptInForConversation(conversation) == true
		end

		local v3 = v2[p4]

		if v3 then
			local shouldShowU13ChatOptIn = v3.shouldShowU13ChatOptIn

			if shouldShowU13ChatOptIn ~= nil then
				return shouldShowU13ChatOptIn
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local shouldShowU13ChatOptIn = Signals.createComputed(fn)
		v3.shouldShowU13ChatOptIn = shouldShowU13ChatOptIn
		return shouldShowU13ChatOptIn
	end

	local function getConversationType(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)

			if conversation == nil then
				return nil
			end

			return conversation.conversationType
		end

		local v3 = v2[p4]

		if v3 then
			local conversationType = v3.conversationType

			if conversationType ~= nil then
				return conversationType
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local conversationType = Signals.createComputed(fn)
		v3.conversationType = conversationType
		return conversationType
	end

	local function getUnixTimeGetter(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)

			if FFlagAppChatDerivedConversationLatestActivity then
				if conversation == nil then
					return nil
				end

				local v3 = p4
				local v4 = v
				local function fn2(p6)
					for _, v5 in p3.getOrderedIds(v3, p6) do
						local message = p2.getMessage(v5, p6)

						if message ~= nil and message.is_previewable == true then
							return message
						end
					end

					return nil
				end

				local v5 = v4[v3]
				local newestPreviewableMessage

				if v5 then
					newestPreviewableMessage = v5.newestPreviewableMessage

					if newestPreviewableMessage == nil then
						newestPreviewableMessage = Signals.createComputed(fn2)
						v5.newestPreviewableMessage = newestPreviewableMessage
					end
				else
					v5 = {}
					v4[v3] = v5

					newestPreviewableMessage = Signals.createComputed(fn2)
					v5.newestPreviewableMessage = newestPreviewableMessage
				end

				return getLatestUnixTime(conversation, newestPreviewableMessage(p5)) -- inferred equivalent call
			else
				if conversation == nil then
					return nil
				end

				local lastUpdated = conversation.lastUpdated

				if lastUpdated == nil then
					return nil
				end

				if typeof(lastUpdated) == "DateTime" then
					return lastUpdated.UnixTimestamp
				end

				if type(lastUpdated) == "table" and lastUpdated.GetUnixTimestamp ~= nil then
					return (lastUpdated:GetUnixTimestamp())
				end

				return nil
			end
		end

		local v3 = v2[p4]

		if v3 then
			local unixTime = v3.unixTime

			if unixTime ~= nil then
				return unixTime
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local unixTime = Signals.createComputed(fn)
		v3.unixTime = unixTime
		return unixTime
	end

	local function getTestId(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)

			if conversation == nil then
				return nil
			end

			return DomLocators.chatLandingConversationEntry(getLocatorTitle(conversation)) -- inferred equivalent call
		end

		local v3 = v2[p4]

		if v3 then
			local testId = v3.testId

			if testId ~= nil then
				return testId
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local testId = Signals.createComputed(fn)
		v3.testId = testId
		return testId
	end

	local function getLocatorTitleGetter(p4: string)
		local v2 = v
		local function fn(p5)
			local conversation = p.getConversation(p4, p5)
			local title

			if conversation == nil then
				return title
			end

			title = conversation.title

			if title then
				return title
			end

			return getTitle(conversation) -- inferred equivalent call
		end

		local v3 = v2[p4]

		if v3 then
			local locatorTitle = v3.locatorTitle

			if locatorTitle ~= nil then
				return locatorTitle
			end
		else
			v3 = {}
			v2[p4] = v3
		end

		local locatorTitle = Signals.createComputed(fn)
		v3.locatorTitle = locatorTitle
		return locatorTitle
	end

	return {
		getTitle = getTitleGetter,
		getSubtitle = getSubtitleGetter,
		getIsSubtitlePending = getIsSubtitlePending,
		getHasUnreadMessages = getHasUnreadMessages,
		getHasGroupUp = getHasGroupUp,
		getShouldShowOSA = getShouldShowOSA,
		getShouldShowU13ChatOptIn = getShouldShowU13ChatOptIn,
		getConversationType = getConversationType,
		getUnixTime = getUnixTimeGetter,
		getTestId = getTestId,
		getLocatorTitle = getLocatorTitleGetter
	}
end

return createConversationViewModelStore
