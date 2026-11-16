local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)

local ChartHeaderNames = Constants.NetworkFormatting.ChartHeaderNames
local ChartCellWidths = Constants.NetworkFormatting.ChartCellWidths
local CellPadding = Constants.NetworkFormatting.CellPadding
local HeaderFrameHeight = Constants.NetworkFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.NetworkFormatting.EntryFrameHeight
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local MainWindow = Constants.DefaultFontSize.MainWindow
local mainWindow = Constants.Font.MainWindow
local ResponseStrHeight = Constants.NetworkFormatting.ResponseStrHeight
local ResponseWidthRatio = Constants.NetworkFormatting.ResponseWidthRatio

local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local NetworkChartEntry = require(script.Parent.NetworkChartEntry)
local total = 0

for _, chartCellWidth in pairs(ChartCellWidths) do
	total += chartCellWidth
end

local udims = {}
local total2 = 0
local udims2 = {}
local udims3 = {}

for _, chartCellWidth in ipairs(ChartCellWidths) do
	table.insert(udims, UDim2.new(0, total2 + CellPadding, 0, 0))
	table.insert(udims2, UDim2.new(0, chartCellWidth - CellPadding, 0, HeaderFrameHeight))
	table.insert(udims3, UDim2.new(0, chartCellWidth - CellPadding, 0, EntryFrameHeight))
	total2 += chartCellWidth
end

table.insert(udims, UDim2.new(0, total2 + CellPadding, 0, 0))
table.insert(udims2, UDim2.new(1, -total - CellPadding, 0, HeaderFrameHeight))
table.insert(udims3, UDim2.new(1, -total - CellPadding, 0, EntryFrameHeight))

local udims4 = {}

for i, v in ipairs(udims) do
	udims4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local extended = Roact.Component:extend("NetworkChart")

function extended:init()
	function self.getOnExpandEntry(p)
		return function(_, _)
			self:setState({
				expandIndex = self.state.expandIndex ~= p and p
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

	self.ref = Roact.createRef()
	self.scrollingRef = Roact.createRef()

	self.state = { expandIndex = false }
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

		if self.state.absScrollSize ~= absoluteSize then
			self:setState({ absScrollSize = absoluteSize })
		end
	end
end

function extended:didMount()
	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)

		self:setState({
			absScrollSize = self.scrollingRef.current.AbsoluteSize,
			canvasPos = self.scrollingRef.current.CanvasPosition
		})
	end
end

function extended.render(props)
	local httpEntryList = props.props.httpEntryList or {}
	local chartHeight = props.props.chartHeight
	local width = props.props.width
	local searchTerm = props.props.searchTerm
	local layoutOrder = props.props.layoutOrder
	local reverseSort = props.props.reverseSort

	local onSortChanged = props.props.onSortChanged

	local expandIndex = props.state.expandIndex
	local absScrollSize = props.state.absScrollSize
	local canvasPos = props.state.canvasPos

	local children = {}

	for i, chartHeaderName in ipairs(ChartHeaderNames) do
		children[chartHeaderName] = Roact.createElement(HeaderButton, {
			text = chartHeaderName,
			size = udims2[i],
			pos = udims[i],
			sortfunction = onSortChanged
		})
	end

	for i = 2, #udims4 do
		children[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 0, HeaderFrameHeight),
			Position = udims4[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	local children2 = {}
	local total3 = 0
	local v = -1
	local total4 = 0

	local count = #httpEntryList
	local count2 = 0
	children2.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	if canvasPos and absScrollSize then
		for i, httpEntry in ipairs(httpEntryList) do
			local v2

			if searchTerm == "" then
				v2 = true
			elseif string.find(httpEntry.RequestType:lower(), searchTerm:lower()) ~= nil then
				v2 = true
			else
				v2 = string.find(httpEntry.Url:lower(), searchTerm:lower()) ~= nil
			end

			if not (httpEntry.RequestType ~= "Default" and v2) then
				continue
			end

			count2 += 1

			local showResponse = expandIndex == httpEntry.Num
			local v3 = EntryFrameHeight
			local responseBodyHeight = 0

			if showResponse then
				v3 += ResponseStrHeight

				if props.ref.current then
					local vector2 = Vector2.new(props.ref.current.AbsoluteSize.X * ResponseWidthRatio, 100000000)
					responseBodyHeight = ResponseStrHeight + TextService:GetTextSize(
						httpEntry.Response,
						MainWindow,
						mainWindow,
						vector2
					).Y
					v3 += responseBodyHeight
				end
			end

			if total3 + v3 >= canvasPos.Y then
				if total4 < absScrollSize.Y then
					local v4

					if reverseSort then
						v4 = count - i or i
					else
						v4 = i
					end

					children2[i] = Roact.createElement(NetworkChartEntry, {
						size = UDim2.new(1, 0, 0, v3),
						entry = httpEntry,
						entryCellSize = udims3,
						cellOffset = udims,
						verticalOffsets = udims4,
						showResponse = showResponse,
						responseBodyHeight = responseBodyHeight,
						layoutOrder = v4 + 1,
						onButtonPress = props.getOnExpandEntry(httpEntry.Num)
					})
				end

				if v < 0 then
					v = total3
				else
					total4 += v3
				end
			end

			total3 += v3
		end

		if count2 > 0 then
			children2.WindowingPadding = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		end
	end

	if count == 0 or count2 == 0 then
		children2["NONE FOUND"] = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, chartHeight),
			Text = "No Network Entries Found",
			TextColor3 = Constants.Color.Text,
			BackgroundTransparency = 1
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, chartHeight),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = props.ref
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, HeaderFrameHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			children
		),
		HorizontalLine_1 = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, LineWidth),
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			LayoutOrder = 2
		}),
		scrollingFrameEntries = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			CanvasSize = UDim2.new(0, width, 0, total3),
			ScrollBarThickness = 6,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			[Roact.Ref] = props.scrollingRef
		}, children2)
	})
end

return extended
