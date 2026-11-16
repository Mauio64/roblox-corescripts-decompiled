local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/React")
local screenSizeImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Impressions").ScreenSizeImpressionsTracker
local frameBoundsImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Impressions").FrameBoundsImpressionsTracker
local variableItemWidthCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/VariableItemWidthCarousel").VariableItemWidthCarousel

local useCollectionImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/CollectionViews").useCollectionImpressionsSignal
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FilterPill = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Components/FilterPill")
local fFlagLuaAppUseFrameBoundsImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppUseFrameBoundsImpressions
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/FilterCallbackTypes")

return function(props)
	local v5 = useTokens()

	local state, setState = React.useState({})

	local ref = React.useRef(nil)

	local v6 = "FilterPillCarousel_" .. props.sortIndex

	local v7, v8 = useCollectionImpressionsSignal(props.scrollViewPositionChangedSignal)

	local sendImpressions = props.sendImpressions

	local v9 = React.useCallback(function()
		local bodyMedium = v5.Typography.BodyMedium
		local muted = v5.Color.Content.Muted

		local createElement = React.createElement
		local v11 = {
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
		local v12 = if not foundationFontFaceMigration then bodyMedium.Font else nil
		v11.Font = v12
		local v13 = if foundationFontFaceMigration then normalizeFontFace(bodyMedium.Font) else nil
		v11.FontFace = v13
		v11.TextSize = bodyMedium.FontSize
		v11.TextTransparency = muted.Transparency
		v11.TextColor3 = muted.Color3

		v11.TextTruncate = Enum.TextTruncate.SplitWord
		v11.TextXAlignment = Enum.TextXAlignment.Left
		return createElement("TextLabel", v11)
	end, { props.title, v5 })

	local v10 = (not props.title or props.title == "") and "" or v9

	local v11 = React.useCallback(function(p2, p3)
		return React.createElement(FilterPill, {
			analyticsInfo = props.analyticsInfo,
			filter = p2,
			impressionsTag = v6,
			index = p3,
			onFilterApplied = props.onFilterApplied,
			onAbsoluteSizeChanged = function(p4)
				if p4 then
					setState(Cryo.Dictionary.join(state, { [p3] = p4.AbsoluteSize.X }))
				end
			end,
			pageContext = props.pageContext,
			sendFilterClick = props.sendFilterClick
		})
	end, {
		props.analyticsInfo,
		v6,
		props.onFilterApplied,
		state,
		props.pageContext,
		props.sendFilterClick
	})

	local v12 = React.useCallback(function(p2)
		return state[p2] or 0
	end, { state })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v14 = {
		FilterCarousel = React.createElement(variableItemWidthCarousel, {
			title = v10,
			items = props.filters,
			renderItem = v11,
			onCanvasPositionChanged = v8,
			calculateItemWidth = v12,
			itemHeight = v5.Size.Size_800,
			headerContentPadding = v5.Padding.XSmall,
			itemPadding = v5.Padding.XSmall,
			sideMargin = props.sideMargin,
			LayoutOrder = props.sortIndex,
			scrollButtonEnabled = true,
			scrollingFrameRef = ref,
			ref = props.containerRef
		}),
		ImpressionsTracker = 0
	}

	local createElement2 = React.createElement
	local v15

	if fFlagLuaAppUseFrameBoundsImpressions then
		v15 = frameBoundsImpressionsTracker
	else
		v15 = screenSizeImpressionsTracker
	end

	v14.ImpressionsTracker = createElement2(v15, {
		impressionsTag = v6,
		pageContext = props.pageContext,
		parentRef = ref,
		scrollViewPositionChangedSignal = v7,
		sendImpressions = sendImpressions,
		dataUpdatedTimestamp = props.dataUpdatedTimestamp
	})
	return createElement(fragment, nil, v14)
end
