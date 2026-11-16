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
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

		local createElement = React.createElement
		local v2 = {
			BackgroundTransparency = 1,
			Text = props.title,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = false,
			TextTruncate = 0,
			TextXAlignment = 0,
			LayoutOrder = 1
		}
		local font

		if not FoundationFontFaceMigration then
			font = bodyMedium.Font
		end

		v2.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(bodyMedium.Font)
		end

		v2.FontFace = fontFace
		v2.TextSize = bodyMedium.FontSize
		v2.TextTransparency = muted.Transparency
		v2.TextColor3 = muted.Color3

		v2.TextTruncate = Enum.TextTruncate.SplitWord
		v2.TextXAlignment = Enum.TextXAlignment.Left
		return createElement("TextLabel", v2)
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
