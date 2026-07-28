local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Dash = require(MomentsCommonParent.Dash)
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local FFlagMomentsProfileGridInfiniteLoad = require(MomentsCommon.Flags.FFlagMomentsProfileGridInfiniteLoad)
local Button = Foundation.Button
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function GridItems(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), View (copy)
	local t2 = {}

	for v15, v16 in t1.items do
		t2[v15] = React.createElement(View, {
			key = v15,
			LayoutOrder = v15,
			Size = UDim2.fromOffset(t1.itemSize.X, t1.itemSize.Y)
		}, {
			Content = t1.renderItem(v16, v15)
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

return function(t3: {[any]: any}) -- line: 95
	-- upvalues: React (copy), useTokens (copy), Dash (copy), FFlagMomentsProfileGridInfiniteLoad (copy), View (copy), ScrollView (copy), ScrollBarVisibility (copy), GridItems (copy), Button (copy), Foundation (copy)
	local v18, v19 = React.useState(Vector2.new(0, 0))
	local v20, v21 = React.useState(0)
	local v22 = useTokens()
	local v23 = React.useCallback(function(p1) -- line: 101
		-- upvalues: v19 (copy)
		v19(p1.AbsoluteSize)
	end, {})
	local v24 = React.useMemo(function() -- line: 105
		-- upvalues: v18 (copy), t3 (copy)
		return (math.clamp(math.floor(v18.X / t3.itemConfig.minItemWidth), 1, t3.itemConfig.maxItemsPerRow))
	end, {
		v18,
		t3.itemConfig
	})
	local v25 = React.useMemo(function() -- line: 113
		-- upvalues: v18 (copy), t3 (copy), v24 (copy)
		local v33 = v18.X - t3.itemConfig.padding * (v24 - 1)
		local v34 = math.min(v33 / v24, v33)
		local v35 = v34 * t3.aspectRatio

		return Vector2.new(math.floor(v34), (math.floor(v35)))
	end, {
		v18,
		v24,
		t3.aspectRatio,
		t3.itemConfig
	})
	local v26 = React.useMemo(function() -- line: 123
		-- upvalues: v18 (copy), v25 (copy), v24 (copy), t3 (copy)
		if v18.Y <= 0 then
			return 0
		end

		return (math.max(math.floor(v18.Y / v25.Y) * v24, t3.itemConfig.minItemsPerPage))
	end, {
		v18,
		v25,
		v24,
		t3.itemConfig
	})
	local v27 = v18.X > 0 and v18.Y > 0
	local v28 = t3.shouldShowShowMoreButton or v20 < #t3.items

	React.useEffect(function() -- line: 137
		-- upvalues: v20 (copy), v26 (copy), v21 (copy)
		if v20 < v26 then
			v21(v26)
		end
	end, {
		v18,
		v26,
		v20
	})

	local v29 = React.useCallback(function() -- line: 144
		-- upvalues: v20 (copy), v26 (copy), t3 (copy), v21 (copy)
		if v20 + v26 > #t3.items and t3.shouldShowShowMoreButton then
			t3.onShowMoreCallback()
		end

		v21(v20 + v26)
	end, {
		v20,
		v26,
		t3.items,
		t3.onShowMoreCallback,
		t3.shouldShowShowMoreButton
	})
	local v30 = React.useMemo(function() -- line: 155
		-- upvalues: v28 (copy), t3 (copy), v20 (copy), Dash (copy)
		if v28 then
			local v36 = math.min(#t3.items, v20)

			return Dash.slice(t3.items, 1, v36)
		end

		return t3.items
	end, {
		t3.items,
		v28,
		v20
	})

	if FFlagMomentsProfileGridInfiniteLoad then
		React.useEffect(function() -- line: 167
			-- upvalues: t3 (copy), v28 (copy), v18 (copy), v25 (copy), v24 (copy), v20 (copy), v30 (copy), v29 (copy)
			if not t3.enableInfiniteScroll or not v28 then
				return
			end

			if v18.Y <= 0 or v25.Y <= 0 or v24 <= 0 then
				return
			end

			if v20 > #t3.items then
				return
			end

			if math.ceil(#v30 / v24) * v25.Y <= v18.Y then
				v29()
			end
		end, {
			v18,
			v30,
			v28,
			t3.enableInfiniteScroll,
			t3.items,
			v24,
			v25,
			v29
		})
	end

	local v31 = nil

	if FFlagMomentsProfileGridInfiniteLoad then
		v31 = React.useCallback(function(p2) -- line: 201
			-- upvalues: v28 (copy), v25 (copy), v29 (copy)
			if not v28 then
				return
			end

			if p2.CanvasPosition.Y + p2.AbsoluteSize.Y >= p2.AbsoluteCanvasSize.Y - v25.Y then
				v29()
			end
		end, {
			v28,
			v29,
			v25
		})
	end

	if t3.items == nil or #t3.items == 0 then
		return React.createElement(View, {
			tag = "shrink size-full",
			onAbsoluteSizeChanged = v23
		}, {
			EmptyState = t3.renderEmptyState()
		})
	end

	return React.createElement(View, {
		tag = "shrink size-full",
		onAbsoluteSizeChanged = v23
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
					Padding = UDim.new(0, v22.Padding.Large)
				},
				LayoutOrder = not t3.layoutOrder and 1 or t3.layoutOrder,
				onCanvasPositionChanged = if not t3.enableInfiniteScroll then nil else v31,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromScale(1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = ScrollBarVisibility.None
				},
				padding = t3.padding
			}, {
				GridView = if not (#t3.items > 0) or not v27 then nil else React.createElement(GridItems, {
					LayoutOrder = 1,
					itemPadding = Vector2.new(t3.itemConfig.padding, t3.itemConfig.padding),
					items = v30,
					itemsPerRow = v24,
					itemSize = v25,
					renderItem = t3.renderItem
				}),
				ShowMore = if not v28 or t3.enableInfiniteScroll then nil else React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = v29,
					size = Foundation.Enums.InputSize.Small,
					text = t3.showMoreButtonText
				}),
				Footer = if v28 or (t3.footer == nil or not (v26 < #t3.items)) then nil else React.createElement(View, {
					LayoutOrder = 3,
					tag = "size-full-0 auto-y align-x-center align-y-center"
				}, {
					Content = t3.footer
				})
			})
		})
	})
end
