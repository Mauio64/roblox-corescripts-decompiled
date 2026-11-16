local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)

local ChatBubbleContainer = require(script.Parent.Bubble.ChatBubbleContainer)

local v = {
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

local function HiddenMessage(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = Foundation.Hooks.useTokens()

	return React.createElement(ChatBubbleContainer, {
		isIncoming = union.isIncoming,
		hasTail = union.hasTail,
		isPending = union.isPending,
		isUnfiltered = false,
		padding = {
			top = UDim.new(0, v2.Padding.Small),
			bottom = UDim.new(0, v2.Padding.Small),
			left = UDim.new(0, v2.Padding.Medium),
			right = UDim.new(0, v2.Padding.Medium)
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
			Size = UDim2.fromOffset(180 - v2.Padding.Medium * 2, 40 - v2.Padding.Small * 2)
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
