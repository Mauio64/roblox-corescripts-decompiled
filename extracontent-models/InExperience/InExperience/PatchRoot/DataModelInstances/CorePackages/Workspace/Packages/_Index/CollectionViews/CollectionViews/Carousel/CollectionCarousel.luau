local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local ArgCheck = require(parent.ArgCheck)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens
local Responsive = require(parent.Responsive)
local useLastInput = Responsive.useLastInput
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local validateProps = DiscoveryUtils.validateProps

local useCollectionSizeBindings = require(CollectionViews.useCollectionSizeBindings)
local useScrollButtonHandlers = require(CollectionViews.Carousel.useScrollButtonHandlers)
local useCarouselScrollingBinding = require(CollectionViews.Carousel.useCarouselScrollingBinding)
local CollectionBackgroundMural = require(CollectionViews.Carousel.CollectionBackgroundMural)
local CollectionHeader = require(CollectionViews.CollectionHeader)
local ScrollingRowOfCollectionItems = require(CollectionViews.Carousel.ScrollingRowOfCollectionItems)
local maybeForceDarkTheme = require(CollectionViews.maybeForceDarkTheme)
local CarouselScrollButtons = require(CollectionViews.Carousel.CarouselScrollButtons)

require(CollectionViews.CollectionViewTypes)
local useCollectionLayout = require(CollectionViews.CollectionLayoutStore.useCollectionLayout)

local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local strictInterface = t.strictInterface({
	testId = t.optional(t.string),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	containerRef = t.optional(t.union(t.table, t.callback)),
	scrollingFrameRef = t.optional(t.table),
	onScrollingFrameRefCallback = t.optional(t.callback),
	numColumns = t.optional(t.number),
	fractionalItemAmount = t.optional(t.number),
	items = t.table,
	renderItem = t.callback,
	getItemHeight = t.callback,
	columnGap = t.optional(t.number),
	sideMargin = t.optional(t.number),
	backgroundMuralUrl = t.optional(t.string),
	title = t.optional(t.union(t.string, t.callback)),
	subtitle = t.optional(t.string),
	tooltipInfoText = t.optional(t.string),
	onActivateInfoIcon = t.optional(t.callback),
	tooltipSupportsVR = t.optional(t.boolean),
	tooltipSupportsTenFootUi = t.optional(t.boolean),
	onActivateHeader = t.optional(t.callback),
	onActivateSubtitle = t.optional(t.callback),
	headerButtonText = t.optional(t.string),
	onViewableItemsChanged = t.optional(t.callback),
	onContainerSizeChanged = t.optional(t.callback),
	onChangeCanvasPosition = t.optional(t.callback),
	onReachedThresholdFromEnd = t.optional(t.union(t.callback, t.table)),
	thresholdFromEnd = t.optional(t.number),
	scrollingEnabledOverride = t.optional(t.boolean),
	shouldShowScrollButtonsOverride = t.optional(t.boolean),
	hideHeaderButton = t.optional(t.boolean),
	maxItemsToShow = t.optional(t.number),
	numItemsToRenderOffScreen = t.optional(t.number),
	onScrollButtonEnter = t.optional(t.callback),
	onScrollButtonLeave = t.optional(t.callback),
	AutomaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	headerComponent = t.optional(t.table),
	collectionItemSize = t.optional(t.string),
	enableHoverOverflow = t.optional(t.boolean),
	hideSubtitleChevron = t.optional(t.boolean)
})

local v = { numColumns = 0, fractionalItemAmount = 0, columnGap = 0, sideMargin = 0 }

local function isScrollingEnabled(scrollingEnabledOverride: boolean?, _: boolean?) -- 1 equivalent call inferred from this helper
	return scrollingEnabledOverride == nil or scrollingEnabledOverride
end

local function areScrollButtonsEnabled(p: string, _: string, scrollingEnabled: boolean, shouldShowScrollButtonsOverride: boolean?, flag: boolean) -- 1 equivalent call inferred from this helper
	if not scrollingEnabled then
		return false
	end

	if shouldShowScrollButtonsOverride == nil then
		return p == Responsive.Input.Pointer or flag
	end

	return shouldShowScrollButtonsOverride
end

local function CollectionCarousel(props)
	validateProps(strictInterface, props)
	local joined = Cryo.Dictionary.join(v, props)

	local sideMargin = joined.sideMargin
	local v2 = useCollectionLayout(props.collectionItemSize)
	local numColumns = props.numColumns or v2.itemsPerRow
	local columnGap = props.columnGap or v2.gutter
	local carouselPeek = props.collectionItemSize and (v2.carouselPeek or 0) or nil

	ArgCheck.assert(numColumns >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(joined.fractionalItemAmount >= 0)
	ArgCheck.assert(columnGap >= 0)

	local ref = React.useRef(nil)

	local onScrollingFrameRefCallback = React.useCallback(function(current)
		ref.current = current

		if joined.onScrollingFrameRefCallback then
			joined.onScrollingFrameRefCallback(current)
		end

		if joined.scrollingFrameRef then
			joined.scrollingFrameRef.current = current
		end
	end, { joined.onScrollingFrameRefCallback, joined.scrollingFrameRef })

	local v3 = useLastInput()
	local v4 = usePreferredInput()
	local v5 = useIsSpatial()

	local hideHeaderButton = joined.hideHeaderButton or v4 == Responsive.Input.Directional

	local scrollingEnabled = isScrollingEnabled(joined.scrollingEnabledOverride) -- inferred equivalent call

	local totalItemsOnCanvas = math.min(joined.maxItemsToShow or #joined.items, #joined.items)

	if not scrollingEnabled then
		totalItemsOnCanvas = math.min(numColumns, totalItemsOnCanvas)
	end

	ArgCheck.assert(totalItemsOnCanvas >= 0)

	local itemSizeBinding, containerSizeBinding, v6, ref2 = useCollectionSizeBindings(
		numColumns,
		columnGap,
		sideMargin,
		not (scrollingEnabled and numColumns < totalItemsOnCanvas) and 0 or joined.fractionalItemAmount,
		joined.getItemHeight,
		joined.onContainerSizeChanged,
		carouselPeek
	)

	local v7 = areScrollButtonsEnabled(v3, nil, scrollingEnabled, joined.shouldShowScrollButtonsOverride, v5) -- inferred equivalent call

	local handleScrollLeft, handleScrollRight, leftScrollingEnabled, rightScrollingEnabled = useScrollButtonHandlers(
		ref,
		totalItemsOnCanvas,
		v7,
		numColumns,
		itemSizeBinding,
		columnGap,
		nil
	)

	local v8 = useCarouselScrollingBinding(ref, joined.enableHoverOverflow == true)
	local v9 = columnGap * 0.5
	local size = React.useMemo(function()
		if not joined.enableHoverOverflow then
			return nil
		end

		return React.joinBindings({ itemSizeBinding, v8 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			return UDim2.new(1, item2 and 0 or -v9 * 2, 0, item.Y)
		end)
	end, { itemSizeBinding, v8, v9, joined.enableHoverOverflow })
	local position = React.useMemo(function()
		if joined.enableHoverOverflow then
			return v8:map(function(p)
				return UDim2.new(0, p and 0 or v9, 0, 500)
			end)
		end

		return nil
	end, { v8, v9, joined.enableHoverOverflow })
	local v10

	if FFlagSduiComponentsUseFoundationTokens then
		v10 = useTokens()
	else
		v10 = useDesignTokens()
	end

	local size_400 = v10.Size.Size_400
	local size_500 = v10.Size.Size_500

	local white_100 = v10.Color.Extended.White.White_100
	local v11 = joined.backgroundMuralUrl ~= nil
	local v12 = joined.title and joined.title ~= ""
	local element = React.createElement(ScrollingRowOfCollectionItems, {
		Position = position,
		Size = size,
		ScrollingEnabled = scrollingEnabled,
		onChangeCanvasPosition = joined.onChangeCanvasPosition,
		onScrollingFrameRefCallback = onScrollingFrameRefCallback,
		itemSizeBinding = itemSizeBinding,
		items = joined.items,
		totalItemsOnCanvas = totalItemsOnCanvas,
		numColumns = numColumns,
		columnGap = columnGap,
		renderItem = joined.renderItem,
		sideMargin = sideMargin,
		numItemsToRenderOffScreen = joined.numItemsToRenderOffScreen,
		onReachedThresholdFromEnd = joined.onReachedThresholdFromEnd,
		thresholdFromEnd = joined.thresholdFromEnd,
		onViewableItemsChanged = joined.onViewableItemsChanged,
		AutomaticSize = joined.AutomaticSize
	})

	local createElement = React.createElement
	local v13 = {
		["ref"] = joined.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = joined.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder
	}
	local tag = React.Tag
	local v14

	if joined.testId then
		v14 = `data-testid={joined.testId}`
	end

	v13[tag] = v14
	local backgroundMural

	if joined.backgroundMuralUrl then
		backgroundMural = React.createElement(CollectionBackgroundMural, {
				backgroundMuralUrl = joined.backgroundMuralUrl,
				containerSizeBinding = containerSizeBinding,
				ZIndex = -1
			})
			or nil
	end

	local createElement2 = React.createElement
	local v15 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = v6,
		ref = ref2
	}

	local createElement3 = React.createElement
	local paddingTop

	if joined.backgroundMuralUrl ~= nil then
		paddingTop = UDim.new(0, size_500)
	end

	local paddingLeft

	if sideMargin > 0 then
		paddingLeft = UDim.new(0, sideMargin)
	end

	local paddingRight

	if sideMargin > 0 then
		paddingRight = UDim.new(0, sideMargin)
	end

	local children = {
		UIPadding = createElement3("UIPadding", {
			PaddingTop = paddingTop,
			PaddingLeft = paddingLeft,
			PaddingRight = paddingRight
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, not (v12 or joined.headerComponent) and 0 or size_400)
		}),
		CollectionHeader = 0,
		Items = 0
	}
	local collectionHeader

	if joined.headerComponent then
		collectionHeader = joined.headerComponent
	else
		local createElement4 = React.createElement
		local v16 = {
			LayoutOrder = 1,
			title = joined.title,
			subtitle = joined.subtitle,
			tooltipInfoText = joined.tooltipInfoText,
			onActivateInfoIcon = joined.onActivateInfoIcon,
			tooltipSupportsVR = joined.tooltipSupportsVR,
			tooltipSupportsTenFootUi = joined.tooltipSupportsTenFootUi,
			hideButton = #joined.items < 1 or (hideHeaderButton or not v12),
			onActivate = joined.onActivateHeader,
			onActivateSubtitle = joined.onActivateSubtitle,
			buttonText = joined.headerButtonText,
			titleColor = 0,
			subtitleColor = 0,
			hideSubtitleChevron = 0
		}
		local titleColor

		if v11 then
			titleColor = white_100
		end

		v16.titleColor = titleColor

		if not v11 then
			white_100 = nil
		end

		v16.subtitleColor = white_100
		v16.hideSubtitleChevron = joined.hideSubtitleChevron
		collectionHeader = maybeForceDarkTheme(createElement4(CollectionHeader, v16), v11)
	end

	children.CollectionHeader = collectionHeader

	local createElement4 = React.createElement
	local size2

	if joined.enableHoverOverflow then
		size2 = itemSizeBinding:map(function(vector2: Vector2)
			return UDim2.new(1, 0, 0, vector2.Y)
		end)
	else
		size2 = UDim2.new(1, 0, 0, 0)
	end

	local automaticSize

	if not joined.enableHoverOverflow then
		automaticSize = Enum.AutomaticSize.Y
	end

	local tag2 = React.Tag
	local v16

	if joined.collectionItemSize and not joined.enableHoverOverflow then
		v16 = CompositionTags.Utility.ClipAtMaxWidth
	end

	local v17 = {
		Size = size2,
		AutomaticSize = automaticSize,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		[tag2] = v16
	}
	local carouselClip

	if joined.enableHoverOverflow then
		local createElement5 = React.createElement
		local v18 = {
			["Size"] = v8:map(function(p)
				return UDim2.new(1, p and 0 or v9 * 2, 1, 1000)
			end),
			Position = v8:map(function(p)
				return UDim2.new(0, p and 0 or -v9, 0, -500)
			end),
			BackgroundTransparency = 1
		}

		local tag3 = React.Tag
		local v19

		if joined.collectionItemSize then
			v19 = CompositionTags.Utility.ClipAtMaxWidth
		end

		v18[tag3] = v19
		carouselClip = createElement5("Frame", v18, { ScrollingItems = element })
	end

	if joined.enableHoverOverflow then
		element = nil
	end

	local scrollButtons

	if v7 then
		scrollButtons = React.createElement(CarouselScrollButtons, {
			handleScrollLeft = handleScrollLeft,
			handleScrollRight = handleScrollRight,
			leftScrollingEnabled = leftScrollingEnabled,
			rightScrollingEnabled = rightScrollingEnabled,
			ZIndex = 10,
			Size = UDim2.new(1, 2 * sideMargin, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			buttonOffsetFromEdge = v10.Size.Size_200,
			onScrollButtonEnter = joined.onScrollButtonEnter,
			onScrollButtonLeave = joined.onScrollButtonLeave
		})
	end

	children.Items = createElement4("Frame", v17, {
		CarouselClip = carouselClip,
		ScrollingItems = element,
		ScrollButtons = scrollButtons
	})
	return createElement("Frame", v13, {
		BackgroundMural = backgroundMural,
		CollectionContent = createElement2("Frame", v15, children)
	})
end

return (React.memo(CollectionCarousel))
