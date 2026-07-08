local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local ChatBubbleContainerAutomaticSize = require(script.Parent.Bubble.ChatBubbleContainerAutomaticSize)
local t1 = {
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

local function HiddenMessage(t2: {[any]: any}) -- line: 38
	-- upvalues: Cryo (copy), t1 (copy), Foundation (copy), React (copy), ChatBubbleContainerAutomaticSize (copy)
	local v9 = Cryo.Dictionary.union(t1, t2)
	local v10 = Foundation.Hooks.useTokens()

	return React.createElement(ChatBubbleContainerAutomaticSize, {
		isIncoming = v9.isIncoming,
		hasTail = v9.hasTail,
		isPending = v9.isPending,
		isUnfiltered = false,
		padding = {
			top = UDim.new(0, v10.Padding.Small),
			bottom = UDim.new(0, v10.Padding.Small),
			left = UDim.new(0, v10.Padding.Medium),
			right = UDim.new(0, v10.Padding.Medium)
		},
		LayoutOrder = v9.LayoutOrder,
		isRepliedTo = v9.isRepliedTo,
		isPressed = v9.isPressed,
		isLastMessageInMessageGroup = v9.isLastMessageInMessageGroup,
		[React.Change.AbsoluteSize] = v9[React.Change.AbsoluteSize]
	}, {
		IconContainer = React.createElement(Foundation.View, {
			tag = "row align-x-center align-y-center content-muted",
			Size = UDim2.fromOffset(180 - v10.Padding.Medium * 2, 40 - v10.Padding.Small * 2)
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
