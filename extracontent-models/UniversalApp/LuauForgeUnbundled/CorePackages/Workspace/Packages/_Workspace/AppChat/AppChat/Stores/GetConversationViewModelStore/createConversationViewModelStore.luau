local LocalizationService = game:GetService("LocalizationService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")
local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local shouldShowOSAForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowOSAForConversation")
local shouldShowU13ChatOptInForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowU13ChatOptInForConversation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore/createConversationStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageStore/createConversationMessageStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageListStore/createConversationMessageListStore")
local getUnixTimestampMillis = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getUnixTimestampMillis")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/MessageData/Types")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppLocales").Localization

local FFlagAppChatDerivedConversationLatestActivity = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDerivedConversationLatestActivity")

local messageType = Enums.MessageType
local messageVisibility = Enums.MessageVisibility

local function getFirstCardAltText(list)
	if type(list) ~= "table" or type(list[1]) ~= "table" then
		return nil
	end

	if type(list[1].alt_text) == "string" then
		return list[1].alt_text
	end

	return nil
end

local function getContentFirstLine(value)
	if type(value) ~= "string" then
		return ""
	end

	local parts = value:split("\n")
	return parts and parts[1] or ""
end

local function getHiddenMessageText()
	return localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
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

local function getLatestUnixSeconds(p2, p3)
	local v5 = getUnixTimestampMillis(p2.lastUpdated)

	local v6 = if p3 ~= nil then getUnixTimestampMillis(p3.created_at) else nil

	if v6 == nil or v5 ~= nil and not (v5 < v6) then
		v6 = v5
	end

	if v6 == nil then
		return nil
	end

	return v6 / 1000
end

local function isNewerPreviewThanServer(p2, p3): boolean
	local v5 = getUnixTimestampMillis(p2.lastUpdated)
	local v6 = getUnixTimestampMillis(p3.created_at)
	return v6 ~= nil and (v5 == nil or v5 <= v6)
end

local function getSubtitle(conversation, data)
	if data == nil then
		local previewContent = conversation.previewContent

		if type(previewContent) ~= "string" then
			return ""
		end

		local parts = previewContent:split("\n")
		return parts and parts[1] or ""
	else
		local v5

		if data.visibility == messageVisibility.Hidden then
			v5 = localization.new(LocalizationService.RobloxLocaleId):Format("Feature.Chat.Label.MessageNotAvailable")
		else
			v5 = data.preview_content or data.content_to_display or data.content
		end

		if v5 == nil and data.type == messageType.System then
			local cards = data.cards

			if
				type(cards) == "table"
				and type(cards[1]) == "table"
				and type(cards[1].alt_text) == "string"
			then
				v5 = cards[1].alt_text
			else
				v5 = nil
			end
		end

		if type(v5) ~= "string" then
			return ""
		end

		local parts = v5:split("\n")
		return parts and parts[1] or ""
	end
end

local function getTitle(p2)
	return getConversationTitle(p2) or ""
end

local function getLocatorTitle(p2)
	return p2.title or getConversationTitle(p2) or ""
end

local function getCachedGetter(p2, p3, p4, p5)
	local computeds = p2[p3]

	if computeds then
		local v5 = computeds[p4]

		if v5 ~= nil then
			return v5
		end
	else
		computeds = {}
		p2[p3] = computeds
	end

	local computed = Signals.createComputed(p5)
	computeds[p4] = computed
	return computed
end

local function createConversationViewModelStore(p2, p3, p4)
	local v5 = {}

	local function getTitleGetter(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)

			if conversation == nil then
				return nil
			end

			return getConversationTitle(conversation) or ""
		end

		local v7 = v6[p5]

		if v7 then
			local title = v7.title

			if title ~= nil then
				return title
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.title = computed
		return computed
	end

	local function getNewestPreviewableMessageGetter(p5)
		local v6 = v5
		local function fn(p6)
			for k, v7 in p4.getOrderedIds(p5, p6) do
				local message = p3.getMessage(v7, p6)

				if message ~= nil and message.is_previewable == true then
					return message
				end
			end

			return nil
		end

		local v7 = v6[p5]

		if v7 then
			local newestPreviewableMessage = v7.newestPreviewableMessage

			if newestPreviewableMessage ~= nil then
				return newestPreviewableMessage
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.newestPreviewableMessage = computed
		return computed
	end

	local function getSubtitleGetter(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)

			if conversation == nil then
				return ""
			end

			if FFlagAppChatDerivedConversationLatestActivity then
				local v7 = p5
				local v8 = v5
				local function fn2(p7)
					for k, v9 in p4.getOrderedIds(v7, p7) do
						local message = p3.getMessage(v9, p7)

						if message ~= nil and message.is_previewable == true then
							return message
						end
					end

					return nil
				end

				local v9 = v8[v7]
				local v10

				if v9 then
					v10 = v9.newestPreviewableMessage

					if v10 == nil then
						v10 = Signals.createComputed(fn2)
						v9.newestPreviewableMessage = v10
					end
				else
					v9 = {}
					v8[v7] = v9

					v10 = Signals.createComputed(fn2)
					v9.newestPreviewableMessage = v10
				end

				local v11 = v10(p6)

				if v11 ~= nil then
					local v12 = getUnixTimestampMillis(conversation.lastUpdated)
					local v13 = getUnixTimestampMillis(v11.created_at)
					local v14 = not (v13 == nil) and (v12 == nil or v12 <= v13)

					if v14 then
						return getSubtitle(conversation, v11)
					end
				end
			end

			local v7

			if conversation.previewMessageId ~= nil then
				v7 = p3.getMessage(conversation.previewMessageId, p6)
			end

			return getSubtitle(conversation, v7)
		end

		local v7 = v6[p5]

		if v7 then
			local subtitle = v7.subtitle

			if subtitle ~= nil then
				return subtitle
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.subtitle = computed
		return computed
	end

	local function getIsSubtitlePending(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)

			if conversation == nil then
				return false
			end

			return (useIsUserPending(conversation))
		end

		local v7 = v6[p5]

		if v7 then
			local isSubtitlePending = v7.isSubtitlePending

			if isSubtitlePending ~= nil then
				return isSubtitlePending
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.isSubtitlePending = computed
		return computed
	end

	local function getHasUnreadMessages(p5)
		local v6 = v5
		local function fn(p6): boolean
			local conversation = p2.getConversation(p5, p6)
			return conversation ~= nil and conversation.hasUnreadMessages == true
		end

		local v7 = v6[p5]

		if v7 then
			local hasUnreadMessages = v7.hasUnreadMessages

			if hasUnreadMessages ~= nil then
				return hasUnreadMessages
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.hasUnreadMessages = computed
		return computed
	end

	local function getHasGroupUp(p5)
		local v6 = v5
		local function fn(p6): boolean
			local conversation = p2.getConversation(p5, p6)
			return conversation ~= nil and conversation.hasGroupUp == true
		end

		local v7 = v6[p5]

		if v7 then
			local hasGroupUp = v7.hasGroupUp

			if hasGroupUp ~= nil then
				return hasGroupUp
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.hasGroupUp = computed
		return computed
	end

	local function getShouldShowOSA(p5)
		local v6 = v5
		local function fn(p6): boolean
			local conversation = p2.getConversation(p5, p6)
			return conversation ~= nil and shouldShowOSAForConversation(conversation) == true
		end

		local v7 = v6[p5]

		if v7 then
			local shouldShowOSA = v7.shouldShowOSA

			if shouldShowOSA ~= nil then
				return shouldShowOSA
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.shouldShowOSA = computed
		return computed
	end

	local function getShouldShowU13ChatOptIn(p5)
		local v6 = v5
		local function fn(p6): boolean
			local conversation = p2.getConversation(p5, p6)
			return conversation ~= nil and shouldShowU13ChatOptInForConversation(conversation) == true
		end

		local v7 = v6[p5]

		if v7 then
			local shouldShowU13ChatOptIn = v7.shouldShowU13ChatOptIn

			if shouldShowU13ChatOptIn ~= nil then
				return shouldShowU13ChatOptIn
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.shouldShowU13ChatOptIn = computed
		return computed
	end

	local function getConversationType(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)

			if conversation == nil then
				return nil
			end

			return conversation.conversationType
		end

		local v7 = v6[p5]

		if v7 then
			local conversationType = v7.conversationType

			if conversationType ~= nil then
				return conversationType
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.conversationType = computed
		return computed
	end

	local function getUnixTimeGetter(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)

			if FFlagAppChatDerivedConversationLatestActivity then
				if conversation == nil then
					return nil
				end

				local v7 = p5
				local v8 = v5
				local function fn2(p7)
					for k, v9 in p4.getOrderedIds(v7, p7) do
						local message = p3.getMessage(v9, p7)

						if message ~= nil and message.is_previewable == true then
							return message
						end
					end

					return nil
				end

				local v9 = v8[v7]
				local v10

				if v9 then
					v10 = v9.newestPreviewableMessage

					if v10 == nil then
						v10 = Signals.createComputed(fn2)
						v9.newestPreviewableMessage = v10
					end
				else
					v9 = {}
					v8[v7] = v9

					v10 = Signals.createComputed(fn2)
					v9.newestPreviewableMessage = v10
				end

				local v11 = v10(p6)
				local v12 = getUnixTimestampMillis(conversation.lastUpdated)

				local v13 = if v11 ~= nil then getUnixTimestampMillis(v11.created_at) else nil

				if v13 == nil or v12 ~= nil and not (v12 < v13) then
					v13 = v12
				end

				if v13 == nil then
					return nil
				end

				return v13 / 1000
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

		local v7 = v6[p5]

		if v7 then
			local unixTime = v7.unixTime

			if unixTime ~= nil then
				return unixTime
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.unixTime = computed
		return computed
	end

	local function getTestId(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)

			if conversation == nil then
				return nil
			end

			return DomLocators.chatLandingConversationEntry(conversation.title or getConversationTitle(conversation) or "")
		end

		local v7 = v6[p5]

		if v7 then
			local testId = v7.testId

			if testId ~= nil then
				return testId
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.testId = computed
		return computed
	end

	local function getLocatorTitleGetter(p5)
		local v6 = v5
		local function fn(p6)
			local conversation = p2.getConversation(p5, p6)
			local title

			if conversation == nil then
				return title
			end

			title = conversation.title

			if title then
				return title
			end

			return getConversationTitle(conversation) or ""
		end

		local v7 = v6[p5]

		if v7 then
			local locatorTitle = v7.locatorTitle

			if locatorTitle ~= nil then
				return locatorTitle
			end
		else
			v7 = {}
			v6[p5] = v7
		end

		local computed = Signals.createComputed(fn)
		v7.locatorTitle = computed
		return computed
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
