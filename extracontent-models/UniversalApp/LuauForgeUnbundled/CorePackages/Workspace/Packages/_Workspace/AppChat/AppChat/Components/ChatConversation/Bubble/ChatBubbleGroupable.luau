local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ChatBubbleEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleEnum")
local getChatBubbleCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/getChatBubbleCornerRadii")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local image = Foundation.Image
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagAppChatNativeFoundationCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatNativeFoundationCornerRadii")

local v5 = {
	alignment = Enum.HorizontalAlignment.Right,
	children = {},
	imageStyle = { Color3 = Color3.new(0, 0, 0), Transparency = 0 },
	layoutOrder = 0,
	onAbsoluteSizeChanged = function(p2) end,
	padding = 0,
	position = UDim2.new(0, 0, 0, 0),
	setContentWidth = function(p2) end,
	variant = ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE
}

function LUAUFORGE_MODULE_GLOBALS_hvY_ChatBubbleGroupable(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v6 = union.alignment == Enum.HorizontalAlignment.Left
	local size_500 = useTokens().Size.Size_500

	local element = React.createElement(
		view,
		{ tag = "size-0 auto-xy", BackgroundTransparency = 1, padding = union.padding },
		union.children
	)

	if FFlagAppChatNativeFoundationCornerRadii then
		return React.createElement(view, {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = union.imageStyle,
			cornerRadius = getChatBubbleCornerRadii(union.variant, v6, size_500),
			Position = union.position,
			LayoutOrder = union.layoutOrder,
			onAbsoluteSizeChanged = union.onAbsoluteSizeChanged
		}, element)
	end

	local v7 = if v6 then ChatBubbleEnum.GROUPED_RECEIVED_BUBBLES else ChatBubbleEnum.GROUPED_OUTGOING_BUBBLES
	local v8

	if union.variant == ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE then
		v8 = ChatBubbleEnum.GROUPED_BUBBLE_SINGLE
	elseif union.variant == ChatBubbleEnum.BUBBLE_VARIANTS.TOP then
		v8 = v7.BUBBLE_TOP
	elseif union.variant == ChatBubbleEnum.BUBBLE_VARIANTS.BOTTOM then
		v8 = v7.BUBBLE_BOTTOM
	else
		v8 = v7.BUBBLE_MIDDLE
	end

	return React.createElement(image, {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Image = v8,
		ScaleType = Enum.ScaleType.Slice,
		slice = { center = ChatBubbleEnum.GROUPED_BUBBLE_SLICE_CENTER },
		imageStyle = union.imageStyle,
		Position = union.position,
		LayoutOrder = union.layoutOrder,
		onAbsoluteSizeChanged = union.onAbsoluteSizeChanged
	}, element)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hvY_ChatBubbleGroupable)
