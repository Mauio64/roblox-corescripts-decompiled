local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local HeaderButton = require(Components.HeaderButton)
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local LineGraph = require(Components.LineGraph)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ChartHeaderNames = Constants.ServerJobsFormatting.ChartHeaderNames
local ValueCellWidth = Constants.ServerJobsFormatting.ValueCellWidth
local EntryFrameHeight = Constants.ServerJobsFormatting.EntryFrameHeight
local HeaderFrameHeight = Constants.ServerJobsFormatting.HeaderFrameHeight
local CellPadding = Constants.ServerJobsFormatting.CellPadding
local MinFrameWidth = Constants.ServerJobsFormatting.MinFrameWidth

local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr

local v = EntryFrameHeight - LineWidth
local udims = {}
local total = 0
local udims2 = {}
local v2 = {}
local v3 = {
	function(p)
		return p and string.format("%.4f%%", p) or ""
	end,
	function(p)
		return p and string.format("%.4f/s", p) or ""
	end,
	function(p)
		return p and string.format("%.4fms", p) or ""
	end
}

for _, v4 in ipairs(ValueCellWidth) do
	table.insert(udims, UDim2.new(total, CellPadding, 0, 0))
	table.insert(udims2, UDim2.new(v4, -CellPadding, 0, HeaderFrameHeight))
	table.insert(v2, UDim2.new(v4, -CellPadding, 0, v))
	total += v4
end

local udims3 = {}

for i, v4 in ipairs(udims) do
	udims3[i] = UDim2.new(v4.X.Scale, v4.X.Offset - CellPadding, v4.Y.Scale, v4.Y.Offset)
end

local extended = Roact.Component:extend("ServerJobsChart")

local function getX(p)
	return p.time
end

local function getDutyCycle(p)
	return p.data[1]
end

local function getStepsPerSec(p)
	return p.data[2]
end

local function getStepTime(p)
	return p.data[3]
end

function extended:init(p)
	local currentData = p.ServerJobsData:getCurrentData()

	function self.getOnButtonPress(p2)
		return function(_, _)
			self:setState({
				expandIndex = self.state.expandIndex ~= p2 and p2
			})
		end
	end

	function self.onSortChanged(p2)
		if p2 == p.ServerJobsData:getSortType() then
			self:setState({
				reverseSort = not self.state.reverseSort
			})
			return
		end

		p.ServerJobsData:setSortType(p2)
		self:setState({ reverseSort = false })
	end

	function self.onCanvasPosChanged()
		local canvasPosition = self.scrollingRef.current.CanvasPosition

		if self.state.canvasPos ~= canvasPosition then
			self:setState({ canvasPos = canvasPosition })
		end
	end

	self.scrollingRef = Roact.createRef()

	self.state = { serverJobsList = currentData, reverseSort = false, expandIndex = nil }
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
	self.statsConnector = self.props.ServerJobsData:Signal():Connect(function(serverJobsList)
		self:setState({ serverJobsList = serverJobsList })
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
	self.statsConnector:Disconnect()
	self.statsConnector = nil

	if self.canvasPosConnector then
		self.canvasPosConnector:Disconnect()
		self.canvasPosConnector = nil
	end
end

function extended.render(props)
	local children = {}
	local searchTerm = props.props.searchTerm
	local size = props.props.size
	local layoutOrder = props.props.layoutOrder

	local serverJobsList = props.state.serverJobsList
	local reverseSort = props.state.reverseSort
	local expandIndex = props.state.expandIndex
	local canvasPos = props.state.canvasPos
	local absScrollSize = props.state.absScrollSize

	local v4 = absScrollSize and math.max(absScrollSize.X, MinFrameWidth) or MinFrameWidth

	local count = #serverJobsList

	if count == 0 then
		return Roact.createElement("TextLabel", {
			Size = size,
			Position = UDim2.new(0, 0, 0, 0),
			Text = "Awaiting Server Jobs Information",
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		})
	end

	local total2 = 0

	if absScrollSize then
		local total3 = 0
		local v5 = -1

		for k, serverJob in pairs(serverJobsList) do
			local name = serverJob.name

			if not (not searchTerm or string.find(name:lower(), searchTerm:lower()) ~= nil) then
				continue
			end

			local dataStats = serverJob.dataStats
			local back = dataStats.dataSet:back()
			local isExpanded = expandIndex == name
			local v6 = isExpanded and EntryFrameHeight + 3 * LineGraphHeight / 2 + CellPadding * 4 or EntryFrameHeight

			if total2 + v6 >= canvasPos.Y then
				if total3 < absScrollSize.Y then
					k = reverseSort and count - k or k

					local children2 = {}
					children2[name] = Roact.createElement(CellLabel, {
						text = name,
						size = udims2[1],
						pos = udims[1]
					})

					for k2, v7 in pairs(back.data) do
						children2[ChartHeaderNames[k2]] = Roact.createElement(CellLabel, {
							text = v3[k2](v7),
							size = udims2[k2 + 1],
							pos = udims[k2 + 1]
						})
					end

					for i = 2, #udims3 do
						children2[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
							Size = UDim2.new(0, LineWidth, 1, 0),
							Position = udims3[i],
							BackgroundColor3 = LineColor,
							BorderSizePixel = 0
						})
					end

					children2.lowerHorizontalLine = Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, LineWidth),
						Position = UDim2.new(0, 0, 1, 0),
						BackgroundColor3 = LineColor,
						BorderSizePixel = 0
					})

					children[name] = Roact.createElement("Frame", {
						Size = UDim2.new(0, v4, 0, v6),
						BackgroundTransparency = 1,
						LayoutOrder = k + 1
					}, {
						Button = Roact.createElement(
							BannerButton,
							{
								size = UDim2.new(1, 0, 0, EntryFrameHeight),
								pos = UDim2.new(),
								isExpanded = isExpanded,
								onButtonPress = props.getOnButtonPress(name)
							},
							children2
						),
						DutyCycleGraph = isExpanded and Roact.createElement(LineGraph, {
							pos = UDim2.new(0, 0, 0, EntryFrameHeight + CellPadding),
							size = UDim2.new(0, v4, 0, LineGraphHeight / 2),
							graphData = dataStats.dataSet,
							maxY = dataStats.max[1],
							minY = dataStats.min[1],
							getX = getX,
							getY = getDutyCycle,
							stringFormatX = convertTimeStamp,
							stringFormatY = v3[1],
							axisLabelX = "Timestamp",
							axisLabelY = name .. " " .. ChartHeaderNames[2]
						}),
						StepsPerSecGraph = isExpanded and Roact.createElement(LineGraph, {
							pos = UDim2.new(0, 0, 0, EntryFrameHeight + LineGraphHeight / 2 + CellPadding * 2),
							size = UDim2.new(0, v4, 0, LineGraphHeight / 2),
							graphData = dataStats.dataSet,
							maxY = dataStats.max[2],
							minY = dataStats.min[2],
							getX = getX,
							getY = getStepsPerSec,
							stringFormatX = convertTimeStamp,
							stringFormatY = v3[2],
							axisLabelX = "Timestamp",
							axisLabelY = name .. " " .. ChartHeaderNames[3]
						}),
						StepTimeGraph = isExpanded and Roact.createElement(LineGraph, {
							pos = UDim2.new(0, 0, 0, EntryFrameHeight + LineGraphHeight + CellPadding * 3),
							size = UDim2.new(0, v4, 0, LineGraphHeight / 2),
							graphData = dataStats.dataSet,
							maxY = dataStats.max[3],
							minY = dataStats.min[3],
							getX = getX,
							getY = getStepTime,
							stringFormatX = convertTimeStamp,
							stringFormatY = v3[3],
							axisLabelX = "Timestamp",
							axisLabelY = name .. " " .. ChartHeaderNames[4]
						})
					})
				end

				if v5 < 0 then
					v5 = total2
				else
					total3 += v6
				end
			end

			total2 += v6
		end

		if v5 == -1 then
			local text = string.format(NoResultSearchStr, searchTerm)
			children.emptyResult = Roact.createElement("TextLabel", {
				Size = size,
				Text = text,
				TextColor3 = Constants.Color.Text,
				BackgroundTransparency = 1
			})
		else
			children.WindowingPadding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v5),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		end
	end

	local children2 = {}

	for i = 1, #ChartHeaderNames do
		children2[ChartHeaderNames[i]] = Roact.createElement(HeaderButton, {
			text = ChartHeaderNames[i],
			size = udims2[i],
			pos = udims[i],
			sortfunction = props.onSortChanged
		})
	end

	children2.upperHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	children2.lowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, -LineWidth),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	for i = 2, #udims3 do
		children2[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = udims3[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	children.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = layoutOrder
		},
		{
			Header = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(0, v4, 0, HeaderFrameHeight),
					BackgroundTransparency = 1
				},
				children2
			),
			MainChart = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
				Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
				BackgroundTransparency = 1,
				VerticalScrollBarInset = 1,
				ScrollBarThickness = 5,
				CanvasSize = UDim2.new(0, v4, 0, total2),
				[Roact.Ref] = props.scrollingRef
			}, children)
		}
	)
end

return DataConsumer(extended, "ServerJobsData")
