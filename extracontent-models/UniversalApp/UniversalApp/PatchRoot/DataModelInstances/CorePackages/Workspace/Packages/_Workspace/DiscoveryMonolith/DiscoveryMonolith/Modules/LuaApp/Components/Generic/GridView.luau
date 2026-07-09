local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Roact = require(Parent.Roact)
local memoize = require(Parent.AppCommonLib).memoize
local v4 = Roact.PureComponent:extend("GridView")

v4.defaultProps = {
	onItemsPerRowChanged = nil,
	items = {},
	cellPaddingOffset = Vector2.new(0, 0),
	windowAbsoluteSize = Vector2.new(1, 1),
	itemAbsoluteSize = Vector2.new(1, 1),
	horizontalAlignment = Enum.HorizontalAlignment.Center
}

function v4.init(p1) -- line: 17
	-- upvalues: Roact (copy), memoize (copy)
	p1.state = {
		itemsPerRow = 0,
		itemWindowStart = 1
	}
	p1.containerRef = Roact.createRef()
	p1.isMounted = false
	p1.itemsPerRow = 0
	p1.itemWindowStart = 1
	p1.getTotalRowsAndHeight = memoize(function(n1: number, n2: number, n3: number, vector2: Vector2, vector2_2: Vector2) -- line: 33
		local n4 = 0

		if n1 > 0 then
			n4 = math.ceil(n2 / n1)
		end

		if n3 ~= nil then
			n4 = math.min(n4, n3)
		end

		return n4, (math.max(0, vector2_2.Y * n4 + vector2.Y * (n4 - 1)))
	end)

	function p1.getWindowHeight() -- line: 55
		-- upvalues: p1 (copy)
		local windowAbsoluteSize = p1.props.windowAbsoluteSize
		local screenSize = p1.props.screenSize

		if screenSize then
			return screenSize.Y
		end

		return windowAbsoluteSize.Y
	end
	function p1.updateItemWindowBounds(p2) -- line: 68
		-- upvalues: p1 (copy)
		local current = p1.containerRef.current

		if not current then
			return
		end

		local AbsolutePositionY = current.AbsolutePosition.Y
		local windowAbsoluteSize = p1.props.windowAbsoluteSize
		local cellPaddingOffset = p1.props.cellPaddingOffset
		local v43 = -AbsolutePositionY
		local itemAbsoluteSize = p1.props.itemAbsoluteSize
		local v45 = math.floor((windowAbsoluteSize.X + cellPaddingOffset.X) / (itemAbsoluteSize.X + cellPaddingOffset.X))
		local v46 = math.max(0, (math.floor(v43 / (itemAbsoluteSize.Y + cellPaddingOffset.Y))))

		if v45 > 0 then
			local v47, v48 = p1.getTotalRowsAndHeight(v45, #p1.props.items, p1.props.numberOfRowsToShow, cellPaddingOffset, itemAbsoluteSize)

			v46 = if not (AbsolutePositionY > p1.getWindowHeight()) and not (AbsolutePositionY + v48 < 0) then math.min(v46, v47) else v47
		end

		local v49 = math.max(1, v46 * v45 + 1)
		local v50 = v45 ~= p1.itemsPerRow or v49 ~= p1.itemWindowStart

		if p1.props.onItemsPerRowChanged and v45 ~= p1.itemsPerRow then
			p1.props.onItemsPerRowChanged(v45)
		end

		p1.itemsPerRow = v45
		p1.itemWindowStart = v49

		if v50 and p1.isMounted then
			if p2 then
				spawn(function() -- line: 130
					-- upvalues: p1 (copy)
					if p1.isMounted then
						p1:setState({
							itemsPerRow = p1.itemsPerRow,
							itemWindowStart = p1.itemWindowStart
						})
					end
				end)

				return
			end

			p1:setState({
				itemsPerRow = p1.itemsPerRow,
				itemWindowStart = p1.itemWindowStart
			})
		end
	end
end
function v4.render(p3) -- line: 149
	-- upvalues: Roact (copy)
	local layoutOrder = p3.props.layoutOrder
	local items = p3.props.items
	local renderItem = p3.props.renderItem
	local cellPaddingOffset = p3.props.cellPaddingOffset
	local numberOfRowsToShow = p3.props.numberOfRowsToShow
	local itemAbsoluteSize = p3.props.itemAbsoluteSize
	local horizontalAlignment = p3.props.horizontalAlignment
	local itemsPerRow = p3.state.itemsPerRow
	local itemWindowStart = p3.state.itemWindowStart
	local v16 = #items
	local v17, v18 = p3.getTotalRowsAndHeight(itemsPerRow, v16, numberOfRowsToShow, cellPaddingOffset, itemAbsoluteSize)
	local v19 = (math.ceil(p3.getWindowHeight() / (itemAbsoluteSize.Y + cellPaddingOffset.Y)) + 1) * itemsPerRow
	local v20 = math.min(v16, v17 * itemsPerRow, itemWindowStart + v19 - 1)
	local v21 = math.min((itemWindowStart - 1) / itemsPerRow * (itemAbsoluteSize.Y + cellPaddingOffset.Y), v18)
	local t1 = nil

	if typeof(renderItem) == "function" then
		t1 = {
			Layout = Roact.createElement("UIGridLayout", {
				CellPadding = UDim2.new(0, cellPaddingOffset.X, 0, cellPaddingOffset.Y),
				CellSize = UDim2.new(0, itemAbsoluteSize.X, 0, itemAbsoluteSize.Y),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = horizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}

		if itemWindowStart > 0 then
			for i = itemWindowStart, v20 do
				local v24 = items[i]

				t1[i % v19] = renderItem(v24, itemAbsoluteSize, i, not (itemsPerRow > 0) and -1 or math.ceil(i / itemsPerRow))
			end
		end
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v18),
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		[Roact.Ref] = p3.containerRef,
		[Roact.Change.AbsolutePosition] = function() -- line: 204
			-- upvalues: p3 (copy)
			p3.updateItemWindowBounds(true)
		end
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v21)
		}),
		Content = t1 and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, t1)
	})
end
function v4.didMount(p4) -- line: 218
	p4.isMounted = true
	p4.updateItemWindowBounds(false)
end
function v4.willUnmount(p5) -- line: 223
	p5.isMounted = false
end
function v4.didUpdate(p6, p7, _) -- line: 227
	if p6.props.windowAbsoluteSize ~= p7.windowAbsoluteSize or (p6.props.itemAbsoluteSize ~= p7.itemAbsoluteSize or (p6.props.cellPaddingOffset ~= p7.cellPaddingOffset or p6.props.screenSize and p6.props.screenSize ~= p7.screenSize)) then
		p6.updateItemWindowBounds(false)
	end
end

return v4
