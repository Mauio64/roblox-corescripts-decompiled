local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)
local EntryFrameHeight = Constants.NetworkFormatting.EntryFrameHeight
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local ResponseStrHeight = Constants.NetworkFormatting.ResponseStrHeight
local ResponseWidthRatio = Constants.NetworkFormatting.ResponseWidthRatio
local v = (1 - ResponseWidthRatio) / 2
local v2 = (1 - ResponseWidthRatio) / 4

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local HeaderButton = require(Components.HeaderButton)
local BannerButton = require(Components.BannerButton)

return function(props)
	local size = props.size
	local entry = props.entry
	local entryCellSize = props.entryCellSize
	local cellOffset = props.cellOffset
	local verticalOffsets = props.verticalOffsets
	local layoutOrder = props.layoutOrder
	local showResponse = props.showResponse
	local responseBodyHeight = props.responseBodyHeight

	local onButtonPress = props.onButtonPress

	local children = {}
	children.Num = Roact.createElement(CellLabel, {
		text = entry.Num,
		size = entryCellSize[1],
		pos = cellOffset[1]
	})

	children.Method = Roact.createElement(CellLabel, {
		text = entry.Method,
		size = entryCellSize[2],
		pos = cellOffset[2]
	})

	children.Status = Roact.createElement(CellLabel, {
		text = entry.Status,
		size = entryCellSize[3],
		pos = cellOffset[3]
	})

	children.Time = Roact.createElement(CellLabel, {
		text = string.format("%.3f", entry.Time),
		size = entryCellSize[4],
		pos = cellOffset[4]
	})

	children.RequestType = Roact.createElement(CellLabel, {
		text = entry.RequestType,
		size = entryCellSize[5],
		pos = cellOffset[5]
	})

	children.Url = Roact.createElement(CellLabel, {
		text = entry.Url,
		size = entryCellSize[6],
		pos = cellOffset[6]
	})

	children.LowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	for i = 2, #verticalOffsets do
		children[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 0, EntryFrameHeight),
			Position = verticalOffsets[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		Button = Roact.createElement(
			BannerButton,
			{
				size = UDim2.new(1, 0, 0, EntryFrameHeight),
				pos = UDim2.new(),
				isExpanded = showResponse,
				onButtonPress = onButtonPress
			},
			children
		),
		Response = showResponse and Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, responseBodyHeight),
				Position = UDim2.new(v, 0, 0, EntryFrameHeight),
				BackgroundTransparency = 1
			},
			{
				Text = Roact.createElement(HeaderButton, {
					text = "Response Body:",
					size = UDim2.new(1, 0, 0, ResponseStrHeight),
					pos = UDim2.new(-v2, 0, 0, 0)
				}),
				ResponseBody = Roact.createElement(CellLabel, {
					text = entry.Response,
					size = UDim2.new(0.8, 0, 1, -ResponseStrHeight),
					pos = UDim2.new(0, 0, 0, ResponseStrHeight)
				})
			}
		)
	})
end
