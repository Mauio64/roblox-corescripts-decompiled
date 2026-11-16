local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local LineGraph = require(Components.LineGraph)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ValueCellWidth = Constants.MemoryFormatting.ValueCellWidth
local CellPadding = Constants.MemoryFormatting.CellPadding
local ValuePadding = Constants.MemoryFormatting.ValuePadding

local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local DepthIndent = Constants.MemoryFormatting.DepthIndent

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

return function(props)
	local size = props.size
	local depth = props.depth
	local showGraph = props.showGraph
	local dataStats = props.dataStats
	local layoutOrder = props.layoutOrder

	local onButtonPress = props.onButtonPress
	local formatValueStr = props.formatValueStr
	local getX = props.getX
	local getY = props.getY

	local v = depth * DepthIndent

	local name = props.name
	local v2 = props.value

	if dataStats then
		v2 = dataStats.dataSet:back().data
	end

	local udim = UDim.new(1 - ValueCellWidth, -v)

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, -v, 0, EntryFrameHeight),
			pos = UDim2.new(0, v, 0, 0),
			isExpanded = showGraph,
			onButtonPress = onButtonPress
		}, {
			name = Roact.createElement(CellLabel, {
				text = name,
				size = UDim2.new(udim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			horizonal1 = Roact.createElement("Frame", {
				Size = UDim2.new(1, -v, 0, LineWidth),
				Position = UDim2.new(0, v, 0, 0),
				BackgroundColor3 = LineColor,
				BorderSizePixel = 0
			}),
			horizonal2 = Roact.createElement("Frame", {
				Size = UDim2.new(1, -v, 0, LineWidth),
				Position = UDim2.new(0, v, 1, 0),
				BackgroundColor3 = LineColor,
				BorderSizePixel = 0
			})
		}),
		value = v2 and Roact.createElement(CellLabel, {
			text = formatValueStr(v2),
			size = UDim2.new(ValueCellWidth, -ValuePadding, 0, EntryFrameHeight),
			pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0)
		}),
		vertical = Roact.createElement("Frame", {
			Size = UDim2.new(0, 1, 0, EntryFrameHeight),
			Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		}),
		Graph = showGraph and Roact.createElement(LineGraph, {
			pos = UDim2.new(0, 0, 0, EntryFrameHeight),
			size = UDim2.new(1, 0, 1, -EntryFrameHeight),
			graphData = dataStats.dataSet,
			maxY = dataStats.max,
			minY = dataStats.min,
			getX = getX,
			getY = getY,
			stringFormatX = convertTimeStamp,
			stringFormatY = formatValueStr,
			axisLabelX = "Timestamp",
			axisLabelY = name
		})
	})
end
