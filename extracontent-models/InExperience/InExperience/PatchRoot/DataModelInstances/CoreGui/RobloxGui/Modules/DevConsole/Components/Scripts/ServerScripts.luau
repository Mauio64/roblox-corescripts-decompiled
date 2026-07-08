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
local t1 = {}
local t2 = {}
local t3 = {}
local n1 = 0

for _, v in ipairs(ChartCellWidths) do
	table.insert(t1, UDim2.new(n1, CellPadding, 0, 0))
	table.insert(t2, UDim2.new(v, -CellPadding, 0, HeaderFrameHeight))
	table.insert(t3, UDim2.new(v, -CellPadding, 0, EntryFrameHeight))
	n1 += v
end

local t4 = {}

for i, v in ipairs(t1) do
	t4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local v26 = Roact.Component:extend("ServerScripts")

local function constructHeader(p1) -- line: 45
	-- upvalues: ChartHeaderNames (copy), Roact (copy), HeaderButton (copy), t2 (copy), t1 (copy), LineWidth (copy), LineColor (copy), t4 (copy), HeaderFrameHeight (copy)
	local t5 = {}

	for i = 1, #ChartHeaderNames do
		t5[ChartHeaderNames[i]] = Roact.createElement(HeaderButton, {
			text = ChartHeaderNames[i],
			size = t2[i],
			pos = t1[i],
			sortfunction = p1
		})
	end

	t5.upperHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = LineColor
	})
	t5.verticalLine1 = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, LineWidth, 1, 0),
		Position = t4[2],
		BackgroundColor3 = LineColor
	})
	t5.verticalLine2 = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(0, LineWidth, 1, 0),
		Position = t4[3],
		BackgroundColor3 = LineColor
	})
	t5.lowerHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = LineColor
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, HeaderFrameHeight)
	}, t5)
end
local function getX(p2) -- line: 91
	return p2.time
end
local function getActivity(p3) -- line: 95
	return p3.data[1]
end
local function getRate(p4) -- line: 99
	return p4.data[2]
end
local function formatScriptsData(p5) -- line: 103
	return string.format("%.3f", p5)
end

function v26.init(p6, p7) -- line: 107
	-- upvalues: Roact (copy)
	local v41 = p7.ServerScriptsData:getCurrentData()

	function p6.onSortChanged(p8) -- line: 110
		-- upvalues: p7 (copy), p6 (copy)
		if p8 == p7.ServerScriptsData:getSortType() then
			p6:setState({
				reverseSort = not p6.state.reverseSort
			})

			return
		end

		p7.ServerScriptsData:setSortType(p8)
		p6:setState({
			reverseSort = false
		})
	end
	function p6.getOnButtonPress(p9) -- line: 124
		-- upvalues: p6 (copy)
		return function(_, _) -- line: 125
			-- upvalues: p6 (copy), p9 (copy)
			p6:setState({
				expandIndex = p6.state.expandIndex ~= p9 and p9
			})
		end
	end
	function p6.onCanvasPosChanged() -- line: 132
		-- upvalues: p6 (copy)
		local CanvasPosition = p6.scrollingRef.current.CanvasPosition

		if CanvasPosition ~= p6.state.canvasPos then
			p6:setState({
				absScrollSize = p6.scrollingRef.current.AbsoluteSize,
				canvasPos = CanvasPosition
			})
		end
	end

	p6.scrollingRef = Roact.createRef()
	p6.state = {
		expandIndex = nil,
		serverScriptsData = v41
	}
end
function v26.willUpdate(p12) -- line: 150
	if p12.canvasPosConnector then
		p12.canvasPosConnector:Disconnect()
	end
end
function v26.didUpdate(p13) -- line: 156
	if p13.scrollingRef.current then
		p13.canvasPosConnector = p13.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p13.onCanvasPosChanged)
	end
end
function v26.didMount(p14) -- line: 163
	p14.statsConnector = p14.props.ServerScriptsData:Signal():Connect(function(p15) -- line: 164
		-- upvalues: p14 (copy)
		p14:setState({
			serverScriptsData = p15
		})
	end)

	if p14.scrollingRef.current then
		p14.canvasPosConnector = p14.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p14.onCanvasPosChanged)
		p14:setState({
			absScrollSize = p14.scrollingRef.current.AbsoluteSize,
			canvasPos = p14.scrollingRef.current.CanvasPosition
		})
	end
end
function v26.willUnmount(p16) -- line: 181
	p16.statsConnector:Disconnect()
	p16.statsConnector = nil
end
function v26.render(p17) -- line: 186
	-- upvalues: Roact (copy), Constants (copy), EntryFrameHeight (copy), LineGraphHeight (copy), ServerScriptsEntry (copy), t3 (copy), t1 (copy), t4 (copy), formatScriptsData (copy), getX (copy), getActivity (copy), getRate (copy), NoResultSearchStr (copy), constructHeader (copy), HeaderFrameHeight (copy)
	local searchTerm = p17.props.searchTerm
	local scriptFilters = p17.props.scriptFilters
	local layoutOrder = p17.props.layoutOrder
	local size = p17.props.size
	local serverScriptsData = p17.state.serverScriptsData
	local reverseSort = p17.state.reverseSort
	local absScrollSize = p17.state.absScrollSize
	local canvasPos = p17.state.canvasPos
	local t6 = {}
	local v56 = #serverScriptsData

	if v56 == 0 then
		return Roact.createElement("TextLabel", {
			Text = "Awaiting Server Scripts Information.",
			BackgroundTransparency = 1,
			Size = size,
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			LayoutOrder = layoutOrder
		})
	end

	local n2 = 0
	local n3 = -1
	local n4 = 0
	local n5 = 0

	if canvasPos and absScrollSize then
		for k, v in pairs(serverScriptsData) do
			if not searchTerm or string.find(v.name:lower(), searchTerm:lower()) ~= nil then
				n5 += 1

				local v63 = true
				local scriptFiltersActive = scriptFilters.Active
				local Inactive = scriptFilters.Inactive
				local v66 = v.dataStats.dataSet:back()

				if scriptFiltersActive ~= Inactive then
					if v66.data[1] > 0 and Inactive then
						v63 = false
					elseif v66.data[1] == 0 and scriptFiltersActive then
						v63 = false
					end
				end

				if v63 then
					local v67 = p17.state.expandIndex == v.name
					local v68 = v67 and EntryFrameHeight + 2 * LineGraphHeight or EntryFrameHeight

					if n2 + v68 >= canvasPos.Y then
						if n4 < absScrollSize.Y then
							local v69 = v66.data[1] > 0 and Constants.Color.ActiveBox or Constants.Color.InactiveBox
							local v70 = reverseSort and v56 - k or k

							t6[k] = Roact.createElement(ServerScriptsEntry, {
								scriptData = v,
								frameHeight = v68,
								showGraph = v67,
								layoutOrder = v70,
								activityBoxColor = v69,
								entryCellSize = t3,
								cellOffset = t1,
								verticalOffsets = t4,
								onButtonPress = p17.getOnButtonPress(v.name),
								formatScriptsData = formatScriptsData,
								getX = getX,
								getActivity = getActivity,
								getRate = getRate,
								stringFormatY = formatScriptsData
							})
						end

						if n3 < 0 then
							n3 = n2
						else
							n4 += v68
						end
					end

					n2 += v68
				end
			end
		end

		if n5 > 0 then
			t6.WindowingPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, n3)
			})
		else
			local v71 = string.format(NoResultSearchStr, searchTerm)

			t6.emptySearch = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = size,
				Text = v71,
				TextColor3 = Constants.Color.Text
			})
		end
	end

	t6.UIListLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = constructHeader(p17.onSortChanged),
		Entries = Roact.createElement("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = 1,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.new(1, 0, 0, n2),
			[Roact.Ref] = p17.scrollingRef
		}, t6)
	})
end

return DataConsumer(v26, "ServerScriptsData")
