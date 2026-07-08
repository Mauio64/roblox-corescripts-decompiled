local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local FlatList = require(InExperienceShopParent.VirtualizedList).FlatList
local View = Foundation.View

require(InExperienceShop.Types)

local function ShopHomePageView(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), FlatList (copy)
	return React.createElement(View, {
		tag = "fill size-full-0 padding-x-xlarge",
		testId = "ShopHomePageView",
		LayoutOrder = t1.LayoutOrder,
		Visible = t1.Visible
	}, {
		List = React.createElement(FlatList, {
			windowSize = 3,
			initialNumToRender = 2,
			maxToRenderPerBatch = 1,
			updateCellsBatchingPeriod = 100,
			renderItem = t1.renderItem,
			data = t1.data,
			keyExtractor = t1.keyExtractor,
			onScroll = t1.onScroll,
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0
			}
		})
	})
end

return ShopHomePageView
