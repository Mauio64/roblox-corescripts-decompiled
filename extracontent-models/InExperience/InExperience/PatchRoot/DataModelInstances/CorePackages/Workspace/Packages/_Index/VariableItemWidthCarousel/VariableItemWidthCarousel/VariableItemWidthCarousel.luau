local VariableItemWidthCarousel2 = script:FindFirstAncestor("VariableItemWidthCarousel")
local VariableItemWidthCarousel2Parent = VariableItemWidthCarousel2.Parent
local CollectionViews = require(VariableItemWidthCarousel2Parent.CollectionViews)
local React = require(VariableItemWidthCarousel2Parent.React)
local CarouselScrollButtons = CollectionViews.CarouselScrollButtons
local CollectionHeader = CollectionViews.CollectionHeader
local useDesignTokens = require(VariableItemWidthCarousel2Parent.Style).useDesignTokens
local Responsive = require(VariableItemWidthCarousel2Parent.Responsive)
local useLastInput = Responsive.useLastInput
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local useVariableItemWidthScrollHandlers = require(VariableItemWidthCarousel2.useVariableItemWidthScrollHandlers)
local FFlagLuaAppEnableVRCarouselScrolling = require(VariableItemWidthCarousel2Parent.SharedFlags).FFlagLuaAppEnableVRCarouselScrolling
local FFlagLuaAppHideEmptyCarouselHeader = require(VariableItemWidthCarousel2Parent.SharedFlags).FFlagLuaAppHideEmptyCarouselHeader

local function areScrollButtonsEnabled(s1: string, s2: string, b1: boolean, b2: boolean) -- line: 50
	-- upvalues: Responsive (copy), FFlagLuaAppEnableVRCarouselScrolling (copy)
	if not b1 then
		return false
	end

	return s1 == Responsive.Input.Pointer and s2 ~= Responsive.Input.Directional or FFlagLuaAppEnableVRCarouselScrolling and b2
end

function VariableItemWidthCarousel(t1: {[any]: any}, p1) -- line: 68
	-- upvalues: useDesignTokens (copy), useLastInput (copy), usePreferredInput (copy), useIsSpatial (copy), FFlagLuaAppHideEmptyCarouselHeader (copy), FFlagLuaAppEnableVRCarouselScrolling (copy), Responsive (copy), React (copy), useVariableItemWidthScrollHandlers (copy), CollectionHeader (copy), CarouselScrollButtons (copy)
	local v22 = useDesignTokens()
	local v23 = useLastInput()
	local v24 = usePreferredInput()
	local v25 = useIsSpatial()
	local items = t1.items
	local renderItem = t1.renderItem
	local itemPadding = t1.itemPadding
	local itemHeight = t1.itemHeight
	local v30 = t1.sideMargin or 0
	local calculateItemWidth = t1.calculateItemWidth
	local scrollingFrameRef = t1.scrollingFrameRef
	local v33 = t1.title and t1.title ~= ""
	local v34 = not FFlagLuaAppHideEmptyCarouselHeader or (v33 or (t1.subtitle ~= nil or t1.tooltipInfoText ~= nil))
	local scrollButtonsEnabled = t1.scrollButtonsEnabled

	if scrollButtonsEnabled then
		local v36 = not not FFlagLuaAppEnableVRCarouselScrolling or not v25
		local v37 = if not FFlagLuaAppEnableVRCarouselScrolling then nil else v25

		scrollButtonsEnabled = if v36 then v23 == Responsive.Input.Pointer and v24 ~= Responsive.Input.Directional or FFlagLuaAppEnableVRCarouselScrolling and v37 else false
	end

	local v38 = React.useMemo(function() -- line: 93
		-- upvalues: items (copy), renderItem (copy)
		local t2 = {}

		for i, v in ipairs(items) do
			t2[i] = renderItem(v, i)
		end

		return t2
	end, {
		items,
		renderItem
	})
	local v39, v40, v41, v42, v43 = useVariableItemWidthScrollHandlers(items, itemPadding, calculateItemWidth, scrollingFrameRef, t1.scrollSpeed)
	local v44 = React.useCallback(function(p2) -- line: 105
		-- upvalues: v43 (copy), t1 (copy)
		v43()

		if t1.onCanvasPositionChanged and p2 then
			t1.onCanvasPositionChanged(p2.CanvasPosition)
		end
	end, {
		v43,
		t1.onCanvasPositionChanged
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder,
		ref = p1
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v30),
			PaddingRight = UDim.new(0, v30)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, not (if not FFlagLuaAppHideEmptyCarouselHeader then v33 else v34) and 0 or (t1.headerContentPadding or v22.Size.Size_400))
		}),
		Header = if not v34 then nil else React.createElement(CollectionHeader, {
			LayoutOrder = 1,
			title = t1.title,
			subtitle = t1.subtitle,
			tooltipInfoText = t1.tooltipInfoText,
			onActivateInfoIcon = t1.onActivateInfoIcon,
			tooltipSupportsVR = t1.tooltipSupportsVR,
			tooltipSupportsTenFootUi = t1.tooltipSupportsTenFootUi,
			hideButton = #items < 1 or (t1.hideHeaderButton or not v33),
			onActivate = t1.onActivateHeader,
			buttonText = t1.headerButtonText
		}),
		ContentFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, itemHeight)
		}, {
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
				[React.Change.AbsoluteSize] = v43,
				[React.Change.CanvasPosition] = v44
			}, { React.createElement(React.Fragment, nil, {
				React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, itemPadding),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				React.createElement(React.Fragment, nil, v38)
			}) }),
			ScrollButtons = if not scrollButtonsEnabled then nil else React.createElement(CarouselScrollButtons, {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 2 * v30, 0, itemHeight),
				buttonOffsetFromEdge = v22.Size.Size_200,
				handleScrollLeft = v39,
				handleScrollRight = v40,
				leftScrollingEnabled = v41,
				rightScrollingEnabled = v42
			})
		})
	})
end

return React.forwardRef(VariableItemWidthCarousel)
