local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local ChatMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatMessage")
local CustomMessageEntryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/CustomMessageEntryContainer")
local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")
local MessageListContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/MessageListV2/MessageListContext")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local SystemMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SystemMessage")
local SystemMessageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SystemMessageContainer")

local getFFlagEnableSocialCards = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnableSocialCards

local function isValidMessageAndSenderType(p2, p3): boolean
	if p3 == MessageModel.SenderTypes.System then
		return p2 == EnumMessageTypes.System
	end

	if p3 == MessageModel.SenderTypes.User then
		return p2 == EnumMessageTypes.PlainText or p2 == EnumMessageTypes.Link
	end

	return p2 == EnumMessageTypes.Custom
end

local function MessageRow(p2)
	local v5 = React.useContext(MessageListContext)
	assert(v5 ~= nil, "MessageRow must be rendered inside a MessageListContext provider")
	local item = p2.item

	local messageType = item.messageType
	local senderType = item.senderType
	local v6

	if senderType == MessageModel.SenderTypes.System then
		v6 = messageType == EnumMessageTypes.System
	elseif senderType == MessageModel.SenderTypes.User then
		v6 = messageType == EnumMessageTypes.PlainText or messageType == EnumMessageTypes.Link
	else
		v6 = messageType == EnumMessageTypes.Custom
	end

	if not v6 then
		return React.createElement(SystemMessage, { Text = v5.invalidMessageTypeText })
	end

	local v7

	if v5.isDebugEnabled then
		v7 = React.createElement("StringValue", { Value = tostring(item.messageId) })
	end

	if item.messageType == EnumMessageTypes.Custom then
		return React.createElement(CustomMessageEntryContainer, {
			openViewProfile = v5.openViewProfile,
			customEntryType = item.customEntryType,
			conversationId = v5.conversationId
		})
	end

	if item.messageType == EnumMessageTypes.System then
		local createElement = React.createElement
		local v10 = if getFFlagEnableSocialCards() then item.cards else nil
		local v9 = {
			cards = v10,
			text = item.content,
			parentWidth = v5.width,
			sent = item.sent,
			showDateTime = item.showDateTime,
			messageId = item.messageId,
			senderTargetId = 0,
			conversationId = 0,
			debugElement = 0
		}
		local v11 = if getFFlagEnableSocialCards() then item.senderTargetId else nil
		v9.senderTargetId = v11
		v9.conversationId = v5.conversationId

		v9.debugElement = v7
		return createElement(SystemMessageContainer, v9)
	else
		local join = Cryo.Dictionary.join
		local additionalProps = item.additionalProps or {}
		local v9 = if item.additionalProps ~= nil then v5.onDetailsOpened else nil
		local v10 = join(additionalProps, {
			onDetailsOpened = v9,
			openGameDetailsPage = v5.openGameDetailsPage,
			openMomentsDeepLink = v5.openMomentsDeepLink,
			shareLink = item.shareLink
		})

		return React.createElement(ChatMessage, {
			additionalProps = v10,
			content = item.content,
			debugElement = v7,
			failed = item.failed,
			filteredForReceivers = item.filteredForReceivers,
			isIncoming = item.isIncoming,
			isNewSender = item.isNewSender,
			isSending = item.isSending,
			isUnfiltered = item.moderationType == MessageModel.ModerationTypes.TrustedComms,
			isLastMessageInMessageGroup = item.isLastMessageInMessageGroup,
			isLastIncomingChatMessage = item.messageId == v5.lastIncomingChatMessageId,
			messageDefaultNoticeText = v5.messageDefaultNoticeText,
			conversationId = v5.conversationId,
			messageId = item.messageId,
			messageModeratedNoticeText = v5.messageModeratedNoticeText,
			messageHiddenNoticeText = v5.messageHiddenNoticeText,
			messageType = item.messageType,
			moderated = item.moderated,
			openViewProfile = v5.openViewProfile,
			parentWidth = v5.width,
			readingMessagesIsEnabled = true,
			senderUserId = item.senderTargetId,
			sent = item.sent,
			showDateTime = item.showDateTime,
			showDisplayName = item.showDisplayName,
			shouldShowName = item.sender.shouldShowName,
			thumbnail = item.sender.thumbnail,
			wideMode = v5.wideMode,
			unknownUserText = v5.unknownUserText,
			viewProfileOnAvatarPressed = v5.viewProfileOnAvatarPressed,
			closeKeyboard = v5.closeKeyboard,
			inputBoxRef = v5.inputBoxRef,
			repliesTo = item.repliesTo,
			visibility = item.visibility
		})
	end
end

return MessageRow
