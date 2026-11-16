local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local HeaderButton = require(Components.HeaderButton)
local CellLabel = require(Components.CellLabel)

local Constants = require(script.Parent.Parent.Parent.Constants)
local GeneralFormatting = Constants.GeneralFormatting
local LineWidth = GeneralFormatting.LineWidth
local LineColor = GeneralFormatting.LineColor

local ActionBindingsFormatting = Constants.ActionBindingsFormatting
local ChartHeaderNames = ActionBindingsFormatting.ChartHeaderNames
local ChartCellWidths = ActionBindingsFormatting.ChartCellWidths
local HeaderFrameHeight = ActionBindingsFormatting.HeaderFrameHeight
local EntryFrameHeight = ActionBindingsFormatting.EntryFrameHeight
local CellPadding = ActionBindingsFormatting.CellPadding
local MinFrameWidth = ActionBindingsFormatting.MinFrameWidth
local total = 0

for _, chartCellWidth in ipairs(ChartCellWidths) do
	total += chartCellWidth
end

local udims = {}
local udims2 = {}
local udims3 = {}
local v = -total / 2
table.insert(udims, UDim2.new(0, CellPadding, 0, 0))
table.insert(udims2, UDim2.new(0.5, v - CellPadding, 0, HeaderFrameHeight))
table.insert(udims3, UDim2.new(0.5, v - CellPadding, 0, EntryFrameHeight))

for _, chartCellWidth in ipairs(ChartCellWidths) do
	table.insert(udims, UDim2.new(0.5, v + CellPadding, 0, 0))
	table.insert(udims2, UDim2.new(0, chartCellWidth - CellPadding, 0, HeaderFrameHeight))
	table.insert(udims3, UDim2.new(0, chartCellWidth - CellPadding, 0, EntryFrameHeight))
	v += chartCellWidth
end

table.insert(udims, UDim2.new(0.5, v + CellPadding, 0, 0))
table.insert(udims2, UDim2.new(0.5, -total / 2 - CellPadding, 0, HeaderFrameHeight))
table.insert(udims3, UDim2.new(0.5, -total / 2 - CellPadding, 0, EntryFrameHeight))

local udims4 = {}

for i, v2 in ipairs(udims) do
	udims4[i] = UDim2.new(v2.X.Scale, v2.X.Offset - CellPadding, v2.Y.Scale, v2.Y.Offset)
end

local extended = Roact.Component:extend("ActionBindingsChart")

local function constructHeader(onSortChanged, p)
	local children = {}

	for i, chartHeaderName in ipairs(ChartHeaderNames) do
		children[chartHeaderName] = Roact.createElement(HeaderButton, {
			text = chartHeaderName,
			size = udims2[i],
			pos = udims[i],
			sortfunction = onSortChanged
		})
	end

	children.upperHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	children.lowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, -LineWidth),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	for i = 2, #udims4 do
		children[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = udims4[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(0, p, 0, HeaderFrameHeight),
			BackgroundTransparency = 1
		},
		children
	)
end

local function constructEntry(actionBindingEntry, p, layoutOrder)
	local name = actionBindingEntry.name
	local actionInfo = actionBindingEntry.actionInfo

	local text = tostring(actionInfo.inputTypes[1])

	local text2 = actionInfo.isCore and "Core" or "Developer"

	local children = {}

	for i = 2, #udims4 do
		children[string.format("line_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = udims4[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	children[name] = Roact.createElement(CellLabel, {
		text = text,
		size = udims3[1],
		pos = udims[1]
	})

	children.priorityLevel = Roact.createElement(CellLabel, {
		text = actionInfo.priorityLevel,
		size = udims3[2],
		pos = udims[2]
	})

	children.isCore = Roact.createElement(CellLabel, {
		text = text2,
		size = udims3[3],
		pos = udims[3]
	})

	children.actionName = Roact.createElement(CellLabel, {
		text = name,
		size = udims3[4],
		pos = udims[4]
	})

	children.inputTypes = Roact.createElement(CellLabel, {
		text = text,
		size = udims3[5],
		pos = udims[5]
	})

	children.lowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(0, p, 0, EntryFrameHeight),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		},
		children
	)
end

function extended:init(p)
	local currentData = p.ActionBindingsData:getCurrentData()

	function self.onSortChanged(p2)
		if p2 == p.ActionBindingsData:getSortType() then
			self:setState({
				reverseSort = not self.state.reverseSort
			})
			return
		end

		p.ActionBindingsData:setSortType(p2)
		self:setState({ reverseSort = false })
	end

	function self.onCanvasPosChanged()
		local canvasPosition = self.scrollingRef.current.CanvasPosition

		if self.state.canvasPos ~= canvasPosition then
			self:setState({ canvasPos = canvasPosition })
		end
	end

	self.scrollingRef = Roact.createRef()

	self.state = { actionBindingEntries = currentData, reverseSort = false }
end

function extended.willUpdate(p)
	if p.canvasPosConnector then
		p.canvasPosConnector:Disconnect()
	end
end

function extended:didUpdate()
	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)

		local absoluteSize = self.scrollingRef.current.AbsoluteSize
		local absScrollSize = self.state.absScrollSize

		if absoluteSize.X ~= absScrollSize.X or absoluteSize.Y ~= absScrollSize.Y then
			self:setState({ absScrollSize = absoluteSize })
		end
	end
end

function extended:didMount()
	self.bindingsUpdated = self.props.ActionBindingsData:Signal():Connect(function(actionBindingEntries)
		self:setState({ actionBindingEntries = actionBindingEntries })
	end)

	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)

		self:setState({
			absScrollSize = self.scrollingRef.current.AbsoluteSize,
			canvasPos = self.scrollingRef.current.CanvasPosition
		})
	end
end

function extended:willUnmount()
	self.bindingsUpdated:Disconnect()
	self.bindingsUpdated = nil
	self.canvasPosConnector:Disconnect()
	self.canvasPosConnector = nil
end

function extended.render(props)
	local children = {}
	local searchTerm = props.props.searchTerm
	local size = props.props.size
	local layoutOrder = props.props.layoutOrder

	local actionBindingEntries = props.state.actionBindingEntries
	local reverseSort = props.state.reverseSort

	local canvasPos = props.state.canvasPos
	local absScrollSize = props.state.absScrollSize
	local v2 = absScrollSize and math.max(absScrollSize.X, MinFrameWidth) or MinFrameWidth

	children.UIListLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v3 = #actionBindingEntries
	local total2 = 0

	if absScrollSize and canvasPos then
		local total3 = 0
		local v4 = -1
		local count = 0

		for i, actionBindingEntry in ipairs(actionBindingEntries) do
			local v5

			if searchTerm then
				local v6 = tostring(actionBindingEntry.actionInfo.inputTypes[1])
				v5 = string.find(v6:lower(), searchTerm:lower()) ~= nil
					or string.find(actionBindingEntry.name:lower(), searchTerm:lower()) ~= nil
			else
				v5 = false
			end

			if not (not searchTerm or v5) then
				continue
			end

			if total2 + EntryFrameHeight >= canvasPos.Y then
				if total3 < absScrollSize.Y then
					local v6

					if reverseSort then
						v6 = v3 - i or i
					else
						v6 = i
					end

					children[i] = constructEntry(actionBindingEntry, v2, v6 + 1)
				end

				if v4 < 0 then
					v4 = total2
				else
					total3 += EntryFrameHeight
				end

				count += 1
			end

			total2 += EntryFrameHeight
		end

		if count == 0 then
			children.NoneFound = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Text = "No ActionBindings Found",
				TextColor3 = LineColor,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		else
			children.WindowingPadding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v4),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		end
	end

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = layoutOrder
		},
		{
			Header = constructHeader(props.onSortChanged, v2),
			MainChart = Roact.createElement("ScrollingFrame", {
				Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
				Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
				CanvasSize = UDim2.new(0, v2, 0, total2),
				ScrollBarThickness = 6,
				BackgroundColor3 = Constants.Color.BaseGray,
				BackgroundTransparency = 1,
				[Roact.Ref] = props.scrollingRef
			}, children)
		}
	)
end

return DataConsumer(extended, "ActionBindingsData")
