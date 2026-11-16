local parent = script:FindFirstAncestor("MomentsCommon").Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function GridItems(props)
	local children = {}

	for k, item in props.items do
		children[k] = React.createElement(
			View,
			{
				LayoutOrder = k,
				Size = UDim2.fromOffset(props.itemSize.X, props.itemSize.Y)
			},
			{ Content = props.renderItem(item, k) }
		)
	end

	return React.createElement(
		View,
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = props.LayoutOrder,
			tag = "auto-y size-full-0"
		},
		{
			UIGridLayout = React.createElement("UIGridLayout", {
				CellPadding = UDim2.fromOffset(props.itemPadding.X, props.itemPadding.Y),
				CellSize = UDim2.fromOffset(props.itemSize.X, props.itemSize.Y),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Children = React.createElement(React.Fragment, nil, children)
		}
	)
end

return function(props)
	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(0)

	local v = useTokens()

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	local itemsPerRow = React.useMemo(function()
		return (math.clamp(math.floor(state.X / props.itemConfig.minItemWidth), 1, props.itemConfig.maxItemsPerRow))
	end, { state, props.itemConfig })

	local itemSize = React.useMemo(function()
		local v2 = state.X - props.itemConfig.padding * (itemsPerRow - 1)

		local v3 = math.min(v2 / itemsPerRow, v2)
		local v4 = v3 * props.aspectRatio

		return Vector2.new(math.floor(v3), (math.floor(v4)))
	end, { state, itemsPerRow, props.aspectRatio, props.itemConfig })

	local v2 = React.useMemo(function()
		if state.Y <= 0 then
			return 0
		end

		return (math.max(math.floor(state.Y / itemSize.Y) * itemsPerRow, props.itemConfig.minItemsPerPage))
	end, { state, itemSize, itemsPerRow, props.itemConfig })
	local v3

	if state.X > 0 then
		v3 = state.Y > 0
	else
		v3 = false
	end

	local shouldShowShowMoreButton = props.shouldShowShowMoreButton or state2 < #props.items

	React.useEffect(function()
		if state2 < v2 then
			setState2(v2)
		end
	end, { state, v2, state2 })

	local onActivated = React.useCallback(function()
		if state2 + v2 > #props.items and props.shouldShowShowMoreButton then
			props.onShowMoreCallback()
		end

		setState2(state2 + v2)
	end, { state2, v2, props.items, props.onShowMoreCallback })

	local items = React.useMemo(function()
		if not shouldShowShowMoreButton then
			return props.items
		end

		local v4 = math.min(#props.items, state2)
		return Dash.slice(props.items, 1, v4)
	end, { props.items, shouldShowShowMoreButton, state2 })

	if props.items == nil or #props.items == 0 then
		return React.createElement(View, {
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			tag = "shrink size-full"
		}, {
			EmptyState = props.renderEmptyState()
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v4 = {
		BorderSizePixel = 0,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Padding.Large)
		},
		LayoutOrder = not props.layoutOrder and 1 or props.layoutOrder,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = ScrollBarVisibility.None
		},
		tag = "size-full"
	}
	local uiPadding

	if props.padding then
		uiPadding = React.createElement("UIPadding", {
			PaddingBottom = props.padding.bottom,
			PaddingTop = props.padding.top,
			PaddingLeft = props.padding.left,
			PaddingRight = props.padding.right
		})
	end

	local gridView

	if #props.items > 0 and v3 then
		gridView = React.createElement(GridItems, {
			itemPadding = Vector2.new(props.itemConfig.padding, props.itemConfig.padding),
			items = items,
			itemsPerRow = itemsPerRow,
			itemSize = itemSize,
			LayoutOrder = 1,
			renderItem = props.renderItem
		})
	end

	local showMore

	if shouldShowShowMoreButton then
		showMore = React.createElement(Button, {
			LayoutOrder = 2,
			onActivated = onActivated,
			size = Foundation.Enums.InputSize.Small,
			text = props.showMoreButtonText
		})
	end

	return createElement(View, {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		tag = "shrink size-full"
	}, {
		GridViewContainer = createElement2(View, { tag = "size-full" }, {
			ScrollView = createElement3(ScrollView, v4, {
				UIPadding = uiPadding,
				GridView = gridView,
				ShowMore = showMore
			})
		})
	})
end
