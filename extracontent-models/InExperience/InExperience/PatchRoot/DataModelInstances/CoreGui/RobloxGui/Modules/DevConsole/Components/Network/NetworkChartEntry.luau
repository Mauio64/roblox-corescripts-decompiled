local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Parent.Constants)
local EntryFrameHeight = Constants.NetworkFormatting.EntryFrameHeight
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ResponseStrHeight = Constants.NetworkFormatting.ResponseStrHeight
local ResponseWidthRatio = Constants.NetworkFormatting.ResponseWidthRatio
local v9 = (1 - ResponseWidthRatio) / 2
local v10 = (1 - ResponseWidthRatio) / 4
local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local HeaderButton = require(Components.HeaderButton)
local BannerButton = require(Components.BannerButton)

return function(p1) -- line: 21
	-- upvalues: Roact (copy), CellLabel (copy), LineColor (copy), LineWidth (copy), EntryFrameHeight (copy), BannerButton (copy), v9 (copy), HeaderButton (copy), ResponseStrHeight (copy), v10 (copy)
	local size = p1.size
	local entry = p1.entry
	local entryCellSize = p1.entryCellSize
	local cellOffset = p1.cellOffset
	local verticalOffsets = p1.verticalOffsets
	local layoutOrder = p1.layoutOrder
	local showResponse = p1.showResponse
	local responseBodyHeight = p1.responseBodyHeight
	local onButtonPress = p1.onButtonPress
	local t1 = {
		Num = Roact.createElement(CellLabel, {
			text = entry.Num,
			size = entryCellSize[1],
			pos = cellOffset[1]
		}),
		Method = Roact.createElement(CellLabel, {
			text = entry.Method,
			size = entryCellSize[2],
			pos = cellOffset[2]
		}),
		Status = Roact.createElement(CellLabel, {
			text = entry.Status,
			size = entryCellSize[3],
			pos = cellOffset[3]
		}),
		Time = Roact.createElement(CellLabel, {
			text = string.format("%.3f", entry.Time),
			size = entryCellSize[4],
			pos = cellOffset[4]
		}),
		RequestType = Roact.createElement(CellLabel, {
			text = entry.RequestType,
			size = entryCellSize[5],
			pos = cellOffset[5]
		}),
		Url = Roact.createElement(CellLabel, {
			text = entry.Url,
			size = entryCellSize[6],
			pos = cellOffset[6]
		}),
		LowerHorizontalLine = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = LineColor
		})
	}

	for i = 2, #verticalOffsets do
		t1[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 0, EntryFrameHeight),
			Position = verticalOffsets[i],
			BackgroundColor3 = LineColor
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			pos = UDim2.new(),
			isExpanded = showResponse,
			onButtonPress = onButtonPress
		}, t1),
		Response = showResponse and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, responseBodyHeight),
			Position = UDim2.new(v9, 0, 0, EntryFrameHeight)
		}, {
			Text = Roact.createElement(HeaderButton, {
				text = "Response Body:",
				size = UDim2.new(1, 0, 0, ResponseStrHeight),
				pos = UDim2.new(-v10, 0, 0, 0)
			}),
			ResponseBody = Roact.createElement(CellLabel, {
				text = entry.Response,
				size = UDim2.new(0.8, 0, 1, -ResponseStrHeight),
				pos = UDim2.new(0, 0, 0, ResponseStrHeight)
			})
		})
	})
end
