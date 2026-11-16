local module = require("@luauforge/bundled/drf")
local memoize = require("@luauforge/bundled/dqY").memoize

local extended = module.PureComponent:extend("GridView")

extended.defaultProps = {
	items = {},
	cellPaddingOffset = Vector2.new(0, 0),
	windowAbsoluteSize = Vector2.new(1, 1),
	itemAbsoluteSize = Vector2.new(1, 1),
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	onItemsPerRowChanged = nil
}

function extended:init()
	self.state = { itemsPerRow = 0, itemWindowStart = 1 }

	self.containerRef = module.createRef()

	self.isMounted = false

	self.itemsPerRow = 0
	self.itemWindowStart = 1

	self.getTotalRowsAndHeight = memoize(function(p2, p3, p4, p5, p6)
		local v5 = not (p2 > 0) and 0 or math.ceil(p3 / p2)

		if p4 ~= nil then
			v5 = math.min(v5, p4)
		end

		return v5, (math.max(0, p6.Y * v5 + p5.Y * (v5 - 1)))
	end)

	function self.getWindowHeight()
		local windowAbsoluteSize = self.props.windowAbsoluteSize
		local screenSize = self.props.screenSize

		if screenSize then
			return screenSize.Y
		end

		return windowAbsoluteSize.Y
	end

	function self.updateItemWindowBounds(p2)
		local current = self.containerRef.current

		if not current then
			return
		end

		local y = current.AbsolutePosition.Y

		local windowAbsoluteSize = self.props.windowAbsoluteSize
		local cellPaddingOffset = self.props.cellPaddingOffset

		local v5 = -y

		local itemAbsoluteSize = self.props.itemAbsoluteSize

		local v6 = math.floor((windowAbsoluteSize.X + cellPaddingOffset.X) / (itemAbsoluteSize.X + cellPaddingOffset.X))

		local v7 = math.max(0, (math.floor(v5 / (itemAbsoluteSize.Y + cellPaddingOffset.Y))))

		if v6 > 0 then
			local totalRowsAndHeight, v8 = self.getTotalRowsAndHeight(
				v6,
				#self.props.items,
				self.props.numberOfRowsToShow,
				cellPaddingOffset,
				itemAbsoluteSize
			)

			if self.getWindowHeight() < y or y + v8 < 0 then
				v7 = totalRowsAndHeight
			else
				v7 = math.min(v7, totalRowsAndHeight)
			end
		end

		local v8 = math.max(1, v7 * v6 + 1)

		local v9 = v6 ~= self.itemsPerRow or v8 ~= self.itemWindowStart

		if self.props.onItemsPerRowChanged and v6 ~= self.itemsPerRow then
			self.props.onItemsPerRowChanged(v6)
		end

		self.itemsPerRow = v6
		self.itemWindowStart = v8

		if v9 and self.isMounted then
			if p2 then
				spawn(function()
					if self.isMounted then
						self:setState({
							itemsPerRow = self.itemsPerRow,
							itemWindowStart = self.itemWindowStart
						})
					end
				end)
			else
				self:setState({
					itemsPerRow = self.itemsPerRow,
					itemWindowStart = self.itemWindowStart
				})
			end
		end
	end
end

function extended.render(props)
	local layoutOrder = props.props.layoutOrder
	local items = props.props.items
	local renderItem = props.props.renderItem
	local cellPaddingOffset = props.props.cellPaddingOffset
	local numberOfRowsToShow = props.props.numberOfRowsToShow
	local itemAbsoluteSize = props.props.itemAbsoluteSize
	local horizontalAlignment = props.props.horizontalAlignment
	local itemsPerRow = props.state.itemsPerRow
	local itemWindowStart = props.state.itemWindowStart

	local count = #items

	local totalRowsAndHeight, v5 = props.getTotalRowsAndHeight(
		itemsPerRow,
		count,
		numberOfRowsToShow,
		cellPaddingOffset,
		itemAbsoluteSize
	)

	local v6 = (math.ceil(props.getWindowHeight() / (itemAbsoluteSize.Y + cellPaddingOffset.Y)) + 1) * itemsPerRow

	local v7 = math.min(count, totalRowsAndHeight * itemsPerRow, itemWindowStart + v6 - 1)
	local v8 = math.min(
		(itemWindowStart - 1) / itemsPerRow * (itemAbsoluteSize.Y + cellPaddingOffset.Y),
		v5
	)
	local v9

	if typeof(renderItem) == "function" then
		v9 = {
			Layout = module.createElement("UIGridLayout", {
				CellPadding = UDim2.new(0, cellPaddingOffset.X, 0, cellPaddingOffset.Y),
				CellSize = UDim2.new(0, itemAbsoluteSize.X, 0, itemAbsoluteSize.Y),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = horizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}

		if itemWindowStart > 0 then
			for i = itemWindowStart, v7 do
				local item = items[i]
				v9[i % v6] = renderItem(
					item,
					itemAbsoluteSize,
					i,
					not (itemsPerRow > 0) and -1 or math.ceil(i / itemsPerRow)
				)
			end
		end
	end

	return module.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v5),
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		[module.Ref] = props.containerRef,
		[module.Change.AbsolutePosition] = function()
			props.updateItemWindowBounds(true)
		end
	}, {
		Padding = module.createElement("UIPadding", { PaddingTop = UDim.new(0, v8) }),
		Content = v9 and module.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
			v9
		)
	})
end

function extended:didMount()
	self.isMounted = true
	self.updateItemWindowBounds(false)
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.didUpdate(p2, data, p3)
	if
		p2.props.windowAbsoluteSize ~= data.windowAbsoluteSize
		or p2.props.itemAbsoluteSize ~= data.itemAbsoluteSize
		or p2.props.cellPaddingOffset ~= data.cellPaddingOffset
		or p2.props.screenSize and p2.props.screenSize ~= data.screenSize
	then
		p2.updateItemWindowBounds(false)
	end
end

return extended
