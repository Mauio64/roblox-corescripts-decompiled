local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local ChatBubbleContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleContainer")

local v5 = {
	isIncoming = false,
	hasTail = false,
	isPending = false,
	isRepliedTo = false,
	isPressed = false,
	innerPadding = 0,
	maxWidth = 180,
	LayoutOrder = 0,
	isLastMessageInMessageGroup = false
}

local function HiddenMessage(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = Foundation.Hooks.useTokens()

	return React.createElement(ChatBubbleContainer, {
		isIncoming = union.isIncoming,
		hasTail = union.hasTail,
		isPending = union.isPending,
		isUnfiltered = false,
		padding = {
			top = UDim.new(0, v6.Padding.Small),
			bottom = UDim.new(0, v6.Padding.Small),
			left = UDim.new(0, v6.Padding.Medium),
			right = UDim.new(0, v6.Padding.Medium)
		},
		LayoutOrder = union.LayoutOrder,
		isRepliedTo = union.isRepliedTo,
		isPressed = union.isPressed,
		isLastMessageInMessageGroup = union.isLastMessageInMessageGroup,
		bubbleRef = union.bubbleRef,
		[React.Change.AbsoluteSize] = union[React.Change.AbsoluteSize]
	}, {
		IconContainer = React.createElement(Foundation.View, {
			tag = "row align-x-center align-y-center content-muted",
			Size = UDim2.fromOffset(180 - v6.Padding.Medium * 2, 40 - v6.Padding.Small * 2)
		}, {
			LockIcon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.LockClosed,
				size = Foundation.Enums.IconSize.Medium,
				variant = Foundation.Enums.IconVariant.Regular
			})
		})
	})
end

return HiddenMessage
