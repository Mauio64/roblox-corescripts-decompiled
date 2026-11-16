local FFlagDevConsoleKeyCollisionFix = require(script.Parent.Flags.FFlagDevConsoleKeyCollisionFix)

local CorePackages = game:GetService("CorePackages")
local TweenService = game:GetService("TweenService")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local MemoryViewEntry = require(script.Parent.MemoryViewEntry)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local ChartHeaderNames = Constants.MemoryFormatting.ChartHeaderNames
local HeaderFrameHeight = Constants.GeneralFormatting.HeaderFrameHeight
local ValueCellWidth = Constants.MemoryFormatting.ValueCellWidth
local CellPadding = Constants.MemoryFormatting.CellPadding
local ValuePadding = Constants.MemoryFormatting.ValuePadding

local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)

local extended = Roact.Component:extend("MemoryView")

local function getX(p)
	return p.time
end

local function getY(p)
	return p.data
end

local function formatValueStr(p)
	return string.format("%.3f", p)
end

function extended:init(p)
	function self.getOnButtonPress(p2, p3)
		return function(_, _)
			local current = self.state.expandIndex ~= p2 and p2 and self.scrollingRef.current

			if current then
				local v = (p3 - 2.4) * EntryFrameHeight
				TweenService:Create(current, tweenInfo, { CanvasPosition = Vector2.new(0, v) }):Play()
			end

			self:setState({
				expandIndex = self.state.expandIndex ~= p2 and p2
			})
		end
	end

	function self.onSortChanged(p2)
		if p2 == p.targetMemoryData:getSortType() then
			p.targetMemoryData:setSortType(p2)
			self:setState({
				reverseSort = not self.state.reverseSort
			})
		else
			p.targetMemoryData:setSortType(p2)
			self:setState({ reverseSort = false })
		end
	end

	function self.onCanvasPosChanged()
		local canvasPosition = self.scrollingRef.current.CanvasPosition

		if self.state.canvasPos ~= canvasPosition then
			self:setState({
				absScrollSize = self.scrollingRef.current.AbsoluteSize,
				canvasPos = canvasPosition
			})
		end
	end

	self.scrollingRef = Roact.createRef()

	self.state = {
		memoryData = p.targetMemoryData:getMemoryData(),
		reverseSort = false,
		expandIndex = false
	}
end

function extended.willUpdate(p)
	if p.canvasPosConnector then
		p.canvasPosConnector:Disconnect()
	end
end

function extended:didUpdate()
	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)
	end
end

function extended:didMount()
	self.treeViewItemConnector = self.props.targetMemoryData:treeUpdatedSignal():Connect(function(memoryData)
		self:setState({ memoryData = memoryData })
	end)

	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)

		self:setState({
			absScrollSize = self.scrollingRef.current.AbsoluteSize,
			canvasPos = self.scrollingRef.current.CanvasPosition
		})
	end
end

function extended.willUnmount(p)
	p.treeViewItemConnector:Disconnect()
end

function extended:appendAdditionTabInformation(p, list, p2, depth, state)
	local canvasPosition = self.scrollingRef.current.CanvasPosition
	local absoluteSize = self.scrollingRef.current.AbsoluteSize

	for i, item in ipairs(list) do
		local name = item.name
		local value = item.value
		local v = p2 .. name

		if FFlagDevConsoleKeyCollisionFix then
			if item.id then
				v = `{p2}_{item.id}`
			else
				v = `{p2}_{name}_{i}`
			end
		end

		state.layoutOrder += 1

		if
			state.scrollingFrameHeight + EntryFrameHeight >= canvasPosition.Y
			and state.usedFrameSpace < absoluteSize.Y
		then
			if not FFlagDevConsoleKeyCollisionFix then
				v = p2 .. name
			end

			p[v] = Roact.createElement(MemoryViewEntry, {
				size = UDim2.new(1, 0, 0, EntryFrameHeight),
				depth = depth,
				name = name,
				showGraph = false,
				value = value,
				formatValueStr = formatValueStr,
				layoutOrder = state.layoutOrder
			})

			if state.paddingHeight < 0 then
				state.paddingHeight = state.scrollingFrameHeight
			else
				state.usedFrameSpace += EntryFrameHeight
			end
		end

		state.scrollingFrameHeight += EntryFrameHeight

		if item.moreInfo and type(item.moreInfo) == "table" then
			self:appendAdditionTabInformation(p, item.moreInfo, v, depth + 1, state)
		end
	end
end

function extended:recursiveConstructEntries(p, p2, depth, state, p3)
	assert(self.scrollingRef.current, "ScrollingFrame not initialized yet")

	local expandIndex = self.state.expandIndex
	local searchTerm = self.props.searchTerm or ""
	local reverseSort = self.state.reverseSort
	local canvasPosition = self.scrollingRef.current.CanvasPosition
	local absoluteSize = self.scrollingRef.current.AbsoluteSize

	local v = p2.name
	local v2

	if p3 then
		v2 = `{p3}/{v}`
	else
		v2 = v
	end

	if string.find(v:lower(), searchTerm:lower()) then
		if FFlagDevConsoleKeyCollisionFix then
			v = v2
		end

		local showGraph = expandIndex == v
		local v3 = showGraph and EntryFrameHeight + LineGraphHeight or EntryFrameHeight
		state.layoutOrder += 1

		if state.scrollingFrameHeight + v3 >= canvasPosition.Y and state.usedFrameSpace < absoluteSize.Y then
			p[v] = Roact.createElement(MemoryViewEntry, {
				size = UDim2.new(1, 0, 0, v3),
				depth = depth,
				name = p2.name,
				showGraph = showGraph,
				dataStats = p2.dataStats,
				onButtonPress = self.getOnButtonPress(v, state.layoutOrder),
				formatValueStr = formatValueStr,
				getX = getX,
				getY = getY,
				layoutOrder = state.layoutOrder
			})

			if state.paddingHeight < 0 then
				state.paddingHeight = state.scrollingFrameHeight
			else
				state.usedFrameSpace += v3
			end
		end

		state.scrollingFrameHeight += v3

		if showGraph and p2.dataStats.additionalInfoFunc then
			self:appendAdditionTabInformation(p, p2.dataStats.additionalInfoFunc(), v, depth + 1, state)
		end
	end

	local sortedChildren = p2.dataStats.sortedChildren

	if sortedChildren then
		if reverseSort then
			local count = #sortedChildren

			for i = 1, count do
				self:recursiveConstructEntries(p, sortedChildren[count - i + 1], depth + 1, state, v2)
			end
		else
			for _, v3 in ipairs(sortedChildren) do
				self:recursiveConstructEntries(p, v3, depth + 1, state, v2)
			end
		end
	end
end

function extended:render()
	local children = {}
	local layoutOrder = self.props.layoutOrder
	local size = self.props.size
	local searchTerm = self.props.searchTerm or ""

	local v = { scrollingFrameHeight = 0, paddingHeight = -1, usedFrameSpace = 0, layoutOrder = 1 }

	if self.scrollingRef.current then
		for _, v2 in ipairs(self.state.memoryData) do
			self:recursiveConstructEntries(children, v2, 0, v)
		end

		children.UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		children.WindowingPadding = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v.paddingHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
	end

	if v.layoutOrder == 1 then
		if searchTerm == "" then
			children.noDataMessage = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = "Awaiting Memory Stats",
				TextColor3 = Constants.Color.Text,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			})
		else
			local text = string.format(NoResultSearchStr, searchTerm)

			children.noDataMessage = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = text,
				TextColor3 = Constants.Color.Text,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			})
		end
	end

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		Header = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, HeaderFrameHeight),
				BackgroundTransparency = 1
			},
			{
				Name = Roact.createElement(HeaderButton, {
					text = ChartHeaderNames[1],
					size = UDim2.new(1 - ValueCellWidth, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
					pos = UDim2.new(0, CellPadding, 0, 0),
					sortfunction = self.onSortChanged
				}),
				ValueMB = Roact.createElement(HeaderButton, {
					text = ChartHeaderNames[2],
					size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
					pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0),
					sortfunction = self.onSortChanged
				}),
				TopHorizontal = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				}),
				LowerHorizontal = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, LineWidth),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				}),
				vertical = Roact.createElement("Frame", {
					Size = UDim2.new(0, LineWidth, 1, 0),
					Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				})
			}
		),
		Entries = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = 1,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.new(1, 0, 0, v.scrollingFrameHeight),
			[Roact.Ref] = self.scrollingRef
		}, children)
	})
end

return extended
