local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useCallback = React.useCallback

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local VirtualizedList = require(parent.VirtualizedList)
local BidirectionalFlatList = VirtualizedList.BidirectionalFlatList

local PendingShimmerBubble = require(script.Parent.PendingShimmerBubble)

local v = {
	itemList = {
		{
			addBottomPadding = true,
			heightFactor = 1,
			isIncoming = true,
			showAvatarCircle = true,
			widthPercentage = 0.5
		},
		{
			addBottomPadding = false,
			heightFactor = 1,
			isIncoming = true,
			showAvatarCircle = false,
			widthPercentage = 0.2
		},
		{
			addBottomPadding = true,
			heightFactor = 1,
			isIncoming = false,
			showAvatarCircle = false,
			widthPercentage = 0.6
		},
		{
			addBottomPadding = true,
			heightFactor = 2,
			isIncoming = true,
			showAvatarCircle = true,
			widthPercentage = 0.75
		},
		{
			addBottomPadding = true,
			heightFactor = 2,
			isIncoming = false,
			showAvatarCircle = false,
			widthPercentage = 0.75
		},
		{
			addBottomPadding = false,
			heightFactor = 1,
			isIncoming = false,
			showAvatarCircle = false,
			widthPercentage = 0.75
		},
		{
			addBottomPadding = false,
			heightFactor = 1,
			isIncoming = false,
			showAvatarCircle = false,
			widthPercentage = 0.2
		},
		{
			addBottomPadding = true,
			heightFactor = 2,
			isIncoming = true,
			showAvatarCircle = true,
			widthPercentage = 0.7
		},
		{
			addBottomPadding = false,
			heightFactor = 1,
			isIncoming = true,
			showAvatarCircle = false,
			widthPercentage = 0.5
		},
		{
			addTopPadding = true,
			addBottomPadding = false,
			heightFactor = 1,
			isIncoming = true,
			showAvatarCircle = false,
			widthPercentage = 0.2
		}
	},
	size = UDim2.new(1, 0, 1, 0),
	minTransparency = 0.5,
	maxTransparency = 0.9
}

local function PendingStateIndicator(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local style = joined.style or v2
	local renderItem = useCallback(function(p2)
		local v3 = math.max(1, #joined.itemList)

		local backgroundTransparency = joined.maxTransparency - (joined.maxTransparency - joined.minTransparency) * (p2.index - 1) / v3
		return React.createElement(
			PendingShimmerBubble,
			Cryo.Dictionary.join(p2.item, { backgroundTransparency = backgroundTransparency })
		)
	end, { #joined.itemList })

	return React.createElement("Frame", {
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = joined.size,
		Transparency = style.Tokens.Color.None.Transparency,
		LayoutOrder = joined.layoutOrder
	}, {
		ShimmerMessageList = React.createElement(BidirectionalFlatList, {
			data = joined.itemList,
			renderItem = renderItem,
			inverted = true,
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				Name = "ShimmerMessageList"
			},
			contentContainerStyle = { BackgroundTransparency = 1 },
			keyExtractor = function(_, p2)
				return p2
			end,
			optimizeInvertedCanvasResize = true
		})
	})
end

return memo(PendingStateIndicator)
