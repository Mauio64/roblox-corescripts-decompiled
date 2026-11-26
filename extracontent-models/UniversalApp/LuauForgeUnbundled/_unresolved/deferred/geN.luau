local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Style.withStyle

local v5 = { LEFT = 22, TOP = 5, BOTTOM = 5 }

return function(data)
	local maxSize = data.maxSize
	local layoutOrder = data.layoutOrder
	local text = data.text

	return withStyle(function(props)
		return Roact.createElement(
			"Frame",
			{
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 32)
			},
			{
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = maxSize
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 22),
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				Text = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
					TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = props.Theme.TextDefault.Color,
					TextTransparency = props.Theme.TextDefault.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Text = text
				})
			}
		)
	end)
end
