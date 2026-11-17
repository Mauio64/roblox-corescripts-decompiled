local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local ChatMessage = require(AppChat.Components.ChatConversation.ChatMessage)
local CustomMessageEntryContainer = require(AppChat.Components.ChatConversation.CustomMessageEntryContainer)
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local MessageListContext = require(script.Parent.MessageListContext)
local MessageModel = require(AppChat.Models.MessageModel)
local SystemMessage = require(AppChat.Components.ChatConversation.SystemMessage)
local SystemMessageContainer = require(AppChat.Components.ChatConversation.SystemMessageContainer)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local function isValidMessageAndSenderType(messageType: string?, senderType: string?): boolean -- 1 equivalent call inferred from this helper
	if senderType == MessageModel.SenderTypes.System then
		return messageType == EnumMessageTypes.System
	end

	if senderType == MessageModel.SenderTypes.User then
		return messageType == EnumMessageTypes.PlainText or messageType == EnumMessageTypes.Link
	end

	return messageType == EnumMessageTypes.Custom
end

local function MessageRow(p)
	local v = React.useContext(MessageListContext)
	assert(v ~= nil, "MessageRow must be rendered inside a MessageListContext provider")
	local item = p.item

	if not isValidMessageAndSenderType(item.messageType, item.senderType) then -- inferred equivalent call
		return React.createElement(SystemMessage, { Text = v.invalidMessageTypeText })
	end

	local debugElement

	if v.isDebugEnabled then
		debugElement = React.createElement("StringValue", { Value = tostring(item.messageId) })
	end

	if item.messageType == EnumMessageTypes.Custom then
		return React.createElement(CustomMessageEntryContainer, {
			openViewProfile = v.openViewProfile,
			customEntryType = item.customEntryType,
			conversationId = v.conversationId
		})
	end

	if item.messageType == EnumMessageTypes.System then
		local createElement = React.createElement
		local cards

		if GetFFlagEnableSocialCards() then
			cards = item.cards
		end

		local v2 = {
			cards = cards,
			text = item.content,
			parentWidth = v.width,
			sent = item.sent,
			showDateTime = item.showDateTime,
			messageId = item.messageId,
			senderTargetId = 0,
			conversationId = 0,
			debugElement = 0
		}
		local senderTargetId

		if GetFFlagEnableSocialCards() then
			senderTargetId = item.senderTargetId
		end

		v2.senderTargetId = senderTargetId
		v2.conversationId = v.conversationId

		v2.debugElement = debugElement
		return createElement(SystemMessageContainer, v2)
	else
		local join = Cryo.Dictionary.join
		local additionalProps = item.additionalProps or {}
		local onDetailsOpened

		if item.additionalProps ~= nil then
			onDetailsOpened = v.onDetailsOpened
		end

		local additionalProps2 = join(additionalProps, {
			onDetailsOpened = onDetailsOpened,
			openGameDetailsPage = v.openGameDetailsPage,
			openMomentsDeepLink = v.openMomentsDeepLink,
			shareLink = item.shareLink
		})

		return React.createElement(ChatMessage, {
			additionalProps = additionalProps2,
			content = item.content,
			debugElement = debugElement,
			failed = item.failed,
			filteredForReceivers = item.filteredForReceivers,
			isIncoming = item.isIncoming,
			isNewSender = item.isNewSender,
			isSending = item.isSending,
			isUnfiltered = item.moderationType == MessageModel.ModerationTypes.TrustedComms,
			isLastMessageInMessageGroup = item.isLastMessageInMessageGroup,
			isLastIncomingChatMessage = item.messageId == v.lastIncomingChatMessageId,
			messageDefaultNoticeText = v.messageDefaultNoticeText,
			conversationId = v.conversationId,
			messageId = item.messageId,
			messageModeratedNoticeText = v.messageModeratedNoticeText,
			messageHiddenNoticeText = v.messageHiddenNoticeText,
			messageType = item.messageType,
			moderated = item.moderated,
			openViewProfile = v.openViewProfile,
			parentWidth = v.width,
			readingMessagesIsEnabled = true,
			senderUserId = item.senderTargetId,
			sent = item.sent,
			showDateTime = item.showDateTime,
			showDisplayName = item.showDisplayName,
			shouldShowName = item.sender.shouldShowName,
			thumbnail = item.sender.thumbnail,
			wideMode = v.wideMode,
			unknownUserText = v.unknownUserText,
			viewProfileOnAvatarPressed = v.viewProfileOnAvatarPressed,
			closeKeyboard = v.closeKeyboard,
			inputBoxRef = v.inputBoxRef,
			repliesTo = item.repliesTo,
			visibility = item.visibility
		})
	end
end

return MessageRow
