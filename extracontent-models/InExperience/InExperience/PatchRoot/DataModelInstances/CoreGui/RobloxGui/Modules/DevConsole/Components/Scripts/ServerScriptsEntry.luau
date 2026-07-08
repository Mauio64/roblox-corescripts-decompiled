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
local uDim2 = UDim2.new(0, ActivityBoxPadding, 0, 0)
local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight
local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

return function(p1) -- line: 24
	-- upvalues: Roact (copy), BannerButton (copy), EntryFrameHeight (copy), ActivityBoxWidth (copy), ActivityBoxPadding (copy), CellLabel (copy), uDim2 (copy), LineWidth (copy), LineColor (copy), LineGraph (copy), LineGraphHeight (copy), convertTimeStamp (copy), ChartHeaderNames (copy)
	local scriptData = p1.scriptData
	local frameHeight = p1.frameHeight
	local showGraph = p1.showGraph
	local layoutOrder = p1.layoutOrder
	local activityBoxColor = p1.activityBoxColor
	local entryCellSize = p1.entryCellSize
	local cellOffset = p1.cellOffset
	local verticalOffsets = p1.verticalOffsets
	local onButtonPress = p1.onButtonPress
	local getX = p1.getX
	local getActivity = p1.getActivity
	local getRate = p1.getRate
	local formatScriptsData = p1.formatScriptsData
	local dataStats = scriptData.dataStats
	local v32 = dataStats.dataSet:back()

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, frameHeight),
		LayoutOrder = layoutOrder
	}, {
		button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			pos = UDim2.new(),
			isExpanded = showGraph,
			onButtonPress = onButtonPress
		}, {
			ActivityBox = Roact.createElement("Frame", {
				Size = UDim2.new(0, ActivityBoxWidth, 0, ActivityBoxWidth),
				Position = UDim2.new(0, ActivityBoxPadding, 0, (EntryFrameHeight - ActivityBoxWidth) / 2),
				BackgroundColor3 = activityBoxColor
			}),
			ScriptName = Roact.createElement(CellLabel, {
				text = scriptData.name,
				size = entryCellSize[1] - uDim2,
				pos = cellOffset[1] + uDim2
			}),
			ScriptAcitivity = Roact.createElement(CellLabel, {
				text = formatScriptsData(v32.data[1]),
				size = entryCellSize[2],
				pos = cellOffset[2]
			}),
			scriptFreqStr = Roact.createElement(CellLabel, {
				text = formatScriptsData(v32.data[2]),
				size = entryCellSize[3],
				pos = cellOffset[3]
			}),
			upperHorizontalLine = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				BackgroundColor3 = LineColor
			}),
			verticalLine1 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = verticalOffsets[2],
				BackgroundColor3 = LineColor
			}),
			verticalLine2 = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = verticalOffsets[3],
				BackgroundColor3 = LineColor
			}),
			lowerHorizontalLine = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor
			})
		}),
		ActivityGraph = showGraph and Roact.createElement(LineGraph, {
			axisLabelX = "Timestamp",
			pos = UDim2.new(0, 0, 0, EntryFrameHeight),
			size = UDim2.new(1, 0, 0, LineGraphHeight),
			graphData = dataStats.dataSet,
			maxY = dataStats.max[1],
			minY = dataStats.min[1],
			getX = getX,
			getY = getActivity,
			stringFormatX = convertTimeStamp,
			stringFormatY = formatScriptsData,
			axisLabelY = ChartHeaderNames[2]
		}),
		RateGraph = showGraph and Roact.createElement(LineGraph, {
			axisLabelX = "Timestamp",
			pos = UDim2.new(0, 0, 0, EntryFrameHeight + LineGraphHeight),
			size = UDim2.new(1, 0, 0, LineGraphHeight),
			graphData = dataStats.dataSet,
			maxY = dataStats.max[2],
			minY = dataStats.min[2],
			getX = getX,
			getY = getRate,
			stringFormatX = convertTimeStamp,
			stringFormatY = formatScriptsData,
			axisLabelY = ChartHeaderNames[3]
		})
	})
end
