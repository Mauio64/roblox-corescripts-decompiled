local variableItemWidthCarousel = script:FindFirstAncestor("VariableItemWidthCarousel")
local parent = variableItemWidthCarousel.Parent

local CollectionViews = require(parent.CollectionViews)
local React = require(parent.React)

local CarouselScrollButtons = CollectionViews.CarouselScrollButtons
local CollectionHeader = CollectionViews.CollectionHeader
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Responsive = require(parent.Responsive)
local useLastInput = Responsive.useLastInput
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local useVariableItemWidthScrollHandlers = require(variableItemWidthCarousel.useVariableItemWidthScrollHandlers)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiOptionSelectorHeaderComponent = SharedFlags.FFlagSduiOptionSelectorHeaderComponent
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags2.FFlagSduiComponentsUseFoundationTokens

local function areScrollButtonsEnabled(p: string, p2: string, flag: boolean, flag2: boolean)
	if not flag then
		return false
	end

	return p == Responsive.Input.Pointer and p2 ~= Responsive.Input.Directional or flag2
end

function VariableItemWidthCarousel(props, ref)
	local v

	if FFlagSduiComponentsUseFoundationTokens then
		v = useTokens()
	else
		v = useDesignTokens()
	end

	local v2 = useLastInput()
	local v3 = usePreferredInput()
	local v4 = useIsSpatial()

	local items = props.items
	local renderItem = props.renderItem
	local itemPadding = props.itemPadding
	local itemHeight = props.itemHeight
	local sideMargin = props.sideMargin or 0
	local calculateItemWidth = props.calculateItemWidth
	local scrollingFrameRef = props.scrollingFrameRef
	local v5 = props.title and props.title ~= ""
	local v6 = v5 or props.subtitle ~= nil or props.tooltipInfoText ~= nil
	local v7 = props.scrollButtonsEnabled

	if v7 then
		if v2 == Responsive.Input.Pointer then
			v7 = v3 ~= Responsive.Input.Directional or v4
		else
			v7 = v4
		end
	end

	local v8 = React.useMemo(function()
		local result = {}

		for i, item in ipairs(items) do
			result[i] = renderItem(item, i)
		end

		return result
	end, { items, renderItem })

	local handleScrollLeft, handleScrollRight, leftScrollingEnabled, rightScrollingEnabled, v9 = useVariableItemWidthScrollHandlers(
		items,
		itemPadding,
		calculateItemWidth,
		scrollingFrameRef,
		props.scrollSpeed
	)

	local v10 = React.useCallback(function(p)
		v9()

		if props.onCanvasPositionChanged and p then
			props.onCanvasPositionChanged(p.CanvasPosition)
		end
	end, { v9, props.onCanvasPositionChanged })

	local createElement = React.createElement
	local v11 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = props.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		ref = ref
	}

	local v12 = {
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
				not v6 and (not FFlagSduiOptionSelectorHeaderComponent or props.headerComponent == nil) and 0 or props.headerContentPadding or v.Size.Size_400
			)
		}),
		Header = 0,
		ContentFrame = 0
	}
	local header

	if FFlagSduiOptionSelectorHeaderComponent and props.headerComponent then
		header = props.headerComponent
	elseif v6 then
		header = React.createElement(CollectionHeader, {
			LayoutOrder = 1,
			title = props.title,
			subtitle = props.subtitle,
			tooltipInfoText = props.tooltipInfoText,
			onActivateInfoIcon = props.onActivateInfoIcon,
			tooltipSupportsVR = props.tooltipSupportsVR,
			tooltipSupportsTenFootUi = props.tooltipSupportsTenFootUi,
			hideButton = #items < 1 or (props.hideHeaderButton or not v5),
			onActivate = props.onActivateHeader,
			buttonText = props.headerButtonText
		})
	end

	v12.Header = header

	local createElement2 = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, itemHeight)
	}
	local v14 = {
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
			[React.Change.AbsoluteSize] = v9,
			[React.Change.CanvasPosition] = v10
		}, { React.createElement(React.Fragment, nil, {
				React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, itemPadding),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				React.createElement(React.Fragment, nil, v8)
			}) }),
		ScrollButtons = 0
	}
	local scrollButtons

	if v7 then
		scrollButtons = React.createElement(CarouselScrollButtons, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 2 * sideMargin, 0, itemHeight),
			ZIndex = 2,
			buttonOffsetFromEdge = v.Size.Size_200,
			handleScrollLeft = handleScrollLeft,
			handleScrollRight = handleScrollRight,
			leftScrollingEnabled = leftScrollingEnabled,
			rightScrollingEnabled = rightScrollingEnabled
		})
	end

	v14.ScrollButtons = scrollButtons
	v12.ContentFrame = createElement2("Frame", v13, v14)
	return createElement("Frame", v11, v12)
end

return React.forwardRef(VariableItemWidthCarousel)
