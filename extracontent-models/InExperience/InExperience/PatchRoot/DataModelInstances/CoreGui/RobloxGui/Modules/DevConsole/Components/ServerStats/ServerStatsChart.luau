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
local ChartHeaderNames = Constants.ServerStatsFormatting.ChartHeaderNames
local ValueCellWidth = Constants.ServerStatsFormatting.ValueCellWidth
local CellPadding = Constants.ServerStatsFormatting.CellPadding
local ExpandArrowPadding = Constants.ServerStatsFormatting.ExpandArrowPadding
local HeaderFrameHeight = Constants.ServerStatsFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.ServerStatsFormatting.EntryFrameHeight

local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

local extended = Roact.Component:extend("ServerStats")

local function formatData(value) -- 1 equivalent call inferred from this helper
	return string.format("%.3f", value)
end

local function getX(p)
	return p.time
end

local function getY(p)
	return p.value
end

function extended:init()
	local currentData = self.props.ServerStatsData:getCurrentData()

	function self.getOnButtonPress(p)
		return function(_, _)
			self:setState({
				expandedEntry = self.state.expandedEntry ~= p and p
			})
		end
	end

	self.state = { serverStatsData = currentData }
end

function extended:didMount()
	self.statsConnector = self.props.ServerStatsData:Signal():Connect(function(serverStatsData)
		self:setState({ serverStatsData = serverStatsData })
	end)
end

function extended:willUnmount()
	self.statsConnector:Disconnect()
	self.statsConnector = nil
end

function extended.render(props)
	local children = {}
	local searchTerm = props.props.searchTerm
	local layoutOrder = props.props.layoutOrder
	local size = props.props.size

	local expandedEntry = props.state.expandedEntry
	local serverStatsData = props.state.serverStatsData

	local layoutOrder2 = 1
	local count = 0
	local v = 0

	if serverStatsData then
		for k, v2 in pairs(serverStatsData) do
			count += 1

			if not (not searchTerm or string.find(k:lower(), searchTerm:lower()) ~= nil) then
				continue
			end

			layoutOrder2 += 1
			local isExpanded = expandedEntry == k
			local v3 = isExpanded and EntryFrameHeight + LineGraphHeight or EntryFrameHeight

			v = isExpanded and v + 1 or v

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
								text = formatData(v2.dataSet:back().value), -- inferred equivalent call
								size = UDim2.new(ValueCellWidth, -CellPadding, 1, 0),
								pos = UDim2.new(1 - ValueCellWidth, CellPadding, 0, 0)
							}),
							VerticalLine = Roact.createElement("Frame", {
								Size = UDim2.new(0, LineWidth, 1, 0),
								Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
								BackgroundColor3 = LineColor,
								BorderSizePixel = 0
							}),
							HorizontalAlignment = Roact.createElement("Frame", {
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
						minY = v2.min,
						maxY = v2.max,
						getX = getX,
						getY = getY,
						axisLabelX = "Timestamp",
						axisLabelY = k,
						stringFormatX = convertTimeStamp,
						stringFormatY = formatData
					})
				}
			)
		end
	end

	if layoutOrder2 == 1 then
		if count == 0 then
			return Roact.createElement("TextLabel", {
				Size = size,
				Position = UDim2.new(0, 0, 0, 0),
				Text = "Awaiting Server Stats",
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

	children.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v2 = count * EntryFrameHeight + v * LineGraphHeight

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
				VerticalLine = Roact.createElement("Frame", {
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
			CanvasSize = UDim2.new(1, 0, 0, v2),
			ScrollBarThickness = 5,
			BackgroundTransparency = 1
		}, children)
	})
end

return DataConsumer(extended, "ServerStatsData")
