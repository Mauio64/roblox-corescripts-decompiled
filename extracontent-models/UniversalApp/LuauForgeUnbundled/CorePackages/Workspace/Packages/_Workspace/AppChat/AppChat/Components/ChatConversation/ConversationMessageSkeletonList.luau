local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")

local v5 = {
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.5,
		addBottomPadding = true
	},
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = false,
		widthPercentage = 0.2
	},
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
	{
		heightFactor = 1,
		isIncoming = false,
		showAvatarCircle = false,
		widthPercentage = 0.4
	},
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = true,
		widthPercentage = 0.7,
		addBottomPadding = true
	},
	{
		heightFactor = 1,
		isIncoming = true,
		showAvatarCircle = false,
		widthPercentage = 0.5
	}
}

local v6 = { size = UDim2.fromScale(1, 1), itemList = v5 }

local function renderSkeletonRow(props, p2, p3, k)
	local v7 = props.heightFactor * p2.Size.Size_500 + p2.Size.Size_400
	local size_900 = p2.Size.Size_900
	local v8 = if props.addBottomPadding then p2.Size.Size_600 else p2.Size.Size_100

	local createElement = React.createElement
	local v10 = {
		testId = "ConversationMessageSkeletonRow",
		LayoutOrder = k,
		tag = {
			["row align-y-bottom gap-small size-full-0 auto-y"] = true,
			["align-x-left"] = props.isIncoming,
			["align-x-right"] = not props.isIncoming
		},
		padding = 0
	}

	local v11 = {
		left = UDim.new(0, p3.left),
		right = UDim.new(0, p3.right),
		bottom = UDim.new(0, v8),
		top = 0
	}
	local v12 = if props.addTopPadding then UDim.new(0, p2.Size.Size_600) else nil
	v11.top = v12
	v10.padding = v11

	local v14 = if props.isIncoming and props.showAvatarCircle then React.createElement(skeleton, {
		LayoutOrder = 1,
		radius = radius.Circle,
		Size = UDim2.fromOffset(size_900, size_900)
	}) else nil
	return createElement(view, v10, {
		Avatar = v14,
		Bubble = React.createElement(skeleton, {
			LayoutOrder = 2,
			radius = radius.Medium,
			Size = UDim2.new(props.widthPercentage, 0, 0, v7)
		})
	})
end

local function ConversationMessageSkeletonList(p2)
	local union = Cryo.Dictionary.union(v6, p2)
	local v7 = useTokens()
	local v8 = useChatPagePadding()

	local v9 = {}

	for k, v10 in union.itemList or v5 do
		v9["SkeletonRow" .. k] = renderSkeletonRow(v10, v7, v8, k)
	end

	return React.createElement(view, {
		testId = "ConversationMessageSkeletonList",
		Size = union.size,
		LayoutOrder = union.layoutOrder,
		tag = "size-full clip",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}
	}, v9)
end

return memo(ConversationMessageSkeletonList)
