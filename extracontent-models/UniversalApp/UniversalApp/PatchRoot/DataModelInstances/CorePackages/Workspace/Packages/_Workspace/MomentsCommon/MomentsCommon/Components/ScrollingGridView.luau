local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local Dash = require(Parent.Dash)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Button = Foundation.Button
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function GridItems(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), View (copy)
	local t2 = {}

	for v13, v14 in t1.items do
		t2[v13] = React.createElement(View, {
			key = v13,
			LayoutOrder = v13,
			Size = UDim2.fromOffset(t1.itemSize.X, t1.itemSize.Y)
		}, {
			Content = t1.renderItem(v14, v13)
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		UIGridLayout = React.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(t1.itemPadding.X, t1.itemPadding.Y),
			CellSize = UDim2.fromOffset(t1.itemSize.X, t1.itemSize.Y),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Children = React.createElement(React.Fragment, nil, t2)
	})
end

return function(t3: {[any]: any}) -- line: 89
	-- upvalues: React (copy), useTokens (copy), Dash (copy), View (copy), ScrollView (copy), ScrollBarVisibility (copy), GridItems (copy), Button (copy), Foundation (copy)
	local v16, v17 = React.useState(Vector2.new(0, 0))
	local v18, v19 = React.useState(0)
	local v20 = useTokens()
	local v21 = React.useCallback(function(p1) -- line: 95
		-- upvalues: v17 (copy)
		v17(p1.AbsoluteSize)
	end, {})
	local v22 = React.useMemo(function() -- line: 99
		-- upvalues: v16 (copy), t3 (copy)
		return (math.clamp(math.floor(v16.X / t3.itemConfig.minItemWidth), 1, t3.itemConfig.maxItemsPerRow))
	end, {
		v16,
		t3.itemConfig
	})
	local v23 = React.useMemo(function() -- line: 107
		-- upvalues: v16 (copy), t3 (copy), v22 (copy)
		local v30 = v16.X - t3.itemConfig.padding * (v22 - 1)
		local v31 = math.min(v30 / v22, v30)
		local v32 = v31 * t3.aspectRatio

		return Vector2.new(math.floor(v31), (math.floor(v32)))
	end, {
		v16,
		v22,
		t3.aspectRatio,
		t3.itemConfig
	})
	local v24 = React.useMemo(function() -- line: 117
		-- upvalues: v16 (copy), v23 (copy), v22 (copy), t3 (copy)
		if v16.Y <= 0 then
			return 0
		end

		return (math.max(math.floor(v16.Y / v23.Y) * v22, t3.itemConfig.minItemsPerPage))
	end, {
		v16,
		v23,
		v22,
		t3.itemConfig
	})
	local v25 = v16.X > 0 and v16.Y > 0
	local v26 = t3.shouldShowShowMoreButton or v18 < #t3.items

	React.useEffect(function() -- line: 131
		-- upvalues: v18 (copy), v24 (copy), v19 (copy)
		if v18 < v24 then
			v19(v24)
		end
	end, {
		v16,
		v24,
		v18
	})

	local v27 = React.useCallback(function() -- line: 138
		-- upvalues: v18 (copy), v24 (copy), t3 (copy), v19 (copy)
		if v18 + v24 > #t3.items and t3.shouldShowShowMoreButton then
			t3.onShowMoreCallback()
		end

		v19(v18 + v24)
	end, {
		v18,
		v24,
		t3.items,
		t3.onShowMoreCallback,
		t3.shouldShowShowMoreButton
	})
	local v28 = React.useMemo(function() -- line: 149
		-- upvalues: v26 (copy), t3 (copy), v18 (copy), Dash (copy)
		if v26 then
			local v33 = math.min(#t3.items, v18)

			return Dash.slice(t3.items, 1, v33)
		end

		return t3.items
	end, {
		t3.items,
		v26,
		v18
	})

	if t3.items == nil or #t3.items == 0 then
		return React.createElement(View, {
			tag = "shrink size-full",
			onAbsoluteSizeChanged = v21
		}, {
			EmptyState = t3.renderEmptyState()
		})
	end

	return React.createElement(View, {
		tag = "shrink size-full",
		onAbsoluteSizeChanged = v21
	}, {
		GridViewContainer = React.createElement(View, {
			tag = "size-full"
		}, {
			ScrollView = React.createElement(ScrollView, {
				BorderSizePixel = 0,
				tag = "size-full",
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v20.Padding.Large)
				},
				LayoutOrder = not t3.layoutOrder and 1 or t3.layoutOrder,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = ScrollBarVisibility.None
				},
				padding = t3.padding
			}, {
				GridView = if not (#t3.items > 0) or not v25 then nil else React.createElement(GridItems, {
					LayoutOrder = 1,
					itemPadding = Vector2.new(t3.itemConfig.padding, t3.itemConfig.padding),
					items = v28,
					itemsPerRow = v22,
					itemSize = v23,
					renderItem = t3.renderItem
				}),
				ShowMore = if not v26 then nil else React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = v27,
					size = Foundation.Enums.InputSize.Small,
					text = t3.showMoreButtonText
				})
			})
		})
	})
end
