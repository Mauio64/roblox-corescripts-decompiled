local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local iconSize = UIBlox.App.Constant.IconSize

local v5 = iconSize.Small + 16

return function(data)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local text = data.text
		local v6 = font.Body.RelativeSize * font.BaseSize
		local v7

		if text == nil then
			v7 = Vector2.new(0, 0)
		else
			v7 = getTextSize(
				text,
				v6,
				props.Tokens.Typography.BodyLarge.Font,
				Vector2.new(data.width - v5, 10000),
				{ addTemporaryPadding = false }
			)
		end

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v7.Y),
				BackgroundTransparency = 1,
				LayoutOrder = data.layoutOrder
			},
			{
				Bullet = Roact.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 2, 0, 2),
					Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
					ScaleType = Enum.ScaleType.Stretch,
					Image = images["icons/status/success_small"],
					ImageColor3 = theme.IconDefault.Color,
					ImageTransparency = theme.IconDefault.Transparency
				}),
				Text = Roact.createElement("TextLabel", {
					Position = UDim2.new(0, v5, 0, 0),
					Size = UDim2.new(1, -v5, 0, v7.Y),
					BackgroundTransparency = 1,
					Text = text,
					TextSize = v6,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					LayoutOrder = data.layoutOrder
				})
			}
		)
	end)
end
