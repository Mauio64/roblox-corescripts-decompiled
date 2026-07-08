local VariableItemWidthCarousel2 = script:FindFirstAncestor("VariableItemWidthCarousel")
local VariableItemWidthCarousel2Parent = VariableItemWidthCarousel2.Parent
local CollectionViews = require(VariableItemWidthCarousel2Parent.CollectionViews)
local React = require(VariableItemWidthCarousel2Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(VariableItemWidthCarousel2Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
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

local function areScrollButtonsEnabled(s1: string, s2: string, b1: boolean, b2: boolean) -- line: 52
	-- upvalues: Responsive (copy), FFlagLuaAppEnableVRCarouselScrolling (copy)
	if not b1 then
		return false
	end

	return s1 == Responsive.Input.Pointer and s2 ~= Responsive.Input.Directional or FFlagLuaAppEnableVRCarouselScrolling and b2
end

function VariableItemWidthCarousel(t1: {[any]: any}, p1) -- line: 70
	-- upvalues: useDesignTokens (copy), useLastInput (copy), usePreferredInput (copy), useIsSpatial (copy), FFlagLuaAppHideEmptyCarouselHeader (copy), FFlagLuaAppEnableVRCarouselScrolling (copy), Responsive (copy), React (copy), useVariableItemWidthScrollHandlers (copy), FFlagRenameDeprecatedUIBloxTokens (copy), CollectionHeader (copy), CarouselScrollButtons (copy)
	local v23 = useDesignTokens()
	local v24 = useLastInput()
	local v25 = usePreferredInput()
	local v26 = useIsSpatial()
	local items = t1.items
	local renderItem = t1.renderItem
	local itemPadding = t1.itemPadding
	local itemHeight = t1.itemHeight
	local v31 = t1.sideMargin or 0
	local calculateItemWidth = t1.calculateItemWidth
	local scrollingFrameRef = t1.scrollingFrameRef
	local v34 = t1.title and t1.title ~= ""
	local v35 = not FFlagLuaAppHideEmptyCarouselHeader or (v34 or (t1.subtitle ~= nil or t1.tooltipInfoText ~= nil))
	local scrollButtonsEnabled = t1.scrollButtonsEnabled

	if scrollButtonsEnabled then
		local v37 = not not FFlagLuaAppEnableVRCarouselScrolling or not v26
		local v38 = if not FFlagLuaAppEnableVRCarouselScrolling then nil else v26

		scrollButtonsEnabled = if v37 then v24 == Responsive.Input.Pointer and v25 ~= Responsive.Input.Directional or FFlagLuaAppEnableVRCarouselScrolling and v38 else false
	end

	local v39 = React.useMemo(function() -- line: 95
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
	local v40, v41, v42, v43, v44 = useVariableItemWidthScrollHandlers(items, itemPadding, calculateItemWidth, scrollingFrameRef, t1.scrollSpeed)
	local v45 = React.useCallback(function(p2) -- line: 107
		-- upvalues: v44 (copy), t1 (copy)
		v44()

		if t1.onCanvasPositionChanged and p2 then
			t1.onCanvasPositionChanged(p2.CanvasPosition)
		end
	end, {
		v44,
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
			PaddingLeft = UDim.new(0, v31),
			PaddingRight = UDim.new(0, v31)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, not (if not FFlagLuaAppHideEmptyCarouselHeader then v34 else v35) and 0 or (t1.headerContentPadding or if not FFlagRenameDeprecatedUIBloxTokens then v23.Global.Size_200 else v23.Size.Size_400))
		}),
		Header = if not v35 then nil else React.createElement(CollectionHeader, {
			LayoutOrder = 1,
			title = t1.title,
			subtitle = t1.subtitle,
			tooltipInfoText = t1.tooltipInfoText,
			onActivateInfoIcon = t1.onActivateInfoIcon,
			tooltipSupportsVR = t1.tooltipSupportsVR,
			tooltipSupportsTenFootUi = t1.tooltipSupportsTenFootUi,
			hideButton = #items < 1 or (t1.hideHeaderButton or not v34),
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
				[React.Change.AbsoluteSize] = v44,
				[React.Change.CanvasPosition] = v45
			}, { React.createElement(React.Fragment, nil, {
				React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, itemPadding),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				React.createElement(React.Fragment, nil, v39)
			}) }),
			ScrollButtons = if not scrollButtonsEnabled then nil else React.createElement(CarouselScrollButtons, {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 2 * v31, 0, itemHeight),
				buttonOffsetFromEdge = if not FFlagRenameDeprecatedUIBloxTokens then v23.Global.Size_100 else v23.Size.Size_200,
				handleScrollLeft = v40,
				handleScrollRight = v41,
				leftScrollingEnabled = v42,
				rightScrollingEnabled = v43
			})
		})
	})
end

return React.forwardRef(VariableItemWidthCarousel)
