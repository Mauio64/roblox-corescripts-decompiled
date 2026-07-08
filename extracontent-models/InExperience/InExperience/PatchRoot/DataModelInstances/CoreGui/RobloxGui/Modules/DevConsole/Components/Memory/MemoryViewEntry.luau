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

return function(p1) -- line: 22
	-- upvalues: DepthIndent (copy), ValueCellWidth (copy), Roact (copy), BannerButton (copy), EntryFrameHeight (copy), CellLabel (copy), CellPadding (copy), LineWidth (copy), LineColor (copy), ValuePadding (copy), LineGraph (copy), convertTimeStamp (copy)
	local size = p1.size
	local depth = p1.depth
	local showGraph = p1.showGraph
	local dataStats = p1.dataStats
	local layoutOrder = p1.layoutOrder
	local onButtonPress = p1.onButtonPress
	local formatValueStr = p1.formatValueStr
	local getX = p1.getX
	local getY = p1.getY
	local v26 = depth * DepthIndent
	local name = p1.name
	local value = p1.value

	if dataStats then
		value = dataStats.dataSet:back().data
	end

	local uDim = UDim.new(1 - ValueCellWidth, -v26)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, -v26, 0, EntryFrameHeight),
			pos = UDim2.new(0, v26, 0, 0),
			isExpanded = showGraph,
			onButtonPress = onButtonPress
		}, {
			name = Roact.createElement(CellLabel, {
				text = name,
				size = UDim2.new(uDim, UDim.new(1, 0)),
				pos = UDim2.new(0, CellPadding, 0, 0)
			}),
			horizonal1 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, -v26, 0, LineWidth),
				Position = UDim2.new(0, v26, 0, 0),
				BackgroundColor3 = LineColor
			}),
			horizonal2 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, -v26, 0, LineWidth),
				Position = UDim2.new(0, v26, 1, 0),
				BackgroundColor3 = LineColor
			})
		}),
		value = value and Roact.createElement(CellLabel, {
			text = formatValueStr(value),
			size = UDim2.new(ValueCellWidth, -ValuePadding, 0, EntryFrameHeight),
			pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0)
		}),
		vertical = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, 1, 0, EntryFrameHeight),
			Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
			BackgroundColor3 = LineColor
		}),
		Graph = showGraph and Roact.createElement(LineGraph, {
			axisLabelX = "Timestamp",
			pos = UDim2.new(0, 0, 0, EntryFrameHeight),
			size = UDim2.new(1, 0, 1, -EntryFrameHeight),
			graphData = dataStats.dataSet,
			maxY = dataStats.max,
			minY = dataStats.min,
			getX = getX,
			getY = getY,
			stringFormatX = convertTimeStamp,
			stringFormatY = formatValueStr,
			axisLabelY = name
		})
	})
end
