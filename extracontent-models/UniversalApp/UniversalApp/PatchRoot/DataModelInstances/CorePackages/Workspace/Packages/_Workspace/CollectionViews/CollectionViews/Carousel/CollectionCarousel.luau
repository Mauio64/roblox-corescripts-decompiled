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
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagCollectionViewMathChanges = SharedFlags.FFlagCollectionViewMathChanges
local FFlagLuaAppEnableVRCarouselScrolling = SharedFlags.FFlagLuaAppEnableVRCarouselScrolling
local FFlagLuaAppFixCarouselPeekInControl = SharedFlags.FFlagLuaAppFixCarouselPeekInControl
local FFlagLuaAppHideCarouselSubtitleChevron = SharedFlags.FFlagLuaAppHideCarouselSubtitleChevron
local v30 = t.strictInterface({
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

local function isScrollingEnabled(b1: boolean?, b2: boolean?) -- line: 222
	-- upvalues: FFlagLuaAppEnableVRCarouselScrolling (copy)
	if b1 ~= nil then
		return b1
	end

	if FFlagLuaAppEnableVRCarouselScrolling then
		return true
	end

	return not b2
end
local function areScrollButtonsEnabled(s1: string, _: string, b3: boolean, b4: boolean?, b5: boolean) -- line: 235
	-- upvalues: Responsive (copy), FFlagLuaAppEnableVRCarouselScrolling (copy)
	if not b3 then
		return false
	end

	if b4 ~= nil then
		return b4
	end

	return s1 == Responsive.Input.Pointer or FFlagLuaAppEnableVRCarouselScrolling and b5
end
local function CollectionCarousel(t2: {[any]: any}) -- line: 255
	-- upvalues: validateProps (copy), v30 (copy), Cryo (copy), t1 (copy), useCollectionLayout (copy), FFlagLuaAppFixCarouselPeekInControl (copy), ArgCheck (copy), React (copy), FFlagCollectionViewMathChanges (copy), useLastInput (copy), usePreferredInput (copy), useIsSpatial (copy), Responsive (copy), FFlagLuaAppEnableVRCarouselScrolling (copy), useCollectionSizeBindings (copy), calculateCarouselSpacingMetrics (copy), useScrollButtonHandlers (copy), useCarouselScrollingBinding (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ScrollingRowOfCollectionItems (copy), CollectionBackgroundMural (copy), maybeForceDarkTheme (copy), CollectionHeader (copy), FFlagLuaAppHideCarouselSubtitleChevron (copy), CompositionTags (copy), CarouselScrollButtons (copy)
	validateProps(v30, t2)

	local v43 = Cryo.Dictionary.join(t1, t2)
	local sideMargin = v43.sideMargin
	local v45 = useCollectionLayout(t2.collectionItemSize)
	local v46 = t2.numColumns or v45.itemsPerRow
	local v47 = t2.columnGap or v45.gutter
	local v48 = if not FFlagLuaAppFixCarouselPeekInControl then v45.carouselPeek or 0 else if not t2.collectionItemSize then nil else v45.carouselPeek or 0

	ArgCheck.assert(v46 >= 1)
	ArgCheck.assert(sideMargin >= 0)
	ArgCheck.assert(v43.fractionalItemAmount >= 0)
	ArgCheck.assert(v47 >= 0)

	local v49 = React.useRef(nil)
	local u50 = nil
	local u51 = nil
	local v52 = nil

	if FFlagCollectionViewMathChanges then
		local v53, v54 = React.useBinding(0)

		u50 = v53
		u51 = v54
		v52 = React.useCallback(function(p1) -- line: 279
			-- upvalues: u51 (ref)
			if p1 then
				u51(p1.AbsoluteSize.X)
			end
		end, {})
	end

	local v55 = React.useCallback(function(p2) -- line: 286
		-- upvalues: v49 (copy), FFlagCollectionViewMathChanges (copy), u51 (ref), v43 (copy)
		v49.current = p2

		if FFlagCollectionViewMathChanges and p2 then
			u51(p2.AbsoluteSize.X)
		end

		if v43.onScrollingFrameRefCallback then
			v43.onScrollingFrameRefCallback(p2)
		end

		if v43.scrollingFrameRef then
			v43.scrollingFrameRef.current = p2
		end
	end, {
		v43.onScrollingFrameRefCallback,
		v43.scrollingFrameRef
	})
	local v56 = useLastInput()
	local v57 = usePreferredInput()
	local v58 = useIsSpatial()
	local v59 = v43.hideHeaderButton or v57 == Responsive.Input.Directional
	local scrollingEnabledOverride = v43.scrollingEnabledOverride
	local v61 = if scrollingEnabledOverride == nil then not not FFlagLuaAppEnableVRCarouselScrolling or not v58 else scrollingEnabledOverride
	local v62 = math.min(v43.maxItemsToShow or #v43.items, #v43.items)

	if not v61 then
		v62 = math.min(v46, v62)
	end

	ArgCheck.assert(v62 >= 0)

	local v63 = (not v61 or not (v46 < v62)) and 0 or v43.fractionalItemAmount
	local v64, v65, v66, v67 = useCollectionSizeBindings(v46, v47, sideMargin, v63, v43.getItemHeight, v43.onContainerSizeChanged, v48)
	local v68 = nil

	if FFlagCollectionViewMathChanges then
		v68 = React.useMemo(function() -- line: 338
			-- upvalues: React (copy), u50 (ref), v64 (copy), calculateCarouselSpacingMetrics (copy), v46 (copy), v47 (copy), v48 (copy), v63 (copy)
			return React.joinBindings({
				u50,
				v64
			}):map(function(p3) -- line: 339
				-- upvalues: calculateCarouselSpacingMetrics (copy), v46 (copy), v47 (copy), v48 (copy), v63 (copy)
				return calculateCarouselSpacingMetrics(p3[1], v46, v47, v48 or 0, v63, p3[2].X)
			end)
		end, {
			u50,
			v64,
			v46,
			v47,
			v48,
			v63
		})
	end

	local shouldShowScrollButtonsOverride = v43.shouldShowScrollButtonsOverride
	local v70 = if not FFlagLuaAppEnableVRCarouselScrolling then nil else v58
	local v71 = if v61 then if shouldShowScrollButtonsOverride == nil then v56 == Responsive.Input.Pointer or FFlagLuaAppEnableVRCarouselScrolling and v70 else shouldShowScrollButtonsOverride else false
	local v72, v73, v74, v75 = useScrollButtonHandlers(v49, v62, v71, v46, if not FFlagCollectionViewMathChanges then v64 else nil, if not FFlagCollectionViewMathChanges then v47 else nil, nil, if not FFlagCollectionViewMathChanges then nil else v68)
	local v76 = useCarouselScrollingBinding(v49, v43.enableHoverOverflow == true)
	local v77 = v47 * 0.5
	local v78 = React.useMemo(function() -- line: 377
		-- upvalues: v43 (copy), React (copy), v64 (copy), v76 (copy), v77 (copy)
		if not v43.enableHoverOverflow then
			return nil
		end

		return React.joinBindings({
			v64,
			v76
		}):map(function(p4) -- line: 381
			-- upvalues: v77 (copy)
			local v94 = p4[1]
			local v95 = p4[2]

			return UDim2.new(1, if not v95 then -v77 * 2 else 0, 0, v94.Y)
		end)
	end, {
		v64,
		v76,
		v77,
		v43.enableHoverOverflow
	})
	local v79 = React.useMemo(function() -- line: 387
		-- upvalues: v43 (copy), v76 (copy), v77 (copy)
		if not v43.enableHoverOverflow then
			return nil
		end

		return v76:map(function(p5) -- line: 391
			-- upvalues: v77 (copy)
			return UDim2.new(0, if not p5 then v77 else 0, 0, 500)
		end)
	end, {
		v76,
		v77,
		v43.enableHoverOverflow
	})
	local v80 = useDesignTokens()
	local v81 = if not FFlagRenameDeprecatedUIBloxTokens then v80.Global.Size_200 else v80.Size.Size_400
	local v82 = if not FFlagRenameDeprecatedUIBloxTokens then v80.Global.Size_250 else v80.Size.Size_500
	local v83 = if not FFlagRenameDeprecatedUIBloxTokens then v80.Global.Color.White else v80.Color.Extended.White.White_100
	local v84 = v43.backgroundMuralUrl ~= nil
	local v85 = v43.title and v43.title ~= ""
	local v86 = React.createElement(ScrollingRowOfCollectionItems, {
		Position = v79,
		Size = v78,
		ScrollingEnabled = v61,
		onChangeCanvasPosition = v43.onChangeCanvasPosition,
		onScrollingFrameRefCallback = v55,
		itemSizeBinding = v64,
		items = v43.items,
		totalItemsOnCanvas = v62,
		numColumns = v46,
		columnGap = v47,
		renderItem = v43.renderItem,
		sideMargin = sideMargin,
		numItemsToRenderOffScreen = v43.numItemsToRenderOffScreen,
		onReachedThresholdFromEnd = v43.onReachedThresholdFromEnd,
		thresholdFromEnd = v43.thresholdFromEnd,
		onViewableItemsChanged = v43.onViewableItemsChanged,
		AutomaticSize = v43.AutomaticSize,
		spacingMetricsBinding = if not FFlagCollectionViewMathChanges then nil else v68,
		onScrollingFrameAbsoluteSizeChanged = if not FFlagCollectionViewMathChanges then nil else v52
	})

	return React.createElement("Frame", {
		ref = v43.containerRef,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = v43.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v43.LayoutOrder,
		[React.Tag] = if not v43.testId then nil else `data-testid={ v43.testId }`
	}, {
		BackgroundMural = v43.backgroundMuralUrl and React.createElement(CollectionBackgroundMural, {
			ZIndex = -1,
			backgroundMuralUrl = v43.backgroundMuralUrl,
			containerSizeBinding = v65
		}) or nil,
		CollectionContent = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v66,
			ref = v67
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = if v43.backgroundMuralUrl == nil then nil else UDim.new(0, v82),
				PaddingLeft = if not (sideMargin > 0) then nil else UDim.new(0, sideMargin),
				PaddingRight = if not (sideMargin > 0) then nil else UDim.new(0, sideMargin)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, not v85 and not v43.headerComponent and 0 or v81)
			}),
			CollectionHeader = if not v43.headerComponent then maybeForceDarkTheme(React.createElement(CollectionHeader, {
				LayoutOrder = 1,
				title = v43.title,
				subtitle = v43.subtitle,
				tooltipInfoText = v43.tooltipInfoText,
				onActivateInfoIcon = v43.onActivateInfoIcon,
				tooltipSupportsVR = v43.tooltipSupportsVR,
				tooltipSupportsTenFootUi = v43.tooltipSupportsTenFootUi,
				hideButton = #v43.items < 1 or (v59 or not v85),
				onActivate = v43.onActivateHeader,
				onActivateSubtitle = v43.onActivateSubtitle,
				buttonText = v43.headerButtonText,
				titleColor = if not v84 then nil else v83,
				subtitleColor = if not v84 then nil else v83,
				hideSubtitleChevron = if not FFlagLuaAppHideCarouselSubtitleChevron then nil else v43.hideSubtitleChevron
			}), v84) else v43.headerComponent,
			Items = React.createElement("Frame", {
				Size = if not v43.enableHoverOverflow then UDim2.new(1, 0, 0, 0) else v64:map(function(vector2: Vector2) -- line: 496
					return UDim2.new(1, 0, 0, vector2.Y)
				end),
				AutomaticSize = if v43.enableHoverOverflow then nil else Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				[React.Tag] = if not v43.collectionItemSize or v43.enableHoverOverflow then nil else CompositionTags.Utility.ClipAtMaxWidth
			}, {
				CarouselClip = if not v43.enableHoverOverflow then nil else React.createElement("Frame", {
					Size = v76:map(function(p6) -- line: 510
						-- upvalues: v77 (copy)
						return UDim2.new(1, if not p6 then v77 * 2 else 0, 1, 1000)
					end),
					Position = v76:map(function(p7) -- line: 518
						-- upvalues: v77 (copy)
						return UDim2.new(0, if not p7 then -v77 else 0, 0, -500)
					end),
					BackgroundTransparency = 1,
					[React.Tag] = if not v43.collectionItemSize then nil else CompositionTags.Utility.ClipAtMaxWidth
				}, {
					ScrollingItems = v86
				}),
				ScrollingItems = if v43.enableHoverOverflow then nil else v86,
				ScrollButtons = if not v71 then nil else React.createElement(CarouselScrollButtons, {
					ZIndex = 10,
					handleScrollLeft = v72,
					handleScrollRight = v73,
					leftScrollingEnabled = v74,
					rightScrollingEnabled = v75,
					Size = UDim2.new(1, 2 * sideMargin, 1, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0),
					buttonOffsetFromEdge = if not FFlagRenameDeprecatedUIBloxTokens then v80.Global.Size_100 else v80.Size.Size_200,
					onScrollButtonEnter = v43.onScrollButtonEnter,
					onScrollButtonLeave = v43.onScrollButtonLeave
				})
			})
		})
	})
end

return (React.memo(CollectionCarousel))
