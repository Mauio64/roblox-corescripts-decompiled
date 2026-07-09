local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local ChatBubbleEnum = require(script.Parent.ChatBubbleEnum)
local Foundation = require(Parent.Foundation)
local FoundationImage = Foundation.Image
local t1 = {
	layoutOrder = 0,
	padding = 0,
	alignment = Enum.HorizontalAlignment.Right,
	children = {},
	imageStyle = {
		Transparency = 0,
		Color3 = Color3.new(0, 0, 0)
	},
	onAbsoluteSizeChanged = function(_) -- line: 33
	end,
	position = UDim2.new(0, 0, 0, 0),
	setContentWidth = function(_: number) -- line: 36
	end,
	variant = ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE
}

function ChatBubbleGroupable(t2: {[any]: any}) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), ChatBubbleEnum (copy), React (copy), FoundationImage (copy), Foundation (copy)
	local v11 = Cryo.Dictionary.union(t1, t2)
	local v12 = if v11.alignment ~= Enum.HorizontalAlignment.Left then ChatBubbleEnum.GROUPED_OUTGOING_BUBBLES else ChatBubbleEnum.GROUPED_RECEIVED_BUBBLES
	local v13 = if v11.variant ~= ChatBubbleEnum.BUBBLE_VARIANTS.SINGLE then if v11.variant ~= ChatBubbleEnum.BUBBLE_VARIANTS.TOP then if v11.variant ~= ChatBubbleEnum.BUBBLE_VARIANTS.BOTTOM then v12.BUBBLE_MIDDLE else v12.BUBBLE_BOTTOM else v12.BUBBLE_TOP else ChatBubbleEnum.GROUPED_BUBBLE_SINGLE

	return React.createElement(FoundationImage, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Image = v13,
		ScaleType = Enum.ScaleType.Slice,
		slice = {
			center = ChatBubbleEnum.GROUPED_BUBBLE_SLICE_CENTER
		},
		imageStyle = v11.imageStyle,
		Position = v11.position,
		LayoutOrder = v11.layoutOrder,
		onAbsoluteSizeChanged = v11.onAbsoluteSizeChanged
	}, React.createElement(Foundation.View, {
		tag = "size-0 auto-xy",
		BackgroundTransparency = 1,
		padding = if typeof(v11.padding) ~= "table" then UDim2.fromOffset(v11.padding or 0, v11.padding or 0) else {
			top = v11.padding.top or UDim.new(0, 0),
			bottom = v11.padding.bottom or UDim.new(0, 0),
			left = v11.padding.left or UDim.new(0, 0),
			right = v11.padding.right or UDim.new(0, 0)
		}
	}, v11.children))
end

return React.memo(ChatBubbleGroupable)
