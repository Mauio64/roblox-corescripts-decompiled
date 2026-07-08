local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local HoverGreen = Constants.Color.HoverGreen
local LineWidth = Constants.GeneralFormatting.LineWidth
local TextPadding = Constants.Graph.TextPadding
local InnerPaddingY = Constants.Graph.InnerPaddingY

return function(p1) -- line: 10
	-- upvalues: Roact (copy), LineWidth (copy), HoverGreen (copy), TextPadding (copy), InnerPaddingY (copy)
	local hoverLineX = p1.hoverLineX
	local hoverLineY = p1.hoverLineY
	local hoverValX = p1.hoverValX
	local hoverValY = p1.hoverValY
	local stringFormatX = p1.stringFormatX
	local stringFormatY = p1.stringFormatY

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		hoverLine = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = UDim2.new(0, hoverLineX, 0, 0),
			BackgroundColor3 = HoverGreen
		}),
		HoverHorizontal = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, hoverLineX + TextPadding, 0, LineWidth),
			Position = UDim2.new(0, -TextPadding, 1 - InnerPaddingY, -hoverLineY),
			BackgroundColor3 = HoverGreen
		}),
		HoverTextY = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = stringFormatY and stringFormatY(hoverValY) or hoverValY,
			TextColor3 = HoverGreen,
			TextXAlignment = Enum.TextXAlignment.Right,
			Position = UDim2.new(0, -TextPadding - 2, 1 - InnerPaddingY, -hoverLineY)
		}),
		HoverTextX = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = stringFormatX and stringFormatX(hoverValX) or hoverValX,
			TextColor3 = HoverGreen,
			TextXAlignment = Enum.TextXAlignment.Center,
			Position = UDim2.new(0, hoverLineX, 1, TextPadding)
		})
	})
end
