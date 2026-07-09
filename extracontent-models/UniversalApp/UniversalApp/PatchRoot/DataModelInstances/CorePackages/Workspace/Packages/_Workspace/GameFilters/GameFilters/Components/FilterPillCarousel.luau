local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent
local Cryo = require(GameFiltersParent.Cryo)

require(GameFiltersParent.DiscoveryTypes)

local React = require(GameFiltersParent.React)
local ScreenSizeImpressionsTracker = require(GameFiltersParent.Impressions).ScreenSizeImpressionsTracker
local FrameBoundsImpressionsTracker = require(GameFiltersParent.Impressions).FrameBoundsImpressionsTracker
local VariableItemWidthCarousel = require(GameFiltersParent.VariableItemWidthCarousel).VariableItemWidthCarousel
local useCollectionImpressionsSignal = require(GameFiltersParent.CollectionViews).useCollectionImpressionsSignal
local useTokens = require(GameFiltersParent.Foundation).Hooks.useTokens
local FilterPill = require(GameFilters.Components.FilterPill)
local FFlagLuaAppUseFrameBoundsImpressions = require(GameFiltersParent.SharedFlags).FFlagLuaAppUseFrameBoundsImpressions
local FFlagLuaAppHideEmptyCarouselHeader = require(GameFiltersParent.SharedFlags).FFlagLuaAppHideEmptyCarouselHeader

require(GameFilters.FilterCallbackTypes)

return function(t1: {[any]: any}) -- line: 40
	-- upvalues: useTokens (copy), React (copy), useCollectionImpressionsSignal (copy), FFlagLuaAppHideEmptyCarouselHeader (copy), FilterPill (copy), Cryo (copy), VariableItemWidthCarousel (copy), FFlagLuaAppUseFrameBoundsImpressions (copy), FrameBoundsImpressionsTracker (copy), ScreenSizeImpressionsTracker (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState({})
	local v17 = React.useRef(nil)
	local v18 = "FilterPillCarousel_" .. t1.sortIndex
	local v19, v20 = useCollectionImpressionsSignal(t1.scrollViewPositionChangedSignal)
	local sendImpressions = t1.sendImpressions
	local v22 = not FFlagLuaAppHideEmptyCarouselHeader and not t1.title and "" or React.useCallback(function() -- line: 59
		-- upvalues: v14 (copy), React (copy), t1 (copy)
		local BodyMedium = v14.Typography.BodyMedium
		local Muted = v14.Color.Content.Muted

		return React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			LayoutOrder = 1,
			Text = t1.title,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = BodyMedium.Font,
			TextSize = BodyMedium.FontSize,
			TextTransparency = Muted.Transparency,
			TextColor3 = Muted.Color3,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	end, {
		t1.title,
		v14
	})
	local v23 = if not FFlagLuaAppHideEmptyCarouselHeader or not not t1.title and t1.title ~= "" then v22 else ""
	local v24 = React.useCallback(function(p1, n1: number) -- line: 84
		-- upvalues: React (copy), FilterPill (copy), t1 (copy), v18 (copy), v16 (copy), Cryo (copy), v15 (copy)
		return React.createElement(FilterPill, {
			analyticsInfo = t1.analyticsInfo,
			filter = p1,
			impressionsTag = v18,
			index = n1,
			onFilterApplied = t1.onFilterApplied,
			onAbsoluteSizeChanged = function(p2) -- line: 91
				-- upvalues: v16 (copy), Cryo (copy), v15 (copy), n1 (copy)
				if p2 then
					v16(Cryo.Dictionary.join(v15, {
						[n1] = p2.AbsoluteSize.X
					}))
				end
			end,
			pageContext = t1.pageContext,
			sendFilterClick = t1.sendFilterClick
		})
	end, {
		t1.analyticsInfo,
		v18,
		t1.onFilterApplied,
		v15,
		t1.pageContext,
		t1.sendFilterClick
	})
	local v25 = React.useCallback(function(n2: number) -- line: 110
		-- upvalues: v15 (copy)
		return v15[n2] or 0
	end, { v15 })

	return React.createElement(React.Fragment, nil, {
		FilterCarousel = React.createElement(VariableItemWidthCarousel, {
			scrollButtonEnabled = true,
			title = v23,
			items = t1.filters,
			renderItem = v24,
			onCanvasPositionChanged = v20,
			calculateItemWidth = v25,
			itemHeight = v14.Size.Size_800,
			headerContentPadding = v14.Padding.XSmall,
			itemPadding = v14.Padding.XSmall,
			sideMargin = t1.sideMargin,
			LayoutOrder = t1.sortIndex,
			scrollingFrameRef = v17,
			ref = t1.containerRef
		}),
		ImpressionsTracker = React.createElement(if not FFlagLuaAppUseFrameBoundsImpressions then ScreenSizeImpressionsTracker else FrameBoundsImpressionsTracker, {
			impressionsTag = v18,
			pageContext = t1.pageContext,
			parentRef = v17,
			scrollViewPositionChangedSignal = v19,
			sendImpressions = sendImpressions,
			dataUpdatedTimestamp = t1.dataUpdatedTimestamp
		})
	})
end
