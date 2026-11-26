local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local button = Foundation.Button
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local scrollView = Foundation.ScrollView
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local function GridItems(props)
	local children = {}

	for k, item in props.items do
		children[k] = React.createElement(
			view,
			{
				key = k,
				LayoutOrder = k,
				Size = UDim2.fromOffset(props.itemSize.X, props.itemSize.Y)
			},
			{ Content = props.renderItem(item, k) }
		)
	end

	return React.createElement(
		view,
		{
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = props.LayoutOrder,
			tag = "size-full-0 auto-y"
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

	local v5 = useTokens()

	local v6 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	local v7 = React.useMemo(function()
		return (math.clamp(
			math.floor(state.X / props.itemConfig.minItemWidth),
			1,
			props.itemConfig.maxItemsPerRow
		))
	end, { state, props.itemConfig })

	local v8 = React.useMemo(function()
		local v9 = state.X - props.itemConfig.padding * (v7 - 1)

		local v10 = math.min(v9 / v7, v9)
		local v11 = v10 * props.aspectRatio

		return Vector2.new(math.floor(v10), (math.floor(v11)))
	end, { state, v7, props.aspectRatio, props.itemConfig })

	local v9 = React.useMemo(function()
		if state.Y <= 0 then
			return 0
		end

		return (math.max(math.floor(state.Y / v8.Y) * v7, props.itemConfig.minItemsPerPage))
	end, { state, v8, v7, props.itemConfig })

	local v10 = state.X > 0 and state.Y > 0
	local shouldShowShowMoreButton = props.shouldShowShowMoreButton or state2 < #props.items

	React.useEffect(function()
		if state2 < v9 then
			setState2(v9)
		end
	end, { state, v9, state2 })

	local v11 = React.useCallback(function()
		if state2 + v9 > #props.items and props.shouldShowShowMoreButton then
			props.onShowMoreCallback()
		end

		setState2(state2 + v9)
	end, {
		state2,
		v9,
		props.items,
		props.onShowMoreCallback,
		props.shouldShowShowMoreButton
	})

	local v12 = React.useMemo(function()
		if not shouldShowShowMoreButton then
			return props.items
		end

		local v13 = math.min(#props.items, state2)
		return Dash.slice(props.items, 1, v13)
	end, { props.items, shouldShowShowMoreButton, state2 })
	React.useEffect(function()
		if not (props.enableInfiniteScroll and shouldShowShowMoreButton) then
			return
		end

		if state.Y <= 0 or v8.Y <= 0 or v7 <= 0 or state2 > #props.items then
			return
		end

		if math.ceil(#v12 / v7) * v8.Y <= state.Y then
			v11()
		end
	end, {
		state,
		v12,
		shouldShowShowMoreButton,
		props.enableInfiniteScroll,
		props.items,
		v7,
		v8,
		v11
	})

	local v13 = React.useCallback(function(data)
		if not shouldShowShowMoreButton then
			return
		end

		if data.CanvasPosition.Y + data.AbsoluteSize.Y >= data.AbsoluteCanvasSize.Y - v8.Y then
			v11()
		end
	end, { shouldShowShowMoreButton, v11, v8 })

	if props.items == nil or #props.items == 0 then
		return React.createElement(view, {
			onAbsoluteSizeChanged = v6,
			tag = "shrink size-full"
		}, {
			EmptyState = props.renderEmptyState()
		})
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v21 = {
		BorderSizePixel = 0,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Padding.Large)
		},
		LayoutOrder = not props.layoutOrder and 1 or props.layoutOrder,
		onCanvasPositionChanged = 0,
		scroll = 0,
		padding = 0,
		tag = "size-full"
	}

	if not props.enableInfiniteScroll then
		v13 = nil
	end

	v21.onCanvasPositionChanged = v13
	v21.scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(1, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		scrollBarVisibility = scrollBarVisibility.None
	}

	v21.padding = props.padding

	local v23 = if #props.items > 0 and v10 then React.createElement(GridItems, {
		itemPadding = Vector2.new(props.itemConfig.padding, props.itemConfig.padding),
		items = v12,
		itemsPerRow = v7,
		itemSize = v8,
		LayoutOrder = 1,
		renderItem = props.renderItem
	}) else nil

	local v24 = if shouldShowShowMoreButton and not props.enableInfiniteScroll then React.createElement(button, {
		LayoutOrder = 2,
		onActivated = v11,
		size = Foundation.Enums.InputSize.Small,
		text = props.showMoreButtonText
	}) else nil

	local v25 = if not shouldShowShowMoreButton and props.footer ~= nil and v9 < #props.items then React.createElement(
		view,
		{ LayoutOrder = 3, tag = "size-full-0 auto-y align-x-center align-y-center" },
		{ Content = props.footer }
	) else nil
	return createElement(view, { onAbsoluteSizeChanged = v6, tag = "shrink size-full" }, {
		GridViewContainer = createElement2(view, { tag = "size-full" }, {
			ScrollView = createElement3(scrollView, v21, {
				GridView = v23,
				ShowMore = v24,
				Footer = v25
			})
		})
	})
end
