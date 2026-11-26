local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/CollectionViews")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/React")

local carouselScrollButtons = CollectionViews.CarouselScrollButtons
local collectionHeader = CollectionViews.CollectionHeader
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/Foundation").Hooks.useTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/Responsive")
local useLastInput = Responsive.useLastInput
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local useVariableItemWidthScrollHandlers = require("@game/CorePackages/Workspace/Packages/_Index/VariableItemWidthCarousel/VariableItemWidthCarousel/useVariableItemWidthScrollHandlers")
local fFlagSduiOptionSelectorHeaderComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/SharedFlags").FFlagSduiOptionSelectorHeaderComponent
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/VariableItemWidthCarousel/SharedFlags").FFlagSduiComponentsUseFoundationTokens

local function areScrollButtonsEnabled(p2, p3, p4, p5)
	if not p4 then
		return false
	end

	return p2 == Responsive.Input.Pointer and p3 ~= Responsive.Input.Directional or p5
end

function LUAUFORGE_MODULE_GLOBALS_cUJ_VariableItemWidthCarousel(props, p2)
	local v5 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()
	local v6 = useLastInput()
	local v7 = usePreferredInput()
	local v8 = useIsSpatial()

	local items = props.items
	local renderItem = props.renderItem
	local itemPadding = props.itemPadding
	local itemHeight = props.itemHeight
	local sideMargin = props.sideMargin or 0
	local calculateItemWidth = props.calculateItemWidth
	local scrollingFrameRef = props.scrollingFrameRef
	local v9 = props.title and props.title ~= ""
	local v10 = v9 or props.subtitle ~= nil or props.tooltipInfoText ~= nil
	local v11 = props.scrollButtonsEnabled

	if v11 then
		v11 = if v6 == Responsive.Input.Pointer then v7 ~= Responsive.Input.Directional or v8 else v8
	end

	local v12 = React.useMemo(function()
		local result = {}

		for i, item in ipairs(items) do
			result[i] = renderItem(item, i)
		end

		return result
	end, { items, renderItem })

	local v13, v14, v15, v16, v17 = useVariableItemWidthScrollHandlers(
		items,
		itemPadding,
		calculateItemWidth,
		scrollingFrameRef,
		props.scrollSpeed
	)

	local v18 = React.useCallback(function(p3)
		v17()

		if props.onCanvasPositionChanged and p3 then
			props.onCanvasPositionChanged(p3.CanvasPosition)
		end
	end, { v17, props.onCanvasPositionChanged })

	local createElement = React.createElement
	local v20 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = props.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		ref = p2
	}

	local v21 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(
				0,
				not v10 and (not fFlagSduiOptionSelectorHeaderComponent or props.headerComponent == nil) and 0 or props.headerContentPadding or v5.Size.Size_400
			)
		}),
		Header = 0,
		ContentFrame = 0
	}
	local v22

	if fFlagSduiOptionSelectorHeaderComponent and props.headerComponent then
		v22 = props.headerComponent
	elseif v10 then
		v22 = React.createElement(collectionHeader, {
			LayoutOrder = 1,
			title = props.title,
			subtitle = props.subtitle,
			tooltipInfoText = props.tooltipInfoText,
			onActivateInfoIcon = props.onActivateInfoIcon,
			tooltipSupportsVR = props.tooltipSupportsVR,
			tooltipSupportsTenFootUi = props.tooltipSupportsTenFootUi,
			hideButton = #items < 1 or (props.hideHeaderButton or not v9),
			onActivate = props.onActivateHeader,
			buttonText = props.headerButtonText
		})
	end

	v21.Header = v22

	local createElement2 = React.createElement
	local v24 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, itemHeight)
	}
	local v25 = {
		DynamicScrollingFrame = React.createElement("ScrollingFrame", {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			CanvasSize = UDim2.new(0, 0, 0, itemHeight),
			ClipsDescendants = false,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			Selectable = false,
			Size = UDim2.new(1, 0, 0, itemHeight),
			ZIndex = 1,
			ref = scrollingFrameRef,
			[React.Change.AbsoluteSize] = v17,
			[React.Change.CanvasPosition] = v18
		}, { React.createElement(React.Fragment, nil, {
				React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, itemPadding),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				React.createElement(React.Fragment, nil, v12)
			}) }),
		ScrollButtons = 0
	}

	local v27 = if v11 then React.createElement(carouselScrollButtons, {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 2 * sideMargin, 0, itemHeight),
		ZIndex = 2,
		buttonOffsetFromEdge = v5.Size.Size_200,
		handleScrollLeft = v13,
		handleScrollRight = v14,
		leftScrollingEnabled = v15,
		rightScrollingEnabled = v16
	}) else nil
	v25.ScrollButtons = v27
	v21.ContentFrame = createElement2("Frame", v24, v25)
	return createElement("Frame", v20, v21)
end

return React.forwardRef(LUAUFORGE_MODULE_GLOBALS_cUJ_VariableItemWidthCarousel)
