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
local ColorText = Constants.Color.Text
local CellLabel = require(script.Parent.Parent.Parent.Components.CellLabel)
local HeaderButton = require(script.Parent.Parent.Parent.Components.HeaderButton)
local n1 = 0

for _, v in pairs(SummaryCellWidths) do
	n1 += v
end

local v17 = -n1
local t1 = {}
local t2 = {}
local t3 = {}

table.insert(t1, UDim2.new(0, CellPadding, 0, 0))
table.insert(t2, UDim2.new(1, -n1 - CellPadding, 0, HeaderFrameHeight))
table.insert(t3, UDim2.new(1, -n1 - CellPadding, 0, EntryFrameHeight))

for _, v in ipairs(SummaryCellWidths) do
	table.insert(t1, UDim2.new(1, v17 + CellPadding, 0, 0))
	table.insert(t2, UDim2.new(0, v - CellPadding, 0, HeaderFrameHeight))
	table.insert(t3, UDim2.new(0, v - CellPadding, 0, EntryFrameHeight))
	v17 += v
end

local t4 = {}

for i, v in ipairs(t1) do
	t4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local v26 = Roact.Component:extend("NetworkSummary")

function v26.render(p1) -- line: 50
	-- upvalues: Roact (copy), LineWidth (copy), LineColor (copy), t4 (copy), HeaderFrameHeight (copy), SummaryHeaderNames (copy), HeaderButton (copy), t2 (copy), t1 (copy), CellLabel (copy), EntryFrameHeight (copy), ColorText (copy)
	local width = p1.props.width
	local v29 = p1.props.httpSummaryTable or {}
	local layoutOrder = p1.props.layoutOrder
	local t5 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local t6 = {
		UpperHorizontalLine = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, LineWidth),
			BackgroundColor3 = LineColor
		}),
		LowerHorizontalLine = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, LineWidth),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = LineColor
		})
	}

	for i = 2, #t4 do
		t6[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 0, HeaderFrameHeight),
			Position = t4[i],
			BackgroundColor3 = LineColor
		})
	end

	for i, v in ipairs(SummaryHeaderNames) do
		t6[v] = Roact.createElement(HeaderButton, {
			text = v,
			size = t2[i],
			pos = t1[i]
		})
	end

	t5.Header = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(0, width, 0, HeaderFrameHeight)
	}, t6)

	local n2 = 0

	for _, v in pairs(v29) do
		n2 += 1

		local t7 = {
			RequestType = Roact.createElement(CellLabel, {
				text = v.RequestType,
				size = t2[1],
				pos = t1[1]
			}),
			RequestCount = Roact.createElement(CellLabel, {
				text = v.RequestCount,
				size = t2[2],
				pos = t1[2]
			}),
			FailedCount = Roact.createElement(CellLabel, {
				text = v.FailedCount,
				size = t2[3],
				pos = t1[3]
			}),
			AverageTime = Roact.createElement(CellLabel, {
				text = string.format("%.3f", v.AverageTime),
				size = t2[4],
				pos = t1[4]
			}),
			MinTime = Roact.createElement(CellLabel, {
				text = string.format("%.3f", v.MinTime),
				size = t2[5],
				pos = t1[5]
			}),
			MaxTime = Roact.createElement(CellLabel, {
				text = string.format("%.3f", v.MaxTime),
				size = t2[6],
				pos = t1[6]
			}),
			LowerHorizontalLine = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor
			})
		}

		for i = 2, #t4 do
			t7[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = t4[i],
				BackgroundColor3 = LineColor
			})
		end

		t5[v.RequestType] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, width, 0, EntryFrameHeight),
			LayoutOrder = n2 + 1
		}, t7)
	end

	if n2 == 0 then
		t5.Padding = Roact.createElement("TextLabel", {
			Text = "No Summary Data Found",
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, width, 0, EntryFrameHeight),
			TextColor3 = ColorText
		})
		n2 = 1
	end

	local v41 = n2 * EntryFrameHeight + HeaderFrameHeight

	return Roact.createElement("ScrollingFrame", {
		ScrollingEnabled = false,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v41),
		LayoutOrder = layoutOrder
	}, t5)
end

return v26
