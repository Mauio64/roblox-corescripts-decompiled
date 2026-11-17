local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
local Cryo = require(parent.Cryo)
require(parent.DiscoveryTypes)
local React = require(parent.React)
local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local Impressions2 = require(parent.Impressions)
local FrameBoundsImpressionsTracker = Impressions2.FrameBoundsImpressionsTracker
local VariableItemWidthCarousel = require(parent.VariableItemWidthCarousel)
local variableItemWidthCarousel = VariableItemWidthCarousel.VariableItemWidthCarousel

local CollectionViews = require(parent.CollectionViews)
local useCollectionImpressionsSignal = CollectionViews.useCollectionImpressionsSignal
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FilterPill = require(GameFilters.Components.FilterPill)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUseFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseFrameBoundsImpressions

require(GameFilters.FilterCallbackTypes)

return function(props)
	local v = useTokens()

	local state, setState = React.useState({})

	local ref = React.useRef(nil)

	local impressionsTag = "FilterPillCarousel_" .. props.sortIndex

	local scrollViewPositionChangedSignal, onCanvasPositionChanged = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local sendImpressions = props.sendImpressions

	local v2 = React.useCallback(function()
		local bodyMedium = v.Typography.BodyMedium
		local muted = v.Color.Content.Muted

		return React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = props.title,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = normalizeFontFace(bodyMedium.Font),
			TextSize = bodyMedium.FontSize,
			TextTransparency = muted.Transparency,
			TextColor3 = muted.Color3,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1
		})
	end, { props.title, v })

	local title = (not props.title or props.title == "") and "" or v2

	local renderItem = React.useCallback(function(filter, p: number)
		return React.createElement(FilterPill, {
			analyticsInfo = props.analyticsInfo,
			filter = filter,
			impressionsTag = impressionsTag,
			index = p,
			onFilterApplied = props.onFilterApplied,
			onAbsoluteSizeChanged = function(p2)
				if p2 then
					setState(Cryo.Dictionary.join(state, { [p] = p2.AbsoluteSize.X }))
				end
			end,
			pageContext = props.pageContext,
			sendFilterClick = props.sendFilterClick
		})
	end, {
		props.analyticsInfo,
		impressionsTag,
		props.onFilterApplied,
		state,
		props.pageContext,
		props.sendFilterClick
	})

	local calculateItemWidth = React.useCallback(function(p: number)
		return state[p] or 0
	end, { state })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v3 = {
		FilterCarousel = React.createElement(variableItemWidthCarousel, {
			title = title,
			items = props.filters,
			renderItem = renderItem,
			onCanvasPositionChanged = onCanvasPositionChanged,
			calculateItemWidth = calculateItemWidth,
			itemHeight = v.Size.Size_800,
			headerContentPadding = v.Padding.XSmall,
			itemPadding = v.Padding.XSmall,
			sideMargin = props.sideMargin,
			LayoutOrder = props.sortIndex,
			scrollButtonEnabled = true,
			scrollingFrameRef = ref,
			ref = props.containerRef
		}),
		ImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v4

	if FFlagLuaAppUseFrameBoundsImpressions then
		v4 = FrameBoundsImpressionsTracker
	else
		v4 = ScreenSizeImpressionsTracker
	end

	v3.ImpressionsTracker = createElement2(v4, {
		impressionsTag = impressionsTag,
		pageContext = props.pageContext,
		parentRef = ref,
		scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
		sendImpressions = sendImpressions,
		dataUpdatedTimestamp = props.dataUpdatedTimestamp
	})
	return createElement(fragment, nil, v3)
end
