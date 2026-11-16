local CorePackages = game:GetService("CorePackages")

local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text
local module = require("@luauforge/bundled/ecR")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle
local linkButton = UIBlox.App.Button.LinkButton

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

return function(data)
	return withStyle(function(p2)
		local spacing = data.spacing
		local layoutOrder = data.LayoutOrder or 1
		local anchorPoint = data.AnchorPoint

		local textLabelText = data.textLabelText
		local textLabelColor = data.textLabelColor
		local textTransparency = data.TextTransparency

		local fontStyle = data.fontStyle or "CaptionBody"
		local v5 = p2.Font[fontStyle]
		local buttonSize = data.buttonSize or UDim2.fromScale(0, 1)
		local linkColorStyle = data.linkColorStyle
		local linkText = data.linkText
		local onActivated = data.onActivated
		local textButtonEnabled = data.textButtonEnabled
		local v6 = textButtonEnabled == nil or textButtonEnabled

		local v7 = v5.RelativeSize * p2.Font.BaseSize
		local textWidth = text.GetTextWidth(textLabelText or "", v5.Font, v7)
		local v8 = spacing or text.GetTextWidth(" ", v5.Font, v7)

		return module.createElement(FitChildren.FitFrame, {
			Size = UDim2.fromOffset(0, v7),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = anchorPoint,
			LayoutOrder = layoutOrder,
			fitAxis = FitChildren.FitAxis.Width
		}, {
			UIListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v8),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			TextLabel = module.createElement("TextLabel", {
				TextSize = v7,
				Font = v5.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, textWidth, 1, 0),
				Text = textLabelText,
				TextTransparency = textTransparency,
				TextColor3 = textLabelColor,
				LayoutOrder = 1
			}),
			LinkButton = module.createElement(linkButton, {
				fontStyle = fontStyle,
				size = buttonSize,
				text = linkText,
				colorStyleDefault = linkColorStyle,
				colorStyleHover = linkColorStyle,
				layoutOrder = 2,
				isDisabled = not v6,
				onActivated = onActivated
			})
		})
	end)
end
