local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)

local SummaryHeaderNames = Constants.NetworkFormatting.SummaryHeaderNames
local SummaryCellWidths = Constants.NetworkFormatting.SummaryCellWidths
local HeaderFrameHeight = Constants.NetworkFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.NetworkFormatting.EntryFrameHeight

local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local CellPadding = Constants.NetworkFormatting.CellPadding
local Text = Constants.Color.Text

local CellLabel = require(script.Parent.Parent.Parent.Components.CellLabel)
local HeaderButton = require(script.Parent.Parent.Parent.Components.HeaderButton)
local total = 0

for _, summaryCellWidth in pairs(SummaryCellWidths) do
	total += summaryCellWidth
end

local v = -total
local udims = {}
local udims2 = {}
local udims3 = {}

table.insert(udims, UDim2.new(0, CellPadding, 0, 0))
table.insert(udims2, UDim2.new(1, -total - CellPadding, 0, HeaderFrameHeight))
table.insert(udims3, UDim2.new(1, -total - CellPadding, 0, EntryFrameHeight))

for _, summaryCellWidth in ipairs(SummaryCellWidths) do
	table.insert(udims, UDim2.new(1, v + CellPadding, 0, 0))
	table.insert(udims2, UDim2.new(0, summaryCellWidth - CellPadding, 0, HeaderFrameHeight))
	table.insert(udims3, UDim2.new(0, summaryCellWidth - CellPadding, 0, EntryFrameHeight))
	v += summaryCellWidth
end

local udims4 = {}

for i, v2 in ipairs(udims) do
	udims4[i] = UDim2.new(v2.X.Scale, v2.X.Offset - CellPadding, v2.Y.Scale, v2.Y.Offset)
end

local extended = Roact.Component:extend("NetworkSummary")

function extended.render(p)
	local width = p.props.width
	local httpSummaryTable = p.props.httpSummaryTable or {}
	local layoutOrder = p.props.layoutOrder

	local children = {}
	children.UIListLayout = Roact.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local children2 = {}
	children2.UpperHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	children2.LowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	for i = 2, #udims4 do
		children2[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 0, HeaderFrameHeight),
			Position = udims4[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	for i, summaryHeaderName in ipairs(SummaryHeaderNames) do
		children2[summaryHeaderName] = Roact.createElement(HeaderButton, {
			text = summaryHeaderName,
			size = udims2[i],
			pos = udims[i]
		})
	end

	children.Header = Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(0, width, 0, HeaderFrameHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		},
		children2
	)
	local v2 = 0

	for _, v3 in pairs(httpSummaryTable) do
		v2 += 1

		local children3 = {
			["RequestType"] = Roact.createElement(CellLabel, {
				text = v3.RequestType,
				size = udims2[1],
				pos = udims[1]
			}),
			RequestCount = Roact.createElement(CellLabel, {
				text = v3.RequestCount,
				size = udims2[2],
				pos = udims[2]
			}),
			FailedCount = Roact.createElement(CellLabel, {
				text = v3.FailedCount,
				size = udims2[3],
				pos = udims[3]
			}),
			AverageTime = Roact.createElement(CellLabel, {
				text = string.format("%.3f", v3.AverageTime),
				size = udims2[4],
				pos = udims[4]
			}),
			MinTime = Roact.createElement(CellLabel, {
				text = string.format("%.3f", v3.MinTime),
				size = udims2[5],
				pos = udims[5]
			}),
			MaxTime = Roact.createElement(CellLabel, {
				text = string.format("%.3f", v3.MaxTime),
				size = udims2[6],
				pos = udims[6]
			}),
			LowerHorizontalLine = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor,
				BorderSizePixel = 0
			})
		}

		for i = 2, #udims4 do
			children3[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = udims4[i],
				BackgroundColor3 = LineColor,
				BorderSizePixel = 0
			})
		end

		children[v3.RequestType] = Roact.createElement("Frame", {
			Size = UDim2.new(0, width, 0, EntryFrameHeight),
			BackgroundTransparency = 1,
			LayoutOrder = v2 + 1
		}, children3)
	end

	if v2 == 0 then
		children.Padding = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, width, 0, EntryFrameHeight),
			Text = "No Summary Data Found",
			TextColor3 = Text,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		})
		v2 = 1
	end

	local v3 = v2 * EntryFrameHeight + HeaderFrameHeight

	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, v3),
		ScrollingEnabled = false,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, children)
end

return extended
