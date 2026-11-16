local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Cryo")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/ArgCheck")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Hooks.useTokens
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagSduiComponentsUseFoundationTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Responsive")
local useLastInput = Responsive.useLastInput
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/t")
local validateProps = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/DiscoveryUtils").validateProps

local useCollectionSizeBindings = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionSizeBindings")
local useScrollButtonHandlers = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/useScrollButtonHandlers")
local useCarouselScrollingBinding = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/useCarouselScrollingBinding")
local CollectionBackgroundMural = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/CollectionBackgroundMural")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionHeader")
local ScrollingRowOfCollectionItems = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/ScrollingRowOfCollectionItems")
local maybeForceDarkTheme = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/maybeForceDarkTheme")
local CarouselScrollButtons = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/CarouselScrollButtons")

require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")
local useCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/useCollectionLayout")

local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/AppComposition").CompositionTags

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

local v5 = { numColumns = 0, fractionalItemAmount = 0, columnGap = 0, sideMargin = 0 }

local function isScrollingEnabled(p2, p3)
	if p2 == nil then
		return true
	end

	return p2
end

local function areScrollButtonsEnabled(p2, p3, p4, p5, p6)
	if not p4 then
		return false
	end

	if p5 == nil then
		return p2 == Responsive.Input.Pointer or p6
	end

	return p5
end

local function CollectionCarousel(props)
	validateProps(strictInterface, props)
	local joined = Cryo.Dictionary.join(v5, props)

	local sideMargin = joined.sideMargin
	local v6 = useCollectionLayout(props.collectionItemSize)
	local numColumns = props.numColumns or v6.itemsPerRow
	local columnGap = props.columnGap or v6.gutter
	local carouselPeek = props.collectionItemSize and (v6.carouselPeek or 0) or nil

	ArgCheck.assert(numColumns >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(joined.fractionalItemAmount >= 0)
	ArgCheck.assert(columnGap >= 0)

	local ref = React.useRef(nil)

	local v7 = React.useCallback(function(current)
		ref.current = current

		if joined.onScrollingFrameRefCallback then
			joined.onScrollingFrameRefCallback(current)
		end

		if joined.scrollingFrameRef then
			joined.scrollingFrameRef.current = current
		end
	end, { joined.onScrollingFrameRefCallback, joined.scrollingFrameRef })

	local v8 = useLastInput()
	local v9 = usePreferredInput()
	local v10 = useIsSpatial()

	local hideHeaderButton = joined.hideHeaderButton or v9 == Responsive.Input.Directional

	local scrollingEnabledOverride = joined.scrollingEnabledOverride
	local v11 = scrollingEnabledOverride == nil or scrollingEnabledOverride

	local v12 = math.min(joined.maxItemsToShow or #joined.items, #joined.items)

	if not v11 then
		v12 = math.min(numColumns, v12)
	end

	ArgCheck.assert(v12 >= 0)

	local v14, v15, v16, v17 = useCollectionSizeBindings(
		numColumns,
		columnGap,
		sideMargin,
		not (v11 and numColumns < v12) and 0 or joined.fractionalItemAmount,
		joined.getItemHeight,
		joined.onContainerSizeChanged,
		carouselPeek
	)

	local v18 = joined.shouldShowScrollButtonsOverride

	if v11 then
		if v18 == nil then
			v18 = v8 == Responsive.Input.Pointer or v10
		end
	else
		v18 = false
	end

	local v19, v20, v21, v22 = useScrollButtonHandlers(ref, v12, v18, numColumns, v14, columnGap, nil)

	local v23 = useCarouselScrollingBinding(ref, joined.enableHoverOverflow == true)
	local v24 = columnGap * 0.5
	local v25 = React.useMemo(function()
		if joined.enableHoverOverflow then
			return React.joinBindings({ v14, v23 }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return UDim2.new(1, item2 and 0 or -v24 * 2, 0, item.Y)
			end)
		end

		return nil
	end, { v14, v23, v24, joined.enableHoverOverflow })
	local v26 = React.useMemo(function()
		if joined.enableHoverOverflow then
			return v23:map(function(p2)
				return UDim2.new(0, p2 and 0 or v24, 0, 500)
			end)
		end

		return nil
	end, { v23, v24, joined.enableHoverOverflow })

	local v27 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()
	local size_400 = v27.Size.Size_400
	local size_500 = v27.Size.Size_500

	local white_100 = v27.Color.Extended.White.White_100
	local v28 = joined.backgroundMuralUrl ~= nil
	local v29 = joined.title and joined.title ~= ""
	local element = React.createElement(ScrollingRowOfCollectionItems, {
		Position = v26,
		Size = v25,
		ScrollingEnabled = v11,
		onChangeCanvasPosition = joined.onChangeCanvasPosition,
		onScrollingFrameRefCallback = v7,
		itemSizeBinding = v14,
		items = joined.items,
		totalItemsOnCanvas = v12,
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
	local v31 = {
		["ref"] = joined.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = joined.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder
	}
	local tag = React.Tag
	local v32 = if joined.testId then `data-testid={joined.testId}` else nil
	v31[tag] = v32

	local v34 = if joined.backgroundMuralUrl then React.createElement(CollectionBackgroundMural, {
		backgroundMuralUrl = joined.backgroundMuralUrl,
		containerSizeBinding = v15,
		ZIndex = -1
	}) or nil else nil

	local createElement2 = React.createElement
	local v36 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Change.AbsoluteSize] = v16,
		ref = v17
	}

	local createElement3 = React.createElement
	local v39 = if joined.backgroundMuralUrl ~= nil then UDim.new(0, size_500) else nil

	local v40 = if sideMargin > 0 then UDim.new(0, sideMargin) else nil
	local v41 = if sideMargin > 0 then UDim.new(0, sideMargin) else nil
	local children = {
		UIPadding = createElement3("UIPadding", {
			PaddingTop = v39,
			PaddingLeft = v40,
			PaddingRight = v41
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, not (v29 or joined.headerComponent) and 0 or size_400)
		}),
		CollectionHeader = 0,
		Items = 0
	}
	local v42

	if joined.headerComponent then
		v42 = joined.headerComponent
	else
		local createElement4 = React.createElement
		local v45 = {
			LayoutOrder = 1,
			title = joined.title,
			subtitle = joined.subtitle,
			tooltipInfoText = joined.tooltipInfoText,
			onActivateInfoIcon = joined.onActivateInfoIcon,
			tooltipSupportsVR = joined.tooltipSupportsVR,
			tooltipSupportsTenFootUi = joined.tooltipSupportsTenFootUi,
			hideButton = #joined.items < 1 or (hideHeaderButton or not v29),
			onActivate = joined.onActivateHeader,
			onActivateSubtitle = joined.onActivateSubtitle,
			buttonText = joined.headerButtonText,
			titleColor = if v28 then white_100 else nil,
			subtitleColor = 0,
			hideSubtitleChevron = 0
		}

		if not v28 then
			white_100 = nil
		end

		v45.subtitleColor = white_100
		v45.hideSubtitleChevron = joined.hideSubtitleChevron
		v42 = maybeForceDarkTheme(createElement4(module10, v45), v28)
	end

	children.CollectionHeader = v42

	local createElement4 = React.createElement
	local v45

	if joined.enableHoverOverflow then
		v45 = v14:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y)
		end)
	else
		v45 = UDim2.new(1, 0, 0, 0)
	end

	local v46 = if not joined.enableHoverOverflow then Enum.AutomaticSize.Y else nil

	local tag2 = React.Tag
	local v47 = if joined.collectionItemSize and not joined.enableHoverOverflow then compositionTags.Utility.ClipAtMaxWidth else nil
	local v44 = {
		Size = v45,
		AutomaticSize = v46,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		[tag2] = v47
	}
	local v49

	if joined.enableHoverOverflow then
		local createElement5 = React.createElement
		local v51 = {
			["Size"] = v23:map(function(p2)
				return UDim2.new(1, p2 and 0 or v24 * 2, 1, 1000)
			end),
			Position = v23:map(function(p2)
				return UDim2.new(0, p2 and 0 or -v24, 0, -500)
			end),
			BackgroundTransparency = 1
		}

		local tag3 = React.Tag
		local v52 = if joined.collectionItemSize then compositionTags.Utility.ClipAtMaxWidth else nil
		v51[tag3] = v52
		v49 = createElement5("Frame", v51, { ScrollingItems = element })
	end

	if joined.enableHoverOverflow then
		element = nil
	end

	local v50 = if v18 then React.createElement(CarouselScrollButtons, {
		handleScrollLeft = v19,
		handleScrollRight = v20,
		leftScrollingEnabled = v21,
		rightScrollingEnabled = v22,
		ZIndex = 10,
		Size = UDim2.new(1, 2 * sideMargin, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		buttonOffsetFromEdge = v27.Size.Size_200,
		onScrollButtonEnter = joined.onScrollButtonEnter,
		onScrollButtonLeave = joined.onScrollButtonLeave
	}) else nil
	children.Items = createElement4("Frame", v44, {
		CarouselClip = v49,
		ScrollingItems = element,
		ScrollButtons = v50
	})
	return createElement("Frame", v31, {
		BackgroundMural = v34,
		CollectionContent = createElement2("Frame", v36, children)
	})
end

return (React.memo(CollectionCarousel))
