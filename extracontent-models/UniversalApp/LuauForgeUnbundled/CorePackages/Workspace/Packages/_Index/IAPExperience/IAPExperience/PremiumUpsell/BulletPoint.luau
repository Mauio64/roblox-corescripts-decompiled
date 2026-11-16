local TextService = game:GetService("TextService")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
		local font2 = font.Body.Font
		local v7

		if text == nil then
			v7 = Vector2.new(0, 0)
		elseif foundationFontFaceMigration then
			v7 = getTextSize(
				text,
				v6,
				props.Tokens.Typography.BodyLarge.Font,
				Vector2.new(data.width - v5, 10000),
				{ addTemporaryPadding = false }
			)
		else
			v7 = TextService:GetTextSize(text, v6, font2, Vector2.new(data.width - v5, 10000))
		end

		local createElement = Roact.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, v7.Y),
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}
		local v10 = {
			Bullet = Roact.createElement(imageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 2, 0, 2),
				Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
				ScaleType = Enum.ScaleType.Stretch,
				Image = images["icons/status/success_small"],
				ImageColor3 = theme.IconDefault.Color,
				ImageTransparency = theme.IconDefault.Transparency
			}),
			Text = 0
		}

		local createElement2 = Roact.createElement
		local v12 = {
			Position = UDim2.new(0, v5, 0, 0),
			Size = UDim2.new(1, -v5, 0, v7.Y),
			BackgroundTransparency = 1,
			Text = text,
			TextSize = v6,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		if foundationFontFaceMigration then
			font2 = nil
		end

		v12.Font = font2

		local v13 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v12.FontFace = v13

		v12.TextXAlignment = Enum.TextXAlignment.Left

		v12.LayoutOrder = data.layoutOrder
		v10.Text = createElement2("TextLabel", v12)
		return createElement("Frame", v9, v10)
	end)
end
