require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useCallback = React.useCallback

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle
local bidirectionalFlatList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/VirtualizedList").BidirectionalFlatList

local PendingShimmerBubble = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PendingState/PendingShimmerBubble")

local v5 = {
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

local function PendingStateIndicator(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()
	local style = joined.style or v6
	local v8 = useCallback(function(p3)
		local v9 = math.max(1, #joined.itemList)

		local v10 = joined.maxTransparency - (joined.maxTransparency - joined.minTransparency) * (p3.index - 1) / v9
		return React.createElement(
			PendingShimmerBubble,
			Cryo.Dictionary.join(p3.item, { backgroundTransparency = v10 })
		)
	end, { #joined.itemList })

	return React.createElement("Frame", {
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		Size = joined.size,
		Transparency = style.Tokens.Color.None.Transparency,
		LayoutOrder = joined.layoutOrder
	}, {
		ShimmerMessageList = React.createElement(bidirectionalFlatList, {
			data = joined.itemList,
			renderItem = v8,
			inverted = true,
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				Name = "ShimmerMessageList"
			},
			contentContainerStyle = { BackgroundTransparency = 1 },
			keyExtractor = function(p3, p4)
				return p4
			end,
			optimizeInvertedCanvasResize = true
		})
	})
end

return memo(PendingStateIndicator)
