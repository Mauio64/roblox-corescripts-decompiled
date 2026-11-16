local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local HoverGreen = Constants.Color.HoverGreen
local LineWidth = Constants.GeneralFormatting.LineWidth
local TextPadding = Constants.Graph.TextPadding
local InnerPaddingY = Constants.Graph.InnerPaddingY

return function(props)
	local hoverLineX = props.hoverLineX
	local hoverLineY = props.hoverLineY

	local text = props.hoverValX
	local text2 = props.hoverValY

	local stringFormatX = props.stringFormatX
	local stringFormatY = props.stringFormatY

	local createElement = Roact.createElement
	local v = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local children = {
		hoverLine = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = UDim2.new(0, hoverLineX, 0, 0),
			BackgroundColor3 = HoverGreen,
			BorderSizePixel = 0
		}),
		HoverHorizontal = Roact.createElement("Frame", {
			Size = UDim2.new(0, hoverLineX + TextPadding, 0, LineWidth),
			Position = UDim2.new(0, -TextPadding, 1 - InnerPaddingY, -hoverLineY),
			BackgroundColor3 = HoverGreen,
			BorderSizePixel = 0
		}),
		HoverTextY = 0,
		HoverTextX = 0
	}

	local createElement2 = Roact.createElement
	text2 = stringFormatY and stringFormatY(text2) or text2
	children.HoverTextY = createElement2("TextLabel", {
		Text = text2,
		TextColor3 = HoverGreen,
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(0, -TextPadding - 2, 1 - InnerPaddingY, -hoverLineY),
		BackgroundTransparency = 1
	})

	local createElement3 = Roact.createElement
	text = stringFormatX and stringFormatX(text) or text
	children.HoverTextX = createElement3("TextLabel", {
		Text = text,
		TextColor3 = HoverGreen,
		TextXAlignment = Enum.TextXAlignment.Center,
		Position = UDim2.new(0, hoverLineX, 1, TextPadding),
		BackgroundTransparency = 1
	})
	return createElement("Frame", v, children)
end
