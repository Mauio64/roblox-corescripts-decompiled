local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local LineGraph = require(Components.LineGraph)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ChartHeaderNames = Constants.ServerScriptsFormatting.ChartHeaderNames
local EntryFrameHeight = Constants.ServerScriptsFormatting.EntryFrameHeight
local ActivityBoxWidth = Constants.ServerScriptsFormatting.ActivityBoxWidth
local ActivityBoxPadding = Constants.ServerScriptsFormatting.ActivityBoxPadding

local udim = UDim2.new(0, ActivityBoxPadding, 0, 0)

local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

return function(props)
	local scriptData = props.scriptData

	local frameHeight = props.frameHeight
	local showGraph = props.showGraph
	local layoutOrder = props.layoutOrder
	local activityBoxColor = props.activityBoxColor

	local entryCellSize = props.entryCellSize
	local cellOffset = props.cellOffset
	local verticalOffsets = props.verticalOffsets

	local onButtonPress = props.onButtonPress
	local getX = props.getX
	local getActivity = props.getActivity
	local getRate = props.getRate
	local formatScriptsData = props.formatScriptsData

	local dataStats = scriptData.dataStats
	local back = dataStats.dataSet:back()

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, frameHeight),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		},
		{
			button = Roact.createElement(
				BannerButton,
				{
					size = UDim2.new(1, 0, 0, EntryFrameHeight),
					pos = UDim2.new(),
					isExpanded = showGraph,
					onButtonPress = onButtonPress
				},
				{
					ActivityBox = Roact.createElement("Frame", {
						Size = UDim2.new(0, ActivityBoxWidth, 0, ActivityBoxWidth),
						Position = UDim2.new(0, ActivityBoxPadding, 0, (EntryFrameHeight - ActivityBoxWidth) / 2),
						BackgroundColor3 = activityBoxColor
					}),
					ScriptName = Roact.createElement(CellLabel, {
						text = scriptData.name,
						size = entryCellSize[1] - udim,
						pos = cellOffset[1] + udim
					}),
					ScriptAcitivity = Roact.createElement(CellLabel, {
						text = formatScriptsData(back.data[1]),
						size = entryCellSize[2],
						pos = cellOffset[2]
					}),
					scriptFreqStr = Roact.createElement(CellLabel, {
						text = formatScriptsData(back.data[2]),
						size = entryCellSize[3],
						pos = cellOffset[3]
					}),
					upperHorizontalLine = Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, LineWidth),
						BackgroundColor3 = LineColor,
						BorderSizePixel = 0
					}),
					verticalLine1 = Roact.createElement("Frame", {
						Size = UDim2.new(0, LineWidth, 1, 0),
						Position = verticalOffsets[2],
						BackgroundColor3 = LineColor,
						BorderSizePixel = 0
					}),
					verticalLine2 = Roact.createElement("Frame", {
						Size = UDim2.new(0, LineWidth, 1, 0),
						Position = verticalOffsets[3],
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
			ActivityGraph = showGraph and Roact.createElement(LineGraph, {
				pos = UDim2.new(0, 0, 0, EntryFrameHeight),
				size = UDim2.new(1, 0, 0, LineGraphHeight),
				graphData = dataStats.dataSet,
				maxY = dataStats.max[1],
				minY = dataStats.min[1],
				getX = getX,
				getY = getActivity,
				stringFormatX = convertTimeStamp,
				stringFormatY = formatScriptsData,
				axisLabelX = "Timestamp",
				axisLabelY = ChartHeaderNames[2]
			}),
			RateGraph = showGraph and Roact.createElement(LineGraph, {
				pos = UDim2.new(0, 0, 0, EntryFrameHeight + LineGraphHeight),
				size = UDim2.new(1, 0, 0, LineGraphHeight),
				graphData = dataStats.dataSet,
				maxY = dataStats.max[2],
				minY = dataStats.min[2],
				getX = getX,
				getY = getRate,
				stringFormatX = convertTimeStamp,
				stringFormatY = formatScriptsData,
				axisLabelX = "Timestamp",
				axisLabelY = ChartHeaderNames[3]
			})
		}
	)
end
