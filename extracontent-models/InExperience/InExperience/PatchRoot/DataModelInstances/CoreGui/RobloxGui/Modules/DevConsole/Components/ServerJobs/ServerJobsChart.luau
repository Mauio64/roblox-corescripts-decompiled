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
local t1 = {
	function(p1) -- line: 27
		return p1 and string.format("%.4f%%", p1) or ""
	end,
	function(p2) -- line: 30
		return p2 and string.format("%.4f/s", p2) or ""
	end,
	function(p3) -- line: 33
		return p3 and string.format("%.4fms", p3) or ""
	end
}
local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr
local n1 = 0
local t2 = {}
local t3 = {}
local v25 = EntryFrameHeight - LineWidth

for _, v in ipairs(ValueCellWidth) do
	table.insert(t2, UDim2.new(n1, CellPadding, 0, 0))
	table.insert(t3, UDim2.new(v, -CellPadding, 0, HeaderFrameHeight))
	table.insert({}, UDim2.new(v, -CellPadding, 0, v25))
	n1 += v
end

local t4 = {}

for i, v in ipairs(t2) do
	t4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local v31 = Roact.Component:extend("ServerJobsChart")

local function getX(p4) -- line: 63
	return p4.time
end
local function getDutyCycle(p5) -- line: 67
	return p5.data[1]
end
local function getStepsPerSec(p6) -- line: 71
	return p6.data[2]
end
local function getStepTime(p7) -- line: 75
	return p7.data[3]
end

function v31.init(p8, p9) -- line: 79
	-- upvalues: Roact (copy)
	local v45 = p9.ServerJobsData:getCurrentData()

	function p8.getOnButtonPress(p10) -- line: 82
		-- upvalues: p8 (copy)
		return function(_, _) -- line: 83
			-- upvalues: p8 (copy), p10 (copy)
			p8:setState({
				expandIndex = p8.state.expandIndex ~= p10 and p10
			})
		end
	end
	function p8.onSortChanged(p13) -- line: 90
		-- upvalues: p9 (copy), p8 (copy)
		if p13 == p9.ServerJobsData:getSortType() then
			p8:setState({
				reverseSort = not p8.state.reverseSort
			})

			return
		end

		p9.ServerJobsData:setSortType(p13)
		p8:setState({
			reverseSort = false
		})
	end
	function p8.onCanvasPosChanged() -- line: 104
		-- upvalues: p8 (copy)
		local CanvasPosition = p8.scrollingRef.current.CanvasPosition

		if CanvasPosition ~= p8.state.canvasPos then
			p8:setState({
				canvasPos = CanvasPosition
			})
		end
	end

	p8.scrollingRef = Roact.createRef()
	p8.state = {
		reverseSort = false,
		expandIndex = nil,
		serverJobsList = v45
	}
end
function v31.willUpdate(p14) -- line: 122
	if p14.canvasPosConnector then
		p14.canvasPosConnector:Disconnect()
	end
end
function v31.didUpdate(p15) -- line: 128
	if p15.scrollingRef.current then
		p15.canvasPosConnector = p15.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p15.onCanvasPosChanged)

		local AbsoluteSize = p15.scrollingRef.current.AbsoluteSize
		local absScrollSize = p15.state.absScrollSize

		if AbsoluteSize.X ~= absScrollSize.X or AbsoluteSize.Y ~= absScrollSize.Y then
			p15:setState({
				absScrollSize = AbsoluteSize
			})
		end
	end
end
function v31.didMount(p16) -- line: 143
	p16.statsConnector = p16.props.ServerJobsData:Signal():Connect(function(p17) -- line: 144
		-- upvalues: p16 (copy)
		p16:setState({
			serverJobsList = p17
		})
	end)

	if p16.scrollingRef.current then
		p16.canvasPosConnector = p16.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p16.onCanvasPosChanged)
		p16:setState({
			absScrollSize = p16.scrollingRef.current.AbsoluteSize,
			canvasPos = p16.scrollingRef.current.CanvasPosition
		})
	end
end
function v31.willUnmount(p18) -- line: 161
	p18.statsConnector:Disconnect()
	p18.statsConnector = nil

	if p18.canvasPosConnector then
		p18.canvasPosConnector:Disconnect()
		p18.canvasPosConnector = nil
	end
end
function v31.render(p19) -- line: 170
	-- upvalues: MinFrameWidth (copy), Roact (copy), Constants (copy), EntryFrameHeight (copy), LineGraphHeight (copy), CellPadding (copy), CellLabel (copy), t3 (copy), t2 (copy), ChartHeaderNames (copy), t1 (copy), t4 (copy), LineWidth (copy), LineColor (copy), BannerButton (copy), LineGraph (copy), getX (copy), getDutyCycle (copy), convertTimeStamp (copy), getStepsPerSec (copy), getStepTime (copy), NoResultSearchStr (copy), HeaderButton (copy), HeaderFrameHeight (copy)
	local t5 = {}
	local searchTerm = p19.props.searchTerm
	local size = p19.props.size
	local layoutOrder = p19.props.layoutOrder
	local serverJobsList = p19.state.serverJobsList
	local reverseSort = p19.state.reverseSort
	local expandIndex = p19.state.expandIndex
	local canvasPos = p19.state.canvasPos
	local absScrollSize = p19.state.absScrollSize
	local v62 = absScrollSize and math.max(absScrollSize.X, MinFrameWidth) or MinFrameWidth
	local v63 = #serverJobsList

	if v63 == 0 then
		return Roact.createElement("TextLabel", {
			Text = "Awaiting Server Jobs Information",
			BackgroundTransparency = 1,
			Size = size,
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			LayoutOrder = layoutOrder
		})
	end

	local n2 = 0

	if absScrollSize then
		local n3 = -1
		local n4 = 0

		for k, v in pairs(serverJobsList) do
			local name = v.name

			if not searchTerm or string.find(name:lower(), searchTerm:lower()) ~= nil then
				local dataStats = v.dataStats
				local v71 = dataStats.dataSet:back()
				local v72 = expandIndex == name
				local v73 = v72 and EntryFrameHeight + 3 * LineGraphHeight / 2 + CellPadding * 4 or EntryFrameHeight

				if n2 + v73 >= canvasPos.Y then
					if n4 < absScrollSize.Y then
						local v74 = reverseSort and v63 - k or k
						local t6 = {
							[name] = Roact.createElement(CellLabel, {
								text = name,
								size = t3[1],
								pos = t2[1]
							})
						}

						for k2, v2 in pairs(v71.data) do
							t6[ChartHeaderNames[k2]] = Roact.createElement(CellLabel, {
								text = t1[k2](v2),
								size = t3[k2 + 1],
								pos = t2[k2 + 1]
							})
						end

						for i = 2, #t4 do
							t6[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
								BorderSizePixel = 0,
								Size = UDim2.new(0, LineWidth, 1, 0),
								Position = t4[i],
								BackgroundColor3 = LineColor
							})
						end

						t6.lowerHorizontalLine = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, LineWidth),
							Position = UDim2.new(0, 0, 1, 0),
							BackgroundColor3 = LineColor
						})
						t5[name] = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(0, v62, 0, v73),
							LayoutOrder = v74 + 1
						}, {
							Button = Roact.createElement(BannerButton, {
								size = UDim2.new(1, 0, 0, EntryFrameHeight),
								pos = UDim2.new(),
								isExpanded = v72,
								onButtonPress = p19.getOnButtonPress(name)
							}, t6),
							DutyCycleGraph = v72 and Roact.createElement(LineGraph, {
								axisLabelX = "Timestamp",
								pos = UDim2.new(0, 0, 0, EntryFrameHeight + CellPadding),
								size = UDim2.new(0, v62, 0, LineGraphHeight / 2),
								graphData = dataStats.dataSet,
								maxY = dataStats.max[1],
								minY = dataStats.min[1],
								getX = getX,
								getY = getDutyCycle,
								stringFormatX = convertTimeStamp,
								stringFormatY = t1[1],
								axisLabelY = name .. " " .. ChartHeaderNames[2]
							}),
							StepsPerSecGraph = v72 and Roact.createElement(LineGraph, {
								axisLabelX = "Timestamp",
								pos = UDim2.new(0, 0, 0, EntryFrameHeight + LineGraphHeight / 2 + CellPadding * 2),
								size = UDim2.new(0, v62, 0, LineGraphHeight / 2),
								graphData = dataStats.dataSet,
								maxY = dataStats.max[2],
								minY = dataStats.min[2],
								getX = getX,
								getY = getStepsPerSec,
								stringFormatX = convertTimeStamp,
								stringFormatY = t1[2],
								axisLabelY = name .. " " .. ChartHeaderNames[3]
							}),
							StepTimeGraph = v72 and Roact.createElement(LineGraph, {
								axisLabelX = "Timestamp",
								pos = UDim2.new(0, 0, 0, EntryFrameHeight + LineGraphHeight + CellPadding * 3),
								size = UDim2.new(0, v62, 0, LineGraphHeight / 2),
								graphData = dataStats.dataSet,
								maxY = dataStats.max[3],
								minY = dataStats.min[3],
								getX = getX,
								getY = getStepTime,
								stringFormatX = convertTimeStamp,
								stringFormatY = t1[3],
								axisLabelY = name .. " " .. ChartHeaderNames[4]
							})
						})
					end

					if n3 < 0 then
						n3 = n2
					else
						n4 += v73
					end
				end

				n2 += v73
			end
		end

		if n3 == -1 then
			local v79 = string.format(NoResultSearchStr, searchTerm)

			t5.emptyResult = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = size,
				Text = v79,
				TextColor3 = Constants.Color.Text
			})
		else
			t5.WindowingPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, n3)
			})
		end
	end

	local t7 = {}

	for i = 1, #ChartHeaderNames do
		t7[ChartHeaderNames[i]] = Roact.createElement(HeaderButton, {
			text = ChartHeaderNames[i],
			size = t3[i],
			pos = t2[i],
			sortfunction = p19.onSortChanged
		})
	end

	t7.upperHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = LineColor
	})
	t7.lowerHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, -LineWidth),
		BackgroundColor3 = LineColor
	})

	for i = 2, #t4 do
		t7[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = t4[i],
			BackgroundColor3 = LineColor
		})
	end

	t5.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v62, 0, HeaderFrameHeight)
		}, t7),
		MainChart = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = 1,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.new(0, v62, 0, n2),
			[Roact.Ref] = p19.scrollingRef
		}, t5)
	})
end

return DataConsumer(v31, "ServerJobsData")
