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
local MainWindow2 = Constants.Font.MainWindow
local ResponseStrHeight = Constants.NetworkFormatting.ResponseStrHeight
local ResponseWidthRatio = Constants.NetworkFormatting.ResponseWidthRatio
local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local NetworkChartEntry = require(script.Parent.NetworkChartEntry)
local n1 = 0

for _, v in pairs(ChartCellWidths) do
	n1 += v
end

local n2 = 0
local t1 = {}
local t2 = {}
local t3 = {}

for _, v in ipairs(ChartCellWidths) do
	table.insert(t1, UDim2.new(0, n2 + CellPadding, 0, 0))
	table.insert(t2, UDim2.new(0, v - CellPadding, 0, HeaderFrameHeight))
	table.insert(t3, UDim2.new(0, v - CellPadding, 0, EntryFrameHeight))
	n2 += v
end

table.insert(t1, UDim2.new(0, n2 + CellPadding, 0, 0))
table.insert(t2, UDim2.new(1, -n1 - CellPadding, 0, HeaderFrameHeight))
table.insert(t3, UDim2.new(1, -n1 - CellPadding, 0, EntryFrameHeight))

local t4 = {}

for i, v in ipairs(t1) do
	t4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local v31 = Roact.Component:extend("NetworkChart")

function v31.init(p1) -- line: 57
	-- upvalues: Roact (copy)
	function p1.getOnExpandEntry(p2) -- line: 58
		-- upvalues: p1 (copy)
		return function(_, _) -- line: 59
			-- upvalues: p1 (copy), p2 (copy)
			p1:setState({
				expandIndex = p1.state.expandIndex ~= p2 and p2
			})
		end
	end
	function p1.onCanvasPosChanged() -- line: 66
		-- upvalues: p1 (copy)
		local CanvasPosition = p1.scrollingRef.current.CanvasPosition

		if CanvasPosition ~= p1.state.canvasPos then
			p1:setState({
				absScrollSize = p1.scrollingRef.current.AbsoluteSize,
				canvasPos = CanvasPosition
			})
		end
	end

	p1.ref = Roact.createRef()
	p1.scrollingRef = Roact.createRef()
	p1.state = {
		expandIndex = false
	}
end
function v31.willUpdate(p5) -- line: 84
	if p5.canvasPosConnector then
		p5.canvasPosConnector:Disconnect()
	end
end
function v31.didUpdate(p6) -- line: 90
	if p6.scrollingRef.current then
		p6.canvasPosConnector = p6.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p6.onCanvasPosChanged)

		local AbsoluteSize = p6.scrollingRef.current.AbsoluteSize

		if AbsoluteSize ~= p6.state.absScrollSize then
			p6:setState({
				absScrollSize = AbsoluteSize
			})
		end
	end
end
function v31.didMount(p7) -- line: 104
	if p7.scrollingRef.current then
		p7.canvasPosConnector = p7.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p7.onCanvasPosChanged)
		p7:setState({
			absScrollSize = p7.scrollingRef.current.AbsoluteSize,
			canvasPos = p7.scrollingRef.current.CanvasPosition
		})
	end
end
function v31.render(p8) -- line: 116
	-- upvalues: ChartHeaderNames (copy), Roact (copy), HeaderButton (copy), t2 (copy), t1 (copy), t4 (copy), LineWidth (copy), HeaderFrameHeight (copy), LineColor (copy), EntryFrameHeight (copy), ResponseStrHeight (copy), ResponseWidthRatio (copy), TextService (copy), MainWindow (copy), MainWindow2 (copy), NetworkChartEntry (copy), t3 (copy), Constants (copy)
	local v38 = p8.props.httpEntryList or {}
	local chartHeight = p8.props.chartHeight
	local width = p8.props.width
	local searchTerm = p8.props.searchTerm
	local layoutOrder = p8.props.layoutOrder
	local reverseSort = p8.props.reverseSort
	local onSortChanged = p8.props.onSortChanged
	local expandIndex = p8.state.expandIndex
	local absScrollSize = p8.state.absScrollSize
	local canvasPos = p8.state.canvasPos
	local t5 = {}

	for i, v in ipairs(ChartHeaderNames) do
		t5[v] = Roact.createElement(HeaderButton, {
			text = v,
			size = t2[i],
			pos = t1[i],
			sortfunction = onSortChanged
		})
	end

	for i = 2, #t4 do
		t5[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 0, HeaderFrameHeight),
			Position = t4[i],
			BackgroundColor3 = LineColor
		})
	end

	local t6 = {}
	local n3 = 0
	local n4 = -1
	local n5 = 0
	local v56 = #v38
	local n6 = 0

	t6.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	if canvasPos and absScrollSize then
		for i, v in ipairs(v38) do
			local v60 = searchTerm == "" or (string.find(v.RequestType:lower(), searchTerm:lower()) ~= nil or string.find(v.Url:lower(), searchTerm:lower()) ~= nil)

			if v.RequestType ~= "Default" and v60 then
				n6 += 1

				local v61 = expandIndex == v.Num
				local v62 = EntryFrameHeight
				local n7 = 0

				if v61 then
					v62 += ResponseStrHeight

					if p8.ref.current then
						local vector2 = Vector2.new(p8.ref.current.AbsoluteSize.X * ResponseWidthRatio, 100000000)
						local TextSize = TextService:GetTextSize(v.Response, MainWindow, MainWindow2, vector2)

						n7 = ResponseStrHeight + TextSize.Y
						v62 += n7
					end
				end

				if n3 + v62 >= canvasPos.Y then
					if n5 < absScrollSize.Y then
						local v66 = reverseSort and v56 - i or i

						t6[i] = Roact.createElement(NetworkChartEntry, {
							size = UDim2.new(1, 0, 0, v62),
							entry = v,
							entryCellSize = t3,
							cellOffset = t1,
							verticalOffsets = t4,
							showResponse = v61,
							responseBodyHeight = n7,
							layoutOrder = v66 + 1,
							onButtonPress = p8.getOnExpandEntry(v.Num)
						})
					end

					if n4 < 0 then
						n4 = n3
					else
						n5 += v62
					end
				end

				n3 += v62
			end
		end

		if n6 > 0 then
			t6.WindowingPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, n4)
			})
		end
	end

	if v56 == 0 or n6 == 0 then
		t6["NONE FOUND"] = Roact.createElement("TextLabel", {
			Text = "No Network Entries Found",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, chartHeight),
			TextColor3 = Constants.Color.Text
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, chartHeight),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = p8.ref
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, HeaderFrameHeight)
		}, t5),
		HorizontalLine_1 = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, LineWidth),
			BackgroundColor3 = LineColor
		}),
		scrollingFrameEntries = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			CanvasSize = UDim2.new(0, width, 0, n3),
			ScrollBarThickness = 6,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			[Roact.Ref] = p8.scrollingRef
		}, t6)
	})
end

return v31
