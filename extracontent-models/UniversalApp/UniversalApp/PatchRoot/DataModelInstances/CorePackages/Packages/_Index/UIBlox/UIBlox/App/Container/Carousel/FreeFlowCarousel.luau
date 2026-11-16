local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local FitFrame = require(parent3.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis
local isCallable = require(parent2.Utility.isCallable)

local CarouselHeader = require(parent.CarouselHeader)
local HorizontalCarousel = require(parent.HorizontalCarousel)

local extended = Roact.PureComponent:extend("FreeFlowCarousel")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	headerText = "",
	innerPadding = 12,
	itemPadding = 12,
	carouselMargin = 24
}

function extended.render(p)
	local innerPadding = p.props.innerPadding
	local carouselMargin = p.props.carouselMargin

	return Roact.createElement(FitFrameOnAxis, {
		axis = FitFrameOnAxis.Axis.Vertical,
		minimumSize = UDim2.fromScale(1, 0),
		LayoutOrder = p.props.layoutOrder,
		contentPadding = UDim.new(0, innerPadding),
		BackgroundTransparency = 1
	}, {
		CarouselHeader = Roact.createElement(CarouselHeader, {
			headerText = p.props.headerText,
			onSeeAll = p.props.onSeeAll,
			carouselMargin = carouselMargin,
			layoutOrder = 1
		}),
		Carousel = Roact.createElement(HorizontalCarousel, {
			identifier = p.props.identifier,
			itemList = p.props.itemList,
			renderItem = p.props.renderItem,
			itemSize = p.props.itemSize,
			itemPadding = innerPadding,
			carouselMargin = carouselMargin,
			layoutOrder = 2,
			loadNext = p.props.loadNext,
			maxNumOfItemsVisible = p.props.maxNumOfItemsVisible,
			viewabilityConfigCallbackPairs = p.props.viewabilityConfigCallbackPairs
		})
	})
end

return extended
