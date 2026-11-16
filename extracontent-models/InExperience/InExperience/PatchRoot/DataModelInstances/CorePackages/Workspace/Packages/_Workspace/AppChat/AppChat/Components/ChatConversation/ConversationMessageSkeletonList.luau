local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)

local itemList = {
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.5,
		addBottomPadding = true
	},
	{ heightFactor = 1, isIncoming = true, showAvatarCircle = false, widthPercentage = 0.2 },
	{
		heightFactor = 1,
		isIncoming = false,
		showAvatarCircle = false,
		widthPercentage = 0.6,
		addBottomPadding = true
	},
	{
		heightFactor = 2,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.75,
		addBottomPadding = true
	},
	{
		heightFactor = 2,
		isIncoming = false,
		showAvatarCircle = false,
		widthPercentage = 0.75,
		addBottomPadding = true
	},
	{ heightFactor = 1, isIncoming = false, showAvatarCircle = false, widthPercentage = 0.4 },
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.7,
		addBottomPadding = true
	},
	{ heightFactor = 1, isIncoming = true, showAvatarCircle = false, widthPercentage = 0.5 }
}

local v = { size = UDim2.fromScale(1, 1), itemList = itemList }

local function renderSkeletonRow(props, p, p2, k: number)
	local v2 = props.heightFactor * p.Size.Size_500 + p.Size.Size_400
	local size_900 = p.Size.Size_900
	local v3

	if props.addBottomPadding then
		v3 = p.Size.Size_600
	else
		v3 = p.Size.Size_100
	end

	local createElement = React.createElement
	local v4 = {
		testId = "ConversationMessageSkeletonRow",
		LayoutOrder = k,
		tag = {
			["row align-y-bottom gap-small size-full-0 auto-y"] = true,
			["align-x-left"] = props.isIncoming,
			["align-x-right"] = not props.isIncoming
		},
		padding = 0
	}

	local padding = {
		left = UDim.new(0, p2.left),
		right = UDim.new(0, p2.right),
		bottom = UDim.new(0, v3),
		top = 0
	}
	local top

	if props.addTopPadding then
		top = UDim.new(0, p.Size.Size_600)
	end

	padding.top = top
	v4.padding = padding
	local avatar

	if props.isIncoming and props.showAvatarCircle then
		avatar = React.createElement(Skeleton, {
			LayoutOrder = 1,
			radius = Radius.Circle,
			Size = UDim2.fromOffset(size_900, size_900)
		})
	end

	return createElement(View, v4, {
		Avatar = avatar,
		Bubble = React.createElement(Skeleton, {
			LayoutOrder = 2,
			radius = Radius.Medium,
			Size = UDim2.new(props.widthPercentage, 0, 0, v2)
		})
	})
end

local function ConversationMessageSkeletonList(p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useTokens()
	local v3 = useChatPagePadding()

	local v4 = {}

	for k, v5 in union.itemList or itemList do
		v4["SkeletonRow" .. k] = renderSkeletonRow(v5, v2, v3, k)
	end

	return React.createElement(View, {
		testId = "ConversationMessageSkeletonList",
		Size = union.size,
		LayoutOrder = union.layoutOrder,
		tag = "size-full clip",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}
	}, v4)
end

return memo(ConversationMessageSkeletonList)
