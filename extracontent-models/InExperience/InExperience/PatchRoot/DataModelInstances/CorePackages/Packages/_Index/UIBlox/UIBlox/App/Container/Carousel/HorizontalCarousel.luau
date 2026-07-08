local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Images = require(ParentParent.ImageSet.Images)
local ScrollButton = require(scriptParent.ScrollButton)
local isCallable = require(ParentParentParent.Utility.isCallable)
local BidirectionalFlatList = require(ParentParentParentParent.VirtualizedList).BidirectionalFlatList
local Promise = require(ParentParentParentParent.Promise)
local LuauPolyfill = require(ParentParentParentParent.LuauPolyfill)
local v13 = Images["icons/actions/cycleLeft"]
local v14 = Images["icons/actions/cycleRight"]
local v15 = Roact.PureComponent:extend("HorizontalCarousel")

v15.validateProps = t.strictInterface({
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
v15.defaultProps = {
	itemPadding = 12,
	maxNumOfItemsVisible = 0,
	itemSize = Vector2.new(1, 1)
}

local function updateScrollState(n1: number?, n2: number, n3: number?, _: number?) -- line: 119
	if n1 == nil then
		return {}
	end

	if n3 == nil or n3 == 0 then
		return {
			showLeftButton = false,
			showRightButton = false
		}
	end

	local v21 = true
	local v22 = true

	if n1 <= 1 then
		n1 = 1
		v21 = false
	elseif n3 < n1 then
		n1 = n3
		v22 = false
	end

	if n3 < n1 + n2 then
		v22 = false
	end

	return {
		index = n1,
		showLeftButton = v21,
		showRightButton = v22,
		numOfItems = n3
	}
end

function v15.getDerivedStateFromProps(t1: {[any]: any}, t2: {[any]: any}) -- line: 172
	-- upvalues: updateScrollState (copy)
	local v26 = #t1.itemList

	if v26 ~= t2.numOfItems then
		return (updateScrollState(t2.index, t2.maxNumOfItemsVisible, v26))
	end

	return nil
end
function v15.init(p1) -- line: 180
	-- upvalues: Roact (copy), LuauPolyfill (copy), updateScrollState (copy)
	p1.frameRef = Roact.createRef()
	p1.listRef = Roact.createRef()

	local t3 = {
		anchorIndex = 1
	}

	p1:setState({
		index = 1,
		hovering = false,
		showLeftButton = false,
		showRightButton = false,
		numOfItems = 0,
		maxNumOfItemsVisible = p1.props.maxNumOfItemsVisible
	})

	function p1.onMouseEnter(_, p3) -- line: 197
		-- upvalues: p1 (copy), t3 (ref), LuauPolyfill (copy), updateScrollState (copy)
		if p3.UserInputType == Enum.UserInputType.MouseMovement then
			p1:setState(function(p4) -- line: 199
				-- upvalues: t3 (ref), LuauPolyfill (copy), updateScrollState (copy)
				local anchorIndex = t3.anchorIndex

				return LuauPolyfill.Object.assign(updateScrollState(anchorIndex, p4.maxNumOfItemsVisible, p4.numOfItems), {
					hovering = true
				})
			end)
		end
	end
	function p1.onMouseLeave(_, p6) -- line: 209
		-- upvalues: p1 (copy)
		if p6.UserInputType == Enum.UserInputType.MouseMovement then
			p1:setState({
				hovering = false
			})
		end
	end
	function p1.onResize(p7) -- line: 217
		-- upvalues: p1 (copy)
		local AbsoluteSizeX = p7.AbsoluteSize.X

		p1:setState(function(_, p9) -- line: 219
			-- upvalues: AbsoluteSizeX (copy)
			return {
				maxNumOfItemsVisible = math.floor(AbsoluteSizeX / (p9.itemSize.X + p9.itemPadding))
			}
		end)
	end
	function p1.onScrollUpdate(p10) -- line: 225
		-- upvalues: p1 (copy), t3 (ref)
		local v48 = p1.props.itemSize.X + p1.props.itemPadding
		local v49 = math.floor((p10.CanvasPosition.X > 0 and p10.CanvasPosition.X or 0) / v48) + 1

		t3 = {
			animationActive = false,
			anchorIndex = v49
		}
	end
	function p1.scrollLeft() -- line: 237
		-- upvalues: t3 (ref), p1 (copy), updateScrollState (copy)
		if t3.animationActive then
			return
		end

		p1:setState(function(p11, p12) -- line: 241
			-- upvalues: t3 (ref), p1 (copy), updateScrollState (copy)
			local v65 = t3.anchorIndex - p11.maxNumOfItemsVisible

			if p1.listRef then
				p1.listRef.current:scrollToIndex({
					animated = true,
					index = v65 > 1 and v65 or 1,
					viewOffset = p12.itemSize.X + p12.itemPadding
				})
			end

			return (updateScrollState(v65, p11.maxNumOfItemsVisible, p11.numOfItems))
		end)
	end
	function p1.scrollRight() -- line: 254
		-- upvalues: t3 (ref), p1 (copy), updateScrollState (copy)
		if t3.animationActive then
			return
		end

		p1:setState(function(p13, p14) -- line: 258
			-- upvalues: t3 (ref), p1 (copy), updateScrollState (copy)
			local v68 = t3.anchorIndex + p13.maxNumOfItemsVisible

			if p1.listRef then
				p1.listRef.current:scrollToIndex({
					animated = true,
					index = v68,
					viewOffset = p14.itemSize.X + p14.itemPadding
				})
			end

			return (updateScrollState(v68, p13.maxNumOfItemsVisible, p13.numOfItems))
		end)
	end
	function p1.proxyKeyExtractor(p15, p16) -- line: 271
		-- upvalues: p1 (copy)
		local props = p1.props

		if props.identifier then
			return (props.identifier(p15, p16))
		end

		return nil
	end
	function p1.proxyRenderItem(p17) -- line: 276
		-- upvalues: p1 (copy)
		return p1.props.renderItem(p17.item)
	end
	function p1.getItemLayout(p18, p19) -- line: 281
		-- upvalues: p1 (copy)
		local props = p1.props
		local v57 = props.itemSize.X + (props.itemPadding or 0)
		local v58 = v57 * (p19 - 1) + (props.carouselMargin or 0)

		return {
			length = if p19 ~= #p18 then v57 else props.itemSize.X,
			offset = v58,
			index = p19
		}
	end
end
function v15.render(p20) -- line: 295
	-- upvalues: Roact (copy), ScrollButton (copy), v13 (copy), v14 (copy), BidirectionalFlatList (copy), Promise (copy)
	local props = p20.props
	local state = p20.state
	local itemList = props.itemList
	local itemSize = props.itemSize
	local itemPadding = props.itemPadding
	local carouselMargin = props.carouselMargin
	local layoutOrder = props.layoutOrder
	local loadNext = props.loadNext
	local loadPrevious = props.loadPrevious
	local v39 = nil

	if state.hovering and state.showLeftButton then
		v39 = Roact.createElement(ScrollButton, {
			icon = v13,
			callback = p20.scrollLeft
		})
	end

	local v40 = nil

	if state.hovering and state.showRightButton then
		v40 = Roact.createElement(ScrollButton, {
			icon = v14,
			callback = p20.scrollRight
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, itemSize.Y),
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		[Roact.Ref] = p20.frameRef,
		[Roact.Event.InputBegan] = p20.onMouseEnter,
		[Roact.Event.InputEnded] = p20.onMouseLeave,
		[Roact.Change.AbsoluteSize] = p20.onResize
	}, {
		LeftMargin = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0)
		}, {
			ScrollLeftButton = v39
		}),
		ScrollerCarousel = state.maxNumOfItemsVisible > 0 and Roact.createElement(BidirectionalFlatList, {
			[Roact.Ref] = p20.listRef,
			data = itemList,
			renderItem = p20.proxyRenderItem,
			keyExtractor = p20.proxyKeyExtractor,
			horizontal = true,
			initialScrollIndex = 1,
			initialNumToRender = 10,
			windowSize = 5,
			onScroll = p20.onScrollUpdate,
			onStartReachedThreshold = 1,
			onStartReached = if loadPrevious then Promise.is(loadPrevious) and loadPrevious or Promise.promisify(loadPrevious) else nil,
			onEndReachedThreshold = 1,
			onEndReached = if loadNext then Promise.is(loadNext) and loadNext or Promise.promisify(loadNext) else nil,
			overrideAutomaticCanvasSize = true,
			getItemLayout = p20.getItemLayout,
			viewabilityConfigCallbackPairs = props.viewabilityConfigCallbackPairs,
			ItemSeparatorComponent = if not itemPadding then nil else function() -- line: 368
				-- upvalues: Roact (copy), itemPadding (copy)
				return Roact.createFragment({
					ItemPadding = Roact.createElement("UIPadding", {
						PaddingRight = UDim.new(0, itemPadding)
					})
				})
			end,
			showDefaultLoadingIndicators = false,
			ListHeaderComponent = if not carouselMargin then nil else function() -- line: 379
				-- upvalues: Roact (copy), carouselMargin (copy)
				return Roact.createFragment({
					LeftCarouselMargin = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0, 0),
						AnchorPoint = Vector2.new(0, 0),
						Size = UDim2.new(0, carouselMargin, 1, 0)
					})
				})
			end,
			ListFooterComponent = if not carouselMargin then nil else function() -- line: 392
				-- upvalues: Roact (copy), carouselMargin (copy)
				return Roact.createFragment({
					RightCarouselMargin = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.fromScale(0, 0),
						AnchorPoint = Vector2.new(0, 0),
						Size = UDim2.new(0, carouselMargin, 1, 0)
					})
				})
			end,
			contentContainerStyle = {
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				Size = UDim2.fromScale(0, 1)
			},
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0
			},
			onContentSizeChange = props.onContentSizeChange
		}) or nil,
		RightMargin = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.fromScale(1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, carouselMargin, 1, 0)
		}, {
			ScrollRightButton = v40
		})
	})
end

return v15
