local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local ProfilerUtil = require(script.Parent.ProfilerUtil)

local getDurations = ProfilerUtil.getDurations
local formatSessionLength = ProfilerUtil.formatSessionLength

require(script.Parent.ProfilerDataFormatV2)

local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local ProfilerViewEntry = require(script.Parent.ProfilerViewEntry)

local Constants = require(script.Parent.Parent.Parent.Constants)

local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local HeaderFrameHeight = Constants.GeneralFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr
local HeaderNames = Constants.ScriptProfilerFormatting.HeaderNames
local ValueCellWidth = Constants.ScriptProfilerFormatting.ValueCellWidth
local CellPadding = Constants.ScriptProfilerFormatting.CellPadding
local ValuePadding = Constants.ScriptProfilerFormatting.ValuePadding

local extended = Roact.PureComponent:extend("ProfilerView")

function extended:renderChildren()
	local data = self.props.data
	assert(data.Version == 2)

	local durations = getDurations(data, 0)

	local average = not (self.props.average > 0 and self.props.sessionLength) and 1
		or self.props.sessionLength / 1000 / self.props.average

	local createElement = Roact.createElement
	local v = {
		layoutOrder = 0,
		depth = 0,
		data = data,
		nodeId = self.props.rootNode,
		functionId = self.props.rootFunc,
		nodeName = self.props.rootNodeName,
		average = average,
		searchTerm = self.props.searchTerm,
		searchFilter = self.props.searchFilter,
		showPlugins = self.props.showPlugins,
		pluginOffsets = self.props.pluginOffsets,
		showGC = self.props.showGC,
		gcNodeOffsets = self.props.gcNodeOffsets,
		pluginGCOffsets = self.props.pluginGCOffsets,
		expandedNodes = self.props.expandedNodes,
		percentageRatio = 0
	}
	local percentageRatio

	if self.props.showAsPercentages then
		percentageRatio = durations / 100
	end

	v.percentageRatio = percentageRatio
	return createElement(ProfilerViewEntry, v)
end

function extended:render()
	local layoutOrder = self.props.layoutOrder
	local size = self.props.size
	local v = nil

	if self.props.profiling and not self.props.data then
		v = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = "Press Stop to Finish Profiling",
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		})
	elseif not self.props.data then
		v = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Text = "Start Profiling to View Data",
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		})
	end

	local v2 = formatSessionLength(self.props.sessionLength)

	local v3 = v2 and "Session Duration: " .. v2

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		SessionInfo = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, HeaderFrameHeight),
				BackgroundTransparency = 1
			},
			{
				Name = Roact.createElement(HeaderButton, {
					text = v3 or "Session Info",
					size = UDim2.new(1 - ValueCellWidth * 2, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
					pos = UDim2.new(0, CellPadding, 0, 0)
				}),
				TopHorizontal = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				})
			}
		),
		Header = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, HeaderFrameHeight),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, HeaderFrameHeight)
			},
			{
				Name = Roact.createElement(HeaderButton, {
					text = HeaderNames[1],
					size = UDim2.new(1 - ValueCellWidth * 2, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
					pos = UDim2.new(0, CellPadding, 0, 0),
					sortfunction = self.onSortChanged
				}),
				Inclusive = Roact.createElement(HeaderButton, {
					text = HeaderNames[2],
					size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
					pos = UDim2.new(1 - ValueCellWidth * 2, ValuePadding, 0, 0),
					sortfunction = self.onSortChanged
				}),
				Self = Roact.createElement(HeaderButton, {
					text = HeaderNames[3],
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
				Vertical1 = Roact.createElement("Frame", {
					Size = UDim2.new(0, LineWidth, 1, 0),
					Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				}),
				Vertical2 = Roact.createElement("Frame", {
					Size = UDim2.new(0, LineWidth, 1, 0),
					Position = UDim2.new(1 - ValueCellWidth * 2, 0, 0, 0),
					BackgroundColor3 = LineColor,
					BorderSizePixel = 0
				})
			}
		),
		Entries = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight * 2),
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight * 2),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical
			}),
			Children = v or Roact.createFragment(self:renderChildren())
		})
	})
end

return extended
