local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useCallback = React.useCallback
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local BidirectionalFlatList = require(AppChatParent.VirtualizedList).BidirectionalFlatList
local PendingShimmerBubble = require(script.Parent.PendingShimmerBubble)
local t1 = {
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
}
local t2 = {
	minTransparency = 0.5,
	maxTransparency = 0.9,
	itemList = t1,
	size = UDim2.new(1, 0, 1, 0)
}

local function PendingStateIndicator(t3: {[any]: any}) -- line: 113
	-- upvalues: Cryo (copy), t2 (copy), useStyle (copy), useCallback (copy), React (copy), PendingShimmerBubble (copy), BidirectionalFlatList (copy)
	local v14 = Cryo.Dictionary.join(t2, t3)
	local v15 = useStyle()
	local v16 = v14.style or v15
	local v17 = #v14.itemList
	local v18 = useCallback(function(p1) -- line: 119
		-- upvalues: v14 (copy), React (copy), PendingShimmerBubble (copy), Cryo (copy)
		local v20 = math.max(1, #v14.itemList)
		local v21 = v14.maxTransparency - (v14.maxTransparency - v14.minTransparency) * (p1.index - 1) / v20

		return React.createElement(PendingShimmerBubble, Cryo.Dictionary.join(p1.item, {
			backgroundTransparency = v21
		}))
	end, { v17 })

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = v16.Theme.BackgroundDefault.Color,
		Size = v14.size,
		Transparency = v16.Tokens.Color.None.Transparency,
		LayoutOrder = v14.layoutOrder
	}, {
		ShimmerMessageList = React.createElement(BidirectionalFlatList, {
			inverted = true,
			optimizeInvertedCanvasResize = true,
			data = v14.itemList,
			renderItem = v18,
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				Name = "ShimmerMessageList"
			},
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			keyExtractor = function(_, p3) -- line: 151
				return p3
			end
		})
	})
end

return memo(PendingStateIndicator)
