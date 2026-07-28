local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local Cryo = require(CollectionViewsParent.Cryo)
local ArgCheck = require(CollectionViewsParent.ArgCheck)
local useDesignTokens = require(CollectionViewsParent.Style).useDesignTokens
local Responsive = require(CollectionViewsParent.Responsive)
local useLastInput = Responsive.useLastInput
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local t = require(CollectionViewsParent.t)
local validateProps = require(CollectionViewsParent.DiscoveryUtils).validateProps
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
local CompositionTags = require(CollectionViewsParent.AppComposition).CompositionTags
local calculateCarouselSpacingMetrics = require(CollectionViews.Carousel.calculateCarouselSpacingMetrics)
local SharedFlags = require(CollectionViewsParent.SharedFlags)
local FFlagCollectionViewMathChanges = SharedFlags.FFlagCollectionViewMathChanges
local FFlagLuaAppEnableVRCarouselScrolling = SharedFlags.FFlagLuaAppEnableVRCarouselScrolling
local FFlagLuaAppFixCarouselPeekInControl = SharedFlags.FFlagLuaAppFixCarouselPeekInControl
local FFlagLuaAppHideCarouselSubtitleChevron = SharedFlags.FFlagLuaAppHideCarouselSubtitleChevron
local v29 = t.strictInterface({
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
	hideSubtitleChevron = if not FFlagLuaAppHideCarouselSubtitleChevron then nil else t.optional(t.boolean)
})
local t1 = {
	numColumns = 0,
	fractionalItemAmount = 0,
	columnGap = 0,
	sideMargin = 0
}

local function isScrollingEnabled(b1: boolean?, b2: boolean?) -- line: 221
	-- upvalues: FFlagLuaAppEnableVRCarouselScrolling (copy)
	if b1 ~= nil then
		return b1
	end

	if FFlagLuaAppEnableVRCarouselScrolling then
		return true
	end

	return not b2
end
local function areScrollButtonsEnabled(s1: string, _: string, b3: boolean, b4: boolean?, b5: boolean) -- line: 234
	-- upvalues: Responsive (copy), FFlagLuaAppEnableVRCarouselScrolling (copy)
	if not b3 then
		return false
	end

	if b4 ~= nil then
		return b4
	end

	return s1 == Responsive.Input.Pointer or FFlagLuaAppEnableVRCarouselScrolling and b5
end
local function CollectionCarousel(t2: {[any]: any}) -- line: 254
	-- upvalues: validateProps (copy), v29 (copy), Cryo (copy), t1 (copy), useCollectionLayout (copy), FFlagLuaAppFixCarouselPeekInControl (copy), ArgCheck (copy), React (copy), FFlagCollectionViewMathChanges (copy), useLastInput (copy), usePreferredInput (copy), useIsSpatial (copy), Responsive (copy), FFlagLuaAppEnableVRCarouselScrolling (copy), useCollectionSizeBindings (copy), calculateCarouselSpacingMetrics (copy), useScrollButtonHandlers (copy), useCarouselScrollingBinding (copy), useDesignTokens (copy), ScrollingRowOfCollectionItems (copy), CollectionBackgroundMural (copy), maybeForceDarkTheme (copy), CollectionHeader (copy), FFlagLuaAppHideCarouselSubtitleChevron (copy), CompositionTags (copy), CarouselScrollButtons (copy)
	validateProps(v29, t2)

	local v42 = Cryo.Dictionary.join(t1, t2)
	local sideMargin = v42.sideMargin
	local v44 = useCollectionLayout(t2.collectionItemSize)
	local v45 = t2.numColumns or v44.itemsPerRow
	local v46 = t2.columnGap or v44.gutter
	local v47 = if not FFlagLuaAppFixCarouselPeekInControl then v44.carouselPeek or 0 else if not t2.collectionItemSize then nil else v44.carouselPeek or 0

	ArgCheck.assert(v45 >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(v42.fractionalItemAmount >= 0)
	ArgCheck.assert(v46 >= 0)

	local v48 = React.useRef(nil)
	local u49 = nil
	local u50 = nil
	local v51 = nil

	if FFlagCollectionViewMathChanges then
		local v52, v53 = React.useBinding(0)

		u49 = v52
		u50 = v53
		v51 = React.useCallback(function(p1) -- line: 278
			-- upvalues: u50 (ref)
			if p1 then
				u50(p1.AbsoluteSize.X)
			end
		end, {})
	end

	local v54 = React.useCallback(function(p2) -- line: 285
		-- upvalues: v48 (copy), FFlagCollectionViewMathChanges (copy), u50 (ref), v42 (copy)
		v48.current = p2

		if FFlagCollectionViewMathChanges and p2 then
			u50(p2.AbsoluteSize.X)
		end

		if v42.onScrollingFrameRefCallback then
			v42.onScrollingFrameRefCallback(p2)
		end

		if v42.scrollingFrameRef then
			v42.scrollingFrameRef.current = p2
		end
	end, {
		v42.onScrollingFrameRefCallback,
		v42.scrollingFrameRef
	})
	local v55 = useLastInput()
	local v56 = usePreferredInput()
	local v57 = useIsSpatial()
	local v58 = v42.hideHeaderButton or v56 == Responsive.Input.Directional
	local scrollingEnabledOverride = v42.scrollingEnabledOverride
	local v60 = if scrollingEnabledOverride == nil then not not FFlagLuaAppEnableVRCarouselScrolling or not v57 else scrollingEnabledOverride
	local v61 = math.min(v42.maxItemsToShow or #v42.items, #v42.items)

	if not v60 then
		v61 = math.min(v45, v61)
	end

	ArgCheck.assert(v61 >= 0)

	local v62 = (not v60 or not (v45 < v61)) and 0 or v42.fractionalItemAmount
	local v63, v64, v65, v66 = useCollectionSizeBindings(v45, v46, sideMargin, v62, v42.getItemHeight, v42.onContainerSizeChanged, v47)
	local v67 = nil

	if FFlagCollectionViewMathChanges then
		v67 = React.useMemo(function() -- line: 337
			-- upvalues: React (copy), u49 (ref), v63 (copy), calculateCarouselSpacingMetrics (copy), v45 (copy), v46 (copy), v47 (copy), v62 (copy)
			return React.joinBindings({
				u49,
				v63
			}):map(function(p3) -- line: 338
				-- upvalues: calculateCarouselSpacingMetrics (copy), v45 (copy), v46 (copy), v47 (copy), v62 (copy)
				return calculateCarouselSpacingMetrics(p3[1], v45, v46, v47 or 0, v62, p3[2].X)
			end)
		end, {
			u49,
			v63,
			v45,
			v46,
			v47,
			v62
		})
	end

	local shouldShowScrollButtonsOverride = v42.shouldShowScrollButtonsOverride
	local v69 = if not FFlagLuaAppEnableVRCarouselScrolling then nil else v57
	local v70 = if v60 then if shouldShowScrollButtonsOverride == nil then v55 == Responsive.Input.Pointer or FFlagLuaAppEnableVRCarouselScrolling and v69 else shouldShowScrollButtonsOverride else false
	local v71, v72, v73, v74 = useScrollButtonHandlers(v48, v61, v70, v45, if not FFlagCollectionViewMathChanges then v63 else nil, if not FFlagCollectionViewMathChanges then v46 else nil, nil, if not FFlagCollectionViewMathChanges then nil else v67)
	local v75 = useCarouselScrollingBinding(v48, v42.enableHoverOverflow == true)
	local v76 = v46 * 0.5
	local v77 = React.useMemo(function() -- line: 376
		-- upvalues: v42 (copy), React (copy), v63 (copy), v75 (copy), v76 (copy)
		if not v42.enableHoverOverflow then
			return nil
		end

		return React.joinBindings({
			v63,
			v75
		}):map(function(p4) -- line: 380
			-- upvalues: v76 (copy)
			local v93 = p4[1]
			local v94 = p4[2]

			return UDim2.new(1, if not v94 then -v76 * 2 else 0, 0, v93.Y)
		end)
	end, {
		v63,
		v75,
		v76,
		v42.enableHoverOverflow
	})
	local v78 = React.useMemo(function() -- line: 386
		-- upvalues: v42 (copy), v75 (copy), v76 (copy)
		if not v42.enableHoverOverflow then
			return nil
		end

		return v75:map(function(p5) -- line: 390
			-- upvalues: v76 (copy)
			return UDim2.new(0, if not p5 then v76 else 0, 0, 500)
		end)
	end, {
		v75,
		v76,
		v42.enableHoverOverflow
	})
	local v79 = useDesignTokens()
	local Size_400 = v79.Size.Size_400
	local Size_500 = v79.Size.Size_500
	local White_100 = v79.Color.Extended.White.White_100
	local v83 = v42.backgroundMuralUrl ~= nil
	local v84 = v42.title and v42.title ~= ""
	local v85 = React.createElement(ScrollingRowOfCollectionItems, {
		Position = v78,
		Size = v77,
		ScrollingEnabled = v60,
		onChangeCanvasPosition = v42.onChangeCanvasPosition,
		onScrollingFrameRefCallback = v54,
		itemSizeBinding = v63,
		items = v42.items,
		totalItemsOnCanvas = v61,
		numColumns = v45,
		columnGap = v46,
		renderItem = v42.renderItem,
		sideMargin = sideMargin,
		numItemsToRenderOffScreen = v42.numItemsToRenderOffScreen,
		onReachedThresholdFromEnd = v42.onReachedThresholdFromEnd,
		thresholdFromEnd = v42.thresholdFromEnd,
		onViewableItemsChanged = v42.onViewableItemsChanged,
		AutomaticSize = v42.AutomaticSize,
		spacingMetricsBinding = if not FFlagCollectionViewMathChanges then nil else v67,
		onScrollingFrameAbsoluteSizeChanged = if not FFlagCollectionViewMathChanges then nil else v51
	})

	return React.createElement("Frame", {
		ref = v42.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v42.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v42.LayoutOrder,
		[React.Tag] = if not v42.testId then nil else `data-testid={ v42.testId }`
	}, {
		BackgroundMural = v42.backgroundMuralUrl and React.createElement(CollectionBackgroundMural, {
			ZIndex = -1,
			backgroundMuralUrl = v42.backgroundMuralUrl,
			containerSizeBinding = v64
		}) or nil,
		CollectionContent = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v65,
			ref = v66
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = if v42.backgroundMuralUrl == nil then nil else UDim.new(0, Size_500),
				PaddingLeft = if not (sideMargin > 0) then nil else UDim.new(0, sideMargin),
				PaddingRight = if not (sideMargin > 0) then nil else UDim.new(0, sideMargin)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, not v84 and not v42.headerComponent and 0 or Size_400)
			}),
			CollectionHeader = if not v42.headerComponent then maybeForceDarkTheme(React.createElement(CollectionHeader, {
				LayoutOrder = 1,
				title = v42.title,
				subtitle = v42.subtitle,
				tooltipInfoText = v42.tooltipInfoText,
				onActivateInfoIcon = v42.onActivateInfoIcon,
				tooltipSupportsVR = v42.tooltipSupportsVR,
				tooltipSupportsTenFootUi = v42.tooltipSupportsTenFootUi,
				hideButton = #v42.items < 1 or (v58 or not v84),
				onActivate = v42.onActivateHeader,
				onActivateSubtitle = v42.onActivateSubtitle,
				buttonText = v42.headerButtonText,
				titleColor = if not v83 then nil else White_100,
				subtitleColor = if not v83 then nil else White_100,
				hideSubtitleChevron = if not FFlagLuaAppHideCarouselSubtitleChevron then nil else v42.hideSubtitleChevron
			}), v83) else v42.headerComponent,
			Items = React.createElement("Frame", {
				Size = if not v42.enableHoverOverflow then UDim2.new(1, 0, 0, 0) else v63:map(function(vector2: Vector2) -- line: 487
					return UDim2.new(1, 0, 0, vector2.Y)
				end),
				AutomaticSize = if v42.enableHoverOverflow then nil else Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				[React.Tag] = if not v42.collectionItemSize or v42.enableHoverOverflow then nil else CompositionTags.Utility.ClipAtMaxWidth
			}, {
				CarouselClip = if not v42.enableHoverOverflow then nil else React.createElement("Frame", {
					Size = v75:map(function(p6) -- line: 501
						-- upvalues: v76 (copy)
						return UDim2.new(1, if not p6 then v76 * 2 else 0, 1, 1000)
					end),
					Position = v75:map(function(p7) -- line: 509
						-- upvalues: v76 (copy)
						return UDim2.new(0, if not p7 then -v76 else 0, 0, -500)
					end),
					BackgroundTransparency = 1,
					[React.Tag] = if not v42.collectionItemSize then nil else CompositionTags.Utility.ClipAtMaxWidth
				}, {
					ScrollingItems = v85
				}),
				ScrollingItems = if v42.enableHoverOverflow then nil else v85,
				ScrollButtons = if not v70 then nil else React.createElement(CarouselScrollButtons, {
					ZIndex = 10,
					handleScrollLeft = v71,
					handleScrollRight = v72,
					leftScrollingEnabled = v73,
					rightScrollingEnabled = v74,
					Size = UDim2.new(1, 2 * sideMargin, 1, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					buttonOffsetFromEdge = v79.Size.Size_200,
					onScrollButtonEnter = v42.onScrollButtonEnter,
					onScrollButtonLeave = v42.onScrollButtonLeave
				})
			})
		})
	})
end

return (React.memo(CollectionCarousel))
