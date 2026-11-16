local TextService = game:GetService("TextService")

local parent = script.Parent.Parent.Parent

local UIBlox = require(parent.UIBlox)
local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local IconSize = UIBlox.App.Constant.IconSize

local v = IconSize.Small + 16

return function(data)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local text = data.text
		local textSize = font.Body.RelativeSize * font.BaseSize
		local font2 = font.Body.Font
		local v2

		if text == nil then
			v2 = Vector2.new(0, 0)
		elseif FoundationFontFaceMigration then
			v2 = GetTextSize(
				text,
				textSize,
				props.Tokens.Typography.BodyLarge.Font,
				Vector2.new(data.width - v, 10000),
				{ addTemporaryPadding = false }
			)
		else
			v2 = TextService:GetTextSize(text, textSize, font2, Vector2.new(data.width - v, 10000))
		end

		local createElement = Roact.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, v2.Y),
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}
		local v4 = {
			Bullet = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 2, 0, 2),
				Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
				ScaleType = Enum.ScaleType.Stretch,
				Image = Images["icons/status/success_small"],
				ImageColor3 = theme.IconDefault.Color,
				ImageTransparency = theme.IconDefault.Transparency
			}),
			Text = 0
		}

		local createElement2 = Roact.createElement
		local v5 = {
			Position = UDim2.new(0, v, 0, 0),
			Size = UDim2.new(1, -v, 0, v2.Y),
			BackgroundTransparency = 1,
			Text = text,
			TextSize = textSize,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		if FoundationFontFaceMigration then
			font2 = nil
		end

		v5.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v5.FontFace = fontFace

		v5.TextXAlignment = Enum.TextXAlignment.Left

		v5.LayoutOrder = data.layoutOrder
		v4.Text = createElement2("TextLabel", v5)
		return createElement("Frame", v3, v4)
	end)
end
