local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local LineGraph = require(Components.LineGraph)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ChartHeaderNames = Constants.DataStoresFormatting.ChartHeaderNames
local ValueCellWidth = Constants.DataStoresFormatting.ValueCellWidth
local CellPadding = Constants.DataStoresFormatting.CellPadding
local ExpandArrowPadding = Constants.DataStoresFormatting.ExpandArrowPadding
local HeaderFrameHeight = Constants.DataStoresFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.DataStoresFormatting.EntryFrameHeight

local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

local extended = Roact.Component:extend("DataStoresChart")

local function getX(p)
	return p.time
end

local function getY(p)
	return p.value
end

local function stringFormatY(p)
	return (math.ceil(p))
end

function extended:init(p)
	local currentData, dataStoresDataCount = p.DataStoresData:getCurrentData()

	function self.getOnButtonPress(p2)
		return function(_, _)
			self:setState({
				expandedEntry = self.state.expandedEntry ~= p2 and p2
			})
		end
	end

	self.state = {
		dataStoresData = currentData,
		dataStoresDataCount = dataStoresDataCount,
		expandedEntry = nil
	}
end

function extended:didMount()
	self.statsConnector = self.props.DataStoresData:Signal():Connect(function(dataStoresData, dataStoresDataCount)
		self:setState({ dataStoresData = dataStoresData, dataStoresDataCount = dataStoresDataCount })
	end)
end

function extended:willUnmount()
	self.statsConnector:Disconnect()
	self.statsConnector = nil
end

function extended.render(props)
	local children = {}
	local searchTerm = props.props.searchTerm
	local size = props.props.size
	local layoutOrder = props.props.layoutOrder

	local expandedEntry = props.state.expandedEntry

	children.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v = HeaderFrameHeight

	local dataStoresData = props.state.dataStoresData
	local count = 0
	local layoutOrder2 = 1

	if dataStoresData then
		for k, v2 in pairs(dataStoresData) do
			count += 1

			if not (not searchTerm or string.find(k:lower(), searchTerm:lower()) ~= nil) then
				continue
			end

			layoutOrder2 += 1
			local isExpanded = expandedEntry == k
			local v3 = isExpanded and EntryFrameHeight + LineGraphHeight or EntryFrameHeight

			children[k] = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, v3),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder2
				},
				{
					DataButton = Roact.createElement(
						BannerButton,
						{
							size = UDim2.new(1, 0, 0, EntryFrameHeight),
							pos = UDim2.new(),
							isExpanded = isExpanded,
							onButtonPress = props.getOnButtonPress(k)
						},
						{
							[k] = Roact.createElement(CellLabel, {
								text = k,
								size = UDim2.new(1 - ValueCellWidth, -CellPadding - ExpandArrowPadding, 1, 0),
								pos = UDim2.new(0, CellPadding + ExpandArrowPadding, 0, 0)
							}),
							Data = Roact.createElement(CellLabel, {
								text = v2.dataSet:back().value,
								size = UDim2.new(ValueCellWidth, -CellPadding, 1, 0),
								pos = UDim2.new(1 - ValueCellWidth, CellPadding, 0, 0)
							}),
							VerticalLine = Roact.createElement("Frame", {
								Size = UDim2.new(0, LineWidth, 0, EntryFrameHeight),
								Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
								BackgroundColor3 = LineColor,
								BorderSizePixel = 0
							}),
							lowerHorizontalLine = Roact.createElement("Frame", {
								Size = UDim2.new(1, 0, 0, LineWidth),
								Position = UDim2.new(0, 0, 1, 0),
								BackgroundColor3 = LineColor,
								BorderSizePixel = 0
							})
						}
					),
					Graph = isExpanded and Roact.createElement(LineGraph, {
						pos = UDim2.new(0, 0, 0, EntryFrameHeight),
						size = UDim2.new(1, 0, 1, -EntryFrameHeight),
						graphData = v2.dataSet,
						maxY = v2.max,
						minY = v2.min,
						getX = getX,
						getY = getY,
						axisLabelX = "Timestamp",
						axisLabelY = k,
						stringFormatX = convertTimeStamp,
						stringFormatY = stringFormatY
					})
				}
			)

			v += EntryFrameHeight
		end
	end

	if layoutOrder2 == 1 then
		if count == 0 then
			return Roact.createElement("TextLabel", {
				Size = size,
				Text = "Initialize DataStoresService to view DataStore Budget.",
				TextColor3 = Constants.Color.Text,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			})
		end

		local text = string.format(NoResultSearchStr, searchTerm)
		children.emptyResult = Roact.createElement("TextLabel", {
			Size = size,
			Text = text,
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1
		})
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
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			{
				[ChartHeaderNames[1]] = Roact.createElement(CellLabel, {
					text = ChartHeaderNames[1],
					size = UDim2.new(1 - ValueCellWidth, -CellPadding - ExpandArrowPadding, 1, 0),
					pos = UDim2.new(0, CellPadding + ExpandArrowPadding, 0, 0)
				}),
				[ChartHeaderNames[2]] = Roact.createElement(CellLabel, {
					text = ChartHeaderNames[2],
					size = UDim2.new(ValueCellWidth, -CellPadding, 1, 0),
					pos = UDim2.new(1 - ValueCellWidth, CellPadding, 0, 0)
				}),
				upperHorizontalLine = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, LineWidth),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				}),
				vertical = Roact.createElement("Frame", {
					Size = UDim2.new(0, LineWidth, 1, 0),
					Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				}),
				lowerHorizontalLine = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, LineWidth),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				})
			}
		),
		mainFrame = Roact.createElement("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			ScrollBarThickness = 5,
			CanvasSize = UDim2.new(1, 0, 0, v),
			BackgroundTransparency = 1
		}, children)
	})
end

return DataConsumer(extended, "DataStoresData")
