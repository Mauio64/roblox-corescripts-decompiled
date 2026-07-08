local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local FitFrameOnAxis = require(ParentParentParent.FitFrame).FitFrameOnAxis
local isCallable = require(ParentParent.Utility.isCallable)
local CarouselHeader = require(scriptParent.CarouselHeader)
local HorizontalCarousel = require(scriptParent.HorizontalCarousel)
local v10 = Roact.PureComponent:extend("FreeFlowCarousel")

v10.validateProps = t.strictInterface({
	identifier = t.optional(t.callback),
	headerText = t.optional(t.string),
	onSeeAll = t.optional(t.callback),
	itemList = t.array(t.any),
	renderItem = t.callback,
	itemSize = t.optional(t.Vector2),
	itemPadding = t.optional(t.number),
	carouselMargin = t.optional(t.number),
	innerPadding = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	loadNext = t.optional(t.callback),
	maxNumOfItemsVisible = t.optional(t.integer),
	viewabilityConfigCallbackPairs = t.optional(t.array(t.strictInterface({
		viewabilityConfig = t.strictInterface({
			minimumViewTime = t.optional(t.number),
			viewAreaCoveragePercentThreshold = t.optional(t.number),
			itemVisiblePercentThreshold = t.optional(t.number),
			waitForInteraction = t.optional(t.boolean)
		}),
		onViewableItemsChanged = isCallable
	})))
})
v10.defaultProps = {
	headerText = "",
	innerPadding = 12,
	itemPadding = 12,
	carouselMargin = 24
}

function v10.render(p1) -- line: 77
	-- upvalues: Roact (copy), FitFrameOnAxis (copy), CarouselHeader (copy), HorizontalCarousel (copy)
	local innerPadding = p1.props.innerPadding
	local carouselMargin = p1.props.carouselMargin

	return Roact.createElement(FitFrameOnAxis, {
		BackgroundTransparency = 1,
		axis = FitFrameOnAxis.Axis.Vertical,
		minimumSize = UDim2.fromScale(1, 0),
		LayoutOrder = p1.props.layoutOrder,
		contentPadding = UDim.new(0, innerPadding)
	}, {
		CarouselHeader = Roact.createElement(CarouselHeader, {
			layoutOrder = 1,
			headerText = p1.props.headerText,
			onSeeAll = p1.props.onSeeAll,
			carouselMargin = carouselMargin
		}),
		Carousel = Roact.createElement(HorizontalCarousel, {
			layoutOrder = 2,
			identifier = p1.props.identifier,
			itemList = p1.props.itemList,
			renderItem = p1.props.renderItem,
			itemSize = p1.props.itemSize,
			itemPadding = innerPadding,
			carouselMargin = carouselMargin,
			loadNext = p1.props.loadNext,
			maxNumOfItemsVisible = p1.props.maxNumOfItemsVisible,
			viewabilityConfigCallbackPairs = p1.props.viewabilityConfigCallbackPairs
		})
	})
end

return v10
