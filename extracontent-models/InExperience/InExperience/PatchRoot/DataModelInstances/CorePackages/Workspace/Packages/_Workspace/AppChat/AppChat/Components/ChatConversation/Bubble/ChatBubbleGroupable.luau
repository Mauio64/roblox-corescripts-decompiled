local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local getChatBubbleCornerRadii = require(script.Parent.getChatBubbleCornerRadii)
local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatNativeFoundationCornerRadii = require(AppChat.Flags.FFlagAppChatNativeFoundationCornerRadii)

local v = {
	alignment = Enum.HorizontalAlignment.Right,
	children = {},
	imageStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 0 },
	layoutOrder = 0,
	onAbsoluteSizeChanged = function(_) end,
	padding = 0,
	position = UDim2.new(0, 0, 0, 0),
	setContentWidth = function(_: number) end,
	variant = ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE
}

function ChatBubbleGroupable(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = union.alignment == Enum.HorizontalAlignment.Left
	local size_500 = useTokens().Size.Size_500

	local element = React.createElement(
		View,
		{ tag = "size-0 auto-xy", BackgroundTransparency = 1, padding = union.padding },
		union.children
	)

	if FFlagAppChatNativeFoundationCornerRadii then
		return React.createElement(View, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = union.imageStyle,
			cornerRadius = getChatBubbleCornerRadii(union.variant, v2, size_500),
			Position = union.position,
			LayoutOrder = union.layoutOrder,
			onAbsoluteSizeChanged = union.onAbsoluteSizeChanged
		}, element)
	end

	local v3

	if v2 then
		v3 = ChatBubbleEnum.GROUPED_RECEIVED_BUBBLES
	else
		v3 = ChatBubbleEnum.GROUPED_OUTGOING_BUBBLES
	end

	local image

	if union.variant == ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE then
		image = ChatBubbleEnum.GROUPED_BUBBLE_SINGLE
	elseif union.variant == ChatBubbleEnum.BUBBLE_VARIANTS.TOP then
		image = v3.BUBBLE_TOP
	elseif union.variant == ChatBubbleEnum.BUBBLE_VARIANTS.BOTTOM then
		image = v3.BUBBLE_BOTTOM
	else
		image = v3.BUBBLE_MIDDLE
	end

	return React.createElement(Image, {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Image = image,
		ScaleType = Enum.ScaleType.Slice,
		slice = { center = ChatBubbleEnum.GROUPED_BUBBLE_SLICE_CENTER },
		imageStyle = union.imageStyle,
		Position = union.position,
		LayoutOrder = union.layoutOrder,
		onAbsoluteSizeChanged = union.onAbsoluteSizeChanged
	}, element)
end

return React.memo(ChatBubbleGroupable)
