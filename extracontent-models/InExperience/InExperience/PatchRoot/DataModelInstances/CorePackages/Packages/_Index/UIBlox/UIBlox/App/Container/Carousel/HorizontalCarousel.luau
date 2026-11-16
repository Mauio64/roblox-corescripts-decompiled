local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)

local Images = require(parent2.ImageSet.Images)

local ScrollButton = require(parent.ScrollButton)

local isCallable = require(parent3.Utility.isCallable)

local VirtualizedList = require(parent4.VirtualizedList)
local BidirectionalFlatList = VirtualizedList.BidirectionalFlatList

local Promise = require(parent4.Promise)
local LuauPolyfill = require(parent4.LuauPolyfill)

local iconsactionscycleLeft = Images["icons/actions/cycleLeft"]
local iconsactionscycleRight = Images["icons/actions/cycleRight"]

local extended = Roact.PureComponent:extend("HorizontalCarousel")

extended.validateProps = t.strictInterface({
	itemList = t.array(t.any),
	renderItem = t.callback,
	identifier = t.optional(t.callback),
	itemSize = t.optional(t.Vector2),
	itemPadding = t.optional(t.number),
	carouselMargin = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	loadNext = t.optional(t.callback),
	loadPrevious = t.optional(t.callback),
	animateScrolling = t.optional(t.boolean),
	maxNumOfItemsVisible = t.optional(t.integer),
	onContentSizeChange = t.optional(t.callback),
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

extended.defaultProps = { itemSize = Vector2.new(1, 1), itemPadding = 12, maxNumOfItemsVisible = 0 }

local function updateScrollState(p: number?, maxNumOfItemsVisible: number, numOfItems: number?, _: number?)
	if p == nil then
		return {}
	end

	if numOfItems == nil or numOfItems == 0 then
		return { showLeftButton = false, showRightButton = false }
	end

	local showLeftButton = true
	local showRightButton = true

	if p <= 1 then
		p = 1
		showLeftButton = false
	elseif numOfItems < p then
		p = numOfItems
		showRightButton = false
	end

	if numOfItems < p + maxNumOfItemsVisible then
		showRightButton = false
	end

	return {
		index = p,
		showLeftButton = showLeftButton,
		showRightButton = showRightButton,
		numOfItems = numOfItems
	}
end

function extended.getDerivedStateFromProps(p, data)
	local count = #p.itemList

	if data.numOfItems == count then
		return nil
	end

	return updateScrollState(data.index, data.maxNumOfItemsVisible, count)
end

function extended:init()
	self.frameRef = Roact.createRef()
	self.listRef = Roact.createRef()

	local v = { anchorIndex = 1 }

	self:setState({
		index = 1,
		hovering = false,
		showLeftButton = false,
		showRightButton = false,
		maxNumOfItemsVisible = self.props.maxNumOfItemsVisible,
		numOfItems = 0
	})

	function self.onMouseEnter(_, p)
		if p.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState(function(p2)
				local anchorIndex = v.anchorIndex
				return LuauPolyfill.Object.assign(
					updateScrollState(anchorIndex, p2.maxNumOfItemsVisible, p2.numOfItems),
					{ hovering = true }
				)
			end)
		end
	end

	function self.onMouseLeave(_, p)
		if p.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({ hovering = false })
		end
	end

	function self.onResize(p)
		local x = p.AbsoluteSize.X
		self:setState(function(_, p2)
			return {
				maxNumOfItemsVisible = math.floor(x / (p2.itemSize.X + p2.itemPadding))
			}
		end)
	end

	function self.onScrollUpdate(p)
		local v2 = self.props.itemSize.X + self.props.itemPadding
		v = {
			anchorIndex = math.floor((p.CanvasPosition.X > 0 and p.CanvasPosition.X or 0) / v2) + 1,
			animationActive = false
		}
	end

	function self.scrollLeft()
		if v.animationActive then
			return
		end

		self:setState(function(p, p2)
			local v2 = v.anchorIndex - p.maxNumOfItemsVisible

			if self.listRef then
				self.listRef.current:scrollToIndex({
					animated = true,
					index = v2 > 1 and v2 or 1,
					viewOffset = p2.itemSize.X + p2.itemPadding
				})
			end

			return updateScrollState(v2, p.maxNumOfItemsVisible, p.numOfItems)
		end)
	end

	function self.scrollRight()
		if v.animationActive then
			return
		end

		self:setState(function(p, p2)
			local v2 = v.anchorIndex + p.maxNumOfItemsVisible

			if self.listRef then
				self.listRef.current:scrollToIndex({
					animated = true,
					index = v2,
					viewOffset = p2.itemSize.X + p2.itemPadding
				})
			end

			return updateScrollState(v2, p.maxNumOfItemsVisible, p.numOfItems)
		end)
	end

	function self.proxyKeyExtractor(p, p2)
		local props = self.props

		if props.identifier then
			return (props.identifier(p, p2))
		end

		return nil
	end

	function self.proxyRenderItem(p)
		return self.props.renderItem(p.item)
	end

	function self.getItemLayout(list, p)
		local props = self.props
		local length = props.itemSize.X + (props.itemPadding or 0)
		local offset = length * (p - 1) + (props.carouselMargin or 0)

		if p == #list then
			length = props.itemSize.X
		end

		return { length = length, offset = offset, index = p }
	end
end

local function fn(callback) -- 2 equivalent calls inferred from this helper
	if callback then
		return Promise.is(callback) and callback or Promise.promisify(callback)
	end

	return nil
end

function extended.render(props)
	local props2 = props.props
	local state = props.state

	local itemList = props2.itemList
	local itemSize = props2.itemSize
	local itemPadding = props2.itemPadding

	local carouselMargin = props2.carouselMargin
	local layoutOrder = props2.layoutOrder

	local loadNext = props2.loadNext
	local loadPrevious = props2.loadPrevious
	local scrollLeftButton

	if state.hovering and state.showLeftButton then
		scrollLeftButton = Roact.createElement(ScrollButton, {
			icon = iconsactionscycleLeft,
			callback = props.scrollLeft
		})
	end

	local scrollRightButton

	if state.hovering and state.showRightButton then
		scrollRightButton = Roact.createElement(ScrollButton, {
			icon = iconsactionscycleRight,
			callback = props.scrollRight
		})
	end

	local createElement = Roact.createElement
	local v = {
		Size = UDim2.new(1, 0, 0, itemSize.Y),
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		[Roact.Ref] = props.frameRef,
		[Roact.Event.InputBegan] = props.onMouseEnter,
		[Roact.Event.InputEnded] = props.onMouseLeave,
		[Roact.Change.AbsoluteSize] = props.onResize
	}
	local v2 = {
		LeftMargin = Roact.createElement("Frame", {
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 2
		}, { ScrollLeftButton = scrollLeftButton }),
		ScrollerCarousel = 0,
		RightMargin = 0
	}
	local scrollerCarousel

	if state.maxNumOfItemsVisible > 0 then
		local createElement2 = Roact.createElement
		local listRefsByRef = {
			[Roact.Ref] = props.listRef,
			data = itemList,
			renderItem = props.proxyRenderItem,
			keyExtractor = props.proxyKeyExtractor,
			horizontal = true,
			initialScrollIndex = 1,
			initialNumToRender = 10,
			windowSize = 5,
			onScroll = props.onScrollUpdate,
			onStartReachedThreshold = 1,
			onStartReached = fn(loadPrevious), -- inferred equivalent call
			onEndReachedThreshold = 1,
			onEndReached = fn(loadNext), -- inferred equivalent call
			overrideAutomaticCanvasSize = true,
			getItemLayout = props.getItemLayout,
			viewabilityConfigCallbackPairs = props2.viewabilityConfigCallbackPairs,
			ItemSeparatorComponent = itemPadding and function()
				return Roact.createFragment({
					ItemPadding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, itemPadding)
					})
				})
			end or nil,
			showDefaultLoadingIndicators = false,
			ListHeaderComponent = carouselMargin and function()
				return Roact.createFragment({
					LeftCarouselMargin = Roact.createElement("Frame", {
						Position = UDim2.fromScale(0, 0),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, carouselMargin, 1, 0)
					})
				})
			end or nil,
			ListFooterComponent = carouselMargin and function()
				return Roact.createFragment({
					RightCarouselMargin = Roact.createElement("Frame", {
						Position = UDim2.fromScale(0, 0),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						Size = UDim2.new(0, carouselMargin, 1, 0)
					})
				})
			end or nil,
			contentContainerStyle = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 1),
				ClipsDescendants = false
			},
			style = { BackgroundTransparency = 1, ScrollBarThickness = 0 },
			onContentSizeChange = props2.onContentSizeChange
		}
		scrollerCarousel = createElement2(BidirectionalFlatList, listRefsByRef) or nil
	end

	v2.ScrollerCarousel = scrollerCarousel

	v2.RightMargin = Roact.createElement("Frame", {
		Position = UDim2.fromScale(1, 0),
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.new(0, carouselMargin, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2
	}, { ScrollRightButton = scrollRightButton })
	return createElement("Frame", v, v2)
end

return extended
