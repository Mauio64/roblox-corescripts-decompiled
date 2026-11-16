local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(script.Parent.Parent.Parent.Components.DataConsumer)
local HeaderButton = require(Components.HeaderButton)

local ServerScriptsEntry = require(script.Parent.ServerScriptsEntry)

local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ChartCellWidths = Constants.ServerScriptsFormatting.ChartCellWidths
local ChartHeaderNames = Constants.ServerScriptsFormatting.ChartHeaderNames
local HeaderFrameHeight = Constants.ServerScriptsFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.ServerScriptsFormatting.EntryFrameHeight
local CellPadding = Constants.ServerScriptsFormatting.CellPadding

local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr

local udims = {}
local total = 0
local udims2 = {}
local udims3 = {}

for _, chartCellWidth in ipairs(ChartCellWidths) do
	table.insert(udims, UDim2.new(total, CellPadding, 0, 0))
	table.insert(udims2, UDim2.new(chartCellWidth, -CellPadding, 0, HeaderFrameHeight))
	table.insert(udims3, UDim2.new(chartCellWidth, -CellPadding, 0, EntryFrameHeight))
	total += chartCellWidth
end

local udims4 = {}

for i, v in ipairs(udims) do
	udims4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local extended = Roact.Component:extend("ServerScripts")

local function constructHeader(onSortChanged)
	local children = {}

	for i = 1, #ChartHeaderNames do
		children[ChartHeaderNames[i]] = Roact.createElement(HeaderButton, {
			text = ChartHeaderNames[i],
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

	children.verticalLine1 = Roact.createElement("Frame", {
		Size = UDim2.new(0, LineWidth, 1, 0),
		Position = udims4[2],
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	children.verticalLine2 = Roact.createElement("Frame", {
		Size = UDim2.new(0, LineWidth, 1, 0),
		Position = udims4[3],
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
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
			Size = UDim2.new(1, 0, 0, HeaderFrameHeight),
			BackgroundTransparency = 1
		},
		children
	)
end

local function getX(p)
	return p.time
end

local function getActivity(p)
	return p.data[1]
end

local function getRate(p)
	return p.data[2]
end

local function formatScriptsData(p)
	return string.format("%.3f", p)
end

function extended:init(p)
	local currentData = p.ServerScriptsData:getCurrentData()

	function self.onSortChanged(p2)
		if p2 == p.ServerScriptsData:getSortType() then
			self:setState({
				reverseSort = not self.state.reverseSort
			})
			return
		end

		p.ServerScriptsData:setSortType(p2)
		self:setState({ reverseSort = false })
	end

	function self.getOnButtonPress(p2)
		return function(_, _)
			self:setState({
				expandIndex = self.state.expandIndex ~= p2 and p2
			})
		end
	end

	function self.onCanvasPosChanged()
		local canvasPosition = self.scrollingRef.current.CanvasPosition

		if self.state.canvasPos ~= canvasPosition then
			self:setState({
				absScrollSize = self.scrollingRef.current.AbsoluteSize,
				canvasPos = canvasPosition
			})
		end
	end

	self.scrollingRef = Roact.createRef()

	self.state = { serverScriptsData = currentData, expandIndex = nil }
end

function extended.willUpdate(p)
	if p.canvasPosConnector then
		p.canvasPosConnector:Disconnect()
	end
end

function extended:didUpdate()
	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)
	end
end

function extended:didMount()
	self.statsConnector = self.props.ServerScriptsData:Signal():Connect(function(serverScriptsData)
		self:setState({ serverScriptsData = serverScriptsData })
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
end

function extended.render(props)
	local searchTerm = props.props.searchTerm
	local scriptFilters = props.props.scriptFilters
	local layoutOrder = props.props.layoutOrder
	local size = props.props.size

	local serverScriptsData = props.state.serverScriptsData
	local reverseSort = props.state.reverseSort
	local absScrollSize = props.state.absScrollSize
	local canvasPos = props.state.canvasPos

	local children = {}
	local count = #serverScriptsData

	if count == 0 then
		return Roact.createElement("TextLabel", {
			Size = size,
			Position = UDim2.new(0, 0, 0, 0),
			Text = "Awaiting Server Scripts Information.",
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		})
	end

	local total2 = 0
	local v = -1
	local total3 = 0
	local count2 = 0

	if canvasPos and absScrollSize then
		for k, scriptData in pairs(serverScriptsData) do
			if not (not searchTerm or string.find(scriptData.name:lower(), searchTerm:lower()) ~= nil) then
				continue
			end

			count2 += 1
			local flag = true
			local active = scriptFilters.Active
			local inactive = scriptFilters.Inactive
			local back = scriptData.dataStats.dataSet:back()

			if active ~= inactive then
				if back.data[1] > 0 and inactive then
					flag = false
				elseif back.data[1] == 0 and active then
					flag = false
				end
			end

			if not flag then
				continue
			end

			local showGraph = props.state.expandIndex == scriptData.name
			local frameHeight = showGraph and EntryFrameHeight + 2 * LineGraphHeight or EntryFrameHeight

			if total2 + frameHeight >= canvasPos.Y then
				if total3 < absScrollSize.Y then
					local activeBox = back.data[1] > 0 and Constants.Color.ActiveBox or Constants.Color.InactiveBox
					local layoutOrder2

					if reverseSort then
						layoutOrder2 = count - k or k
					else
						layoutOrder2 = k
					end

					children[k] = Roact.createElement(ServerScriptsEntry, {
						scriptData = scriptData,
						frameHeight = frameHeight,
						showGraph = showGraph,
						layoutOrder = layoutOrder2,
						activityBoxColor = activeBox,
						entryCellSize = udims3,
						cellOffset = udims,
						verticalOffsets = udims4,
						onButtonPress = props.getOnButtonPress(scriptData.name),
						formatScriptsData = formatScriptsData,
						getX = getX,
						getActivity = getActivity,
						getRate = getRate,
						stringFormatY = formatScriptsData
					})
				end

				if v < 0 then
					v = total2
				else
					total3 += frameHeight
				end
			end

			total2 += frameHeight
		end

		if count2 > 0 then
			children.WindowingPadding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		else
			local text = string.format(NoResultSearchStr, searchTerm)
			children.emptySearch = Roact.createElement("TextLabel", {
				Size = size,
				Text = text,
				TextColor3 = Constants.Color.Text,
				BackgroundTransparency = 1
			})
		end
	end

	children.UIListLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		Header = constructHeader(props.onSortChanged),
		Entries = Roact.createElement("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = 1,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.new(1, 0, 0, total2),
			[Roact.Ref] = props.scrollingRef
		}, children)
	})
end

return DataConsumer(extended, "ServerScriptsData")
