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
local ChartHeaderNames = Constants.DataStoresFormatting.ChartHeaderNames
local ValueCellWidth = Constants.DataStoresFormatting.ValueCellWidth
local CellPadding = Constants.DataStoresFormatting.CellPadding
local ExpandArrowPadding = Constants.DataStoresFormatting.ExpandArrowPadding
local HeaderFrameHeight = Constants.DataStoresFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.DataStoresFormatting.EntryFrameHeight
local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight
local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr
local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)
local v20 = Roact.Component:extend("DataStoresChart")

local function getX(p1) -- line: 30
	return p1.time
end
local function getY(p2) -- line: 34
	return p2.value
end
local function stringFormatY(p3) -- line: 38
	return (math.ceil(p3))
end

function v20.init(p4, p5) -- line: 42
	local v29, v30 = p5.DataStoresData:getCurrentData()

	function p4.getOnButtonPress(p6) -- line: 45
		-- upvalues: p4 (copy)
		return function(_, _) -- line: 46
			-- upvalues: p4 (copy), p6 (copy)
			p4:setState({
				expandedEntry = p4.state.expandedEntry ~= p6 and p6
			})
		end
	end

	p4.state = {
		expandedEntry = nil,
		dataStoresData = v29,
		dataStoresDataCount = v30
	}
end
function v20.didMount(p9) -- line: 60
	p9.statsConnector = p9.props.DataStoresData:Signal():Connect(function(p10, p11) -- line: 61
		-- upvalues: p9 (copy)
		p9:setState({
			dataStoresData = p10,
			dataStoresDataCount = p11
		})
	end)
end
function v20.willUnmount(p12) -- line: 69
	p12.statsConnector:Disconnect()
	p12.statsConnector = nil
end
function v20.render(p13) -- line: 74
	-- upvalues: Roact (copy), HeaderFrameHeight (copy), EntryFrameHeight (copy), LineGraphHeight (copy), BannerButton (copy), CellLabel (copy), ValueCellWidth (copy), CellPadding (copy), ExpandArrowPadding (copy), LineWidth (copy), LineColor (copy), LineGraph (copy), getX (copy), getY (copy), convertTimeStamp (copy), stringFormatY (copy), Constants (copy), NoResultSearchStr (copy), ChartHeaderNames (copy)
	local t1 = {}
	local searchTerm = p13.props.searchTerm
	local size = p13.props.size
	local layoutOrder = p13.props.layoutOrder
	local expandedEntry = p13.state.expandedEntry

	t1.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v39 = HeaderFrameHeight
	local dataStoresData = p13.state.dataStoresData
	local n1 = 0
	local n2 = 1

	if dataStoresData then
		for k, v in pairs(dataStoresData) do
			n1 += 1

			if not searchTerm or string.find(k:lower(), searchTerm:lower()) ~= nil then
				n2 += 1

				local v45 = expandedEntry == k
				local v46 = v45 and EntryFrameHeight + LineGraphHeight or EntryFrameHeight

				t1[k] = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v46),
					LayoutOrder = n2
				}, {
					DataButton = Roact.createElement(BannerButton, {
						size = UDim2.new(1, 0, 0, EntryFrameHeight),
						pos = UDim2.new(),
						isExpanded = v45,
						onButtonPress = p13.getOnButtonPress(k)
					}, {
						[k] = Roact.createElement(CellLabel, {
							text = k,
							size = UDim2.new(1 - ValueCellWidth, -CellPadding - ExpandArrowPadding, 1, 0),
							pos = UDim2.new(0, CellPadding + ExpandArrowPadding, 0, 0)
						}),
						Data = Roact.createElement(CellLabel, {
							text = v.dataSet:back().value,
							size = UDim2.new(ValueCellWidth, -CellPadding, 1, 0),
							pos = UDim2.new(1 - ValueCellWidth, CellPadding, 0, 0)
						}),
						VerticalLine = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(0, LineWidth, 0, EntryFrameHeight),
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
					Graph = v45 and Roact.createElement(LineGraph, {
						axisLabelX = "Timestamp",
						pos = UDim2.new(0, 0, 0, EntryFrameHeight),
						size = UDim2.new(1, 0, 1, -EntryFrameHeight),
						graphData = v.dataSet,
						maxY = v.max,
						minY = v.min,
						getX = getX,
						getY = getY,
						axisLabelY = k,
						stringFormatX = convertTimeStamp,
						stringFormatY = stringFormatY
					})
				})
				v39 += EntryFrameHeight
			end
		end
	end

	if n2 == 1 then
		if n1 == 0 then
			return Roact.createElement("TextLabel", {
				Text = "Initialize DataStoresService to view DataStore Budget.",
				BackgroundTransparency = 1,
				Size = size,
				TextColor3 = Constants.Color.Text,
				LayoutOrder = layoutOrder
			})
		end

		local v47 = string.format(NoResultSearchStr, searchTerm)

		t1.emptyResult = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = size,
			Text = v47,
			TextColor3 = Constants.Color.Text
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
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
			vertical = Roact.createElement("Frame", {
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
			CanvasSize = UDim2.new(1, 0, 0, v39)
		}, t1)
	})
end

return DataConsumer(v20, "DataStoresData")
