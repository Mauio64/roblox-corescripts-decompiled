local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local FriendsChatMessageList = require(script.Parent.FriendsChatMessageList)
require(script.Parent.useConversationHeaderFadeLayout)
local useConversationMessagePool = require(script.Parent.useConversationMessagePool)

local function FriendsChatChatWindowSlot(props)
	local fadeLayout = props.fadeLayout

	local scrollViewChildrenSignal = useConversationMessagePool({
		conversationId = props.conversationId,
		shouldReadMessages = props.hasConversationId,
		chatWindowSettings = props.hostChatWindowSettings,
		textTransparency = props.textTransparency,
		isSpatialUIEnabled = props.isSpatialUIEnabled
	})

	return React.createElement(FriendsChatMessageList, {
		layoutOrder = props.layoutOrder,
		conversationId = props.conversationId,
		scrollViewChildrenSignal = scrollViewChildrenSignal,
		contentTopPadding = fadeLayout.contentTopPadding,
		messageFadeSequence = fadeLayout.messageFadeSequence,
		onCanvasPositionChanged = fadeLayout.onMessageCanvasPositionChanged,
		onViewportAbsoluteSizeChanged = fadeLayout.onMessageViewportAbsoluteSizeChanged,
		chatWindowSettings = props.chatWindowSettings,
		transparencyValue = props.transparencyValue,
		textTransparency = props.textTransparency,
		isSpatialUIEnabled = props.isSpatialUIEnabled,
		isChannelBarVisible = props.isChannelBarVisible,
		scrollToTopOnReset = props.shouldOpenToOsaSystemMessage,
		onHovered = props.onHovered,
		onUnhovered = props.onUnhovered,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = props.onAbsolutePositionChanged
	})
end

return FriendsChatChatWindowSlot
