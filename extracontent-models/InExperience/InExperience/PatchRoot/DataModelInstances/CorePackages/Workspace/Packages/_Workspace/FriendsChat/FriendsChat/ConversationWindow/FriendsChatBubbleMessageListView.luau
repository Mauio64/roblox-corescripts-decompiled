local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local MessageList = require(parent.ChatUIPrimitives.MessageList)

local function FriendsChatBubbleMessageListView(props)
	local element = React.createElement(MessageList, props.messageListProps)

	local createElement = React.createElement
	local v = {
		Name = "FriendsChatWindowSlot",
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		ZIndex = 1,
		[React.Change.AbsoluteSize] = props.onSlotAbsoluteSizeChanged,
		[React.Change.AbsolutePosition] = props.onSlotAbsolutePositionChanged,
		[React.Event.MouseEnter] = props.onHovered,
		[React.Event.MouseLeave] = props.onUnhovered
	}
	local v2 = {
		flex = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
		padding = React.createElement("UIPadding", {
			PaddingTop = props.topInset:map(function(p: number)
				return UDim.new(0, p)
			end)
		}),
		messageMask = 0
	}

	local createElement2 = React.createElement
	local onMaskAbsoluteSizeChangedsByAbsoluteSize = {
		Name = "FriendsChatMessageMask",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		GroupTransparency = props.textTransparency,
		Visible = props.messagesVisible,
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = props.onMaskAbsoluteSizeChanged,
		ref = props.maskRef
	}
	local v3 = {
		fade = React.createElement("UIGradient", { Rotation = 90, Transparency = props.topFade }),
		messageList = 0
	}
	local messageList

	if props.isReady then
		messageList = React.createElement(React.Fragment, nil, { [props.conversationId] = element })
	end

	v3.messageList = messageList
	v2.messageMask = createElement2("CanvasGroup", onMaskAbsoluteSizeChangedsByAbsoluteSize, v3)
	return createElement("Frame", v, v2)
end

return FriendsChatBubbleMessageListView
