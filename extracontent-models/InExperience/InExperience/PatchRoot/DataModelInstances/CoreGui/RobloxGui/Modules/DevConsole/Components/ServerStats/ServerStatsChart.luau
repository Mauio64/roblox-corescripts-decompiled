local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)
local LineGraph = require(Components.LineGraph)
local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ChartHeaderNames = Constants.ServerStatsFormatting.ChartHeaderNames
local ValueCellWidth = Constants.ServerStatsFormatting.ValueCellWidth
local CellPadding = Constants.ServerStatsFormatting.CellPadding
local ExpandArrowPadding = Constants.ServerStatsFormatting.ExpandArrowPadding
local HeaderFrameHeight = Constants.ServerStatsFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.ServerStatsFormatting.EntryFrameHeight
local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight
local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr
local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)
local v20 = Roact.Component:extend("ServerStats")

local function formatData(p1) -- line: 29
	return string.format("%.3f", p1)
end
local function getX(p2) -- line: 32
	return p2.time
end
local function getY(p3) -- line: 36
	return p3.value
end

function v20.init(p4) -- line: 40
	local v28 = p4.props.ServerStatsData:getCurrentData()

	function p4.getOnButtonPress(p5) -- line: 43
		-- upvalues: p4 (copy)
		return function(_, _) -- line: 44
			-- upvalues: p4 (copy), p5 (copy)
			p4:setState({
				expandedEntry = p4.state.expandedEntry ~= p5 and p5
			})
		end
	end

	p4.state = {
		serverStatsData = v28
	}
end
function v20.didMount(p8) -- line: 56
	p8.statsConnector = p8.props.ServerStatsData:Signal():Connect(function(p9) -- line: 57
		-- upvalues: p8 (copy)
		p8:setState({
			serverStatsData = p9
		})
	end)
end
function v20.willUnmount(p10) -- line: 64
	p10.statsConnector:Disconnect()
	p10.statsConnector = nil
end
function v20.render(p11) -- line: 69
	-- upvalues: EntryFrameHeight (copy), LineGraphHeight (copy), Roact (copy), BannerButton (copy), CellLabel (copy), ValueCellWidth (copy), CellPadding (copy), ExpandArrowPadding (copy), LineWidth (copy), LineColor (copy), LineGraph (copy), getX (copy), getY (copy), convertTimeStamp (copy), formatData (copy), Constants (copy), NoResultSearchStr (copy), HeaderFrameHeight (copy), ChartHeaderNames (copy)
	local t1 = {}
	local searchTerm = p11.props.searchTerm
	local layoutOrder = p11.props.layoutOrder
	local size = p11.props.size
	local expandedEntry = p11.state.expandedEntry
	local serverStatsData = p11.state.serverStatsData
	local n1 = 1
	local n2 = 0
	local n3 = 0

	if serverStatsData then
		for k, v in pairs(serverStatsData) do
			n2 += 1

			if not searchTerm or string.find(k:lower(), searchTerm:lower()) ~= nil then
				n1 += 1

				local v43 = expandedEntry == k
				local v44 = v43 and EntryFrameHeight + LineGraphHeight or EntryFrameHeight

				n3 = v43 and n3 + 1 or n3

				local createElement = Roact.createElement
				local t2 = {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v44),
					LayoutOrder = n1
				}
				local t3 = {}
				local createElement2 = Roact.createElement
				local v49 = BannerButton
				local t4 = {
					size = UDim2.new(1, 0, 0, EntryFrameHeight),
					pos = UDim2.new(),
					isExpanded = v43,
					onButtonPress = p11.getOnButtonPress(k)
				}
				local t5 = {
					[k] = Roact.createElement(CellLabel, {
						text = k,
						size = UDim2.new(1 - ValueCellWidth, -CellPadding - ExpandArrowPadding, 1, 0),
						pos = UDim2.new(0, CellPadding + ExpandArrowPadding, 0, 0)
					})
				}
				local createElement3 = Roact.createElement
				local v53 = CellLabel
				local t6 = {}
				local value = v.dataSet:back().value

				t6.text = string.format("%.3f", value)
				t6.size = UDim2.new(ValueCellWidth, -CellPadding, 1, 0)
				t6.pos = UDim2.new(1 - ValueCellWidth, CellPadding, 0, 0)
				t5.Data = createElement3(v53, t6)
				t5.VerticalLine = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, LineWidth, 1, 0),
					Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
					BackgroundColor3 = LineColor
				})
				t5.HorizontalAlignment = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, LineWidth),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = LineColor
				})
				t3.DataButton = createElement2(v49, t4, t5)
				t3.Graph = v43 and Roact.createElement(LineGraph, {
					axisLabelX = "Timestamp",
					pos = UDim2.new(0, 0, 0, EntryFrameHeight),
					size = UDim2.new(1, 0, 1, -EntryFrameHeight),
					graphData = v.dataSet,
					minY = v.min,
					maxY = v.max,
					getX = getX,
					getY = getY,
					axisLabelY = k,
					stringFormatX = convertTimeStamp,
					stringFormatY = formatData
				})
				t1[k] = createElement("Frame", t2, t3)
			end
		end
	end

	if n1 == 1 then
		if n2 == 0 then
			return Roact.createElement("TextLabel", {
				Text = "Awaiting Server Stats",
				BackgroundTransparency = 1,
				Size = size,
				Position = UDim2.new(0, 0, 0, 0),
				TextColor3 = Constants.Color.Text,
				LayoutOrder = layoutOrder
			})
		end

		local v56 = string.format(NoResultSearchStr, searchTerm)

		t1.emptyResult = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = size,
			Text = v56,
			TextColor3 = Constants.Color.Text
		})
	end

	t1.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v57 = n2 * EntryFrameHeight + n3 * LineGraphHeight

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, HeaderFrameHeight)
		}, {
			[ChartHeaderNames[1]] = Roact.createElement(CellLabel, {
				text = ChartHeaderNames[1],
				size = UDim2.new(1 - ValueCellWidth, -CellPadding - ExpandArrowPadding, 1, 0),
				pos = UDim2.new(0, CellPadding + ExpandArrowPadding, 0, 0)
			}),
			[ChartHeaderNames[2]] = Roact.createElement(CellLabel, {
				text = ChartHeaderNames[2],
				size = UDim2.new(ValueCellWidth, -CellPadding, 1, 0),
				pos = UDim2.new(1 - ValueCellWidth, CellPadding, 0, 0)
			}),
			upperHorizontalLine = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				BackgroundColor3 = LineColor
			}),
			VerticalLine = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
				BackgroundColor3 = LineColor
			}),
			lowerHorizontalLine = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor
			})
		}),
		mainFrame = Roact.createElement("ScrollingFrame", {
			ScrollBarThickness = 5,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			CanvasSize = UDim2.new(1, 0, 0, v57)
		}, t1)
	})
end

return DataConsumer(v20, "ServerStatsData")
