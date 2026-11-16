local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local VirtualizedList = require(parent.VirtualizedList)
local FlatList = VirtualizedList.FlatList

local View = Foundation.View
require(InExperienceShop.Types)

local function ShopHomePageView(props)
	return React.createElement(
		View,
		{
			tag = "fill size-full-0 padding-x-xlarge",
			testId = "ShopHomePageView",
			LayoutOrder = props.LayoutOrder,
			Visible = props.Visible
		},
		{
			List = React.createElement(FlatList, {
				renderItem = props.renderItem,
				data = props.data,
				keyExtractor = props.keyExtractor,
				onScroll = props.onScroll,
				windowSize = 3,
				initialNumToRender = 2,
				maxToRenderPerBatch = 1,
				updateCellsBatchingPeriod = 100,
				contentContainerStyle = { BackgroundTransparency = 1 },
				style = { BackgroundTransparency = 1, ScrollBarThickness = 0 }
			})
		}
	)
end

return ShopHomePageView
