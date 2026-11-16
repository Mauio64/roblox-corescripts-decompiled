local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = require(parent2.Core.Style.withStyle)

local GetTextSize = require(parent2.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent2.Core.Text.GetFontFromFontStyle)
local Images = require(parent2.App.ImageSet.Images)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(parent.Enum.ItemTileEnums)

local extended = Roact.PureComponent:extend("ItemTileStatus")

local vector2 = Vector2.new(50, 20)
local vector2_2 = Vector2.new(10, 6)

extended.validateProps = t.strictInterface({
	statusText = t.string,
	statusStyle = ItemTileEnums.StatusStyle.isEnumValue
})

local function getStyle(theme, statusStyle)
	if statusStyle == ItemTileEnums.StatusStyle.Info then
		return { Background = theme.SystemPrimaryDefault, Text = theme.SystemPrimaryContent }
	end

	if statusStyle == ItemTileEnums.StatusStyle.Alert then
		return { Background = theme.Alert, Text = theme.TextEmphasis }
	end

	return { Background = theme.SystemPrimaryDefault, Text = theme.SystemPrimaryContent }
end

function extended.render(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font
		local tokens = props.Tokens

		local statusText = p.props.statusText
		local statusStyle = p.props.statusStyle

		local fontFromFontStyle = GetFontFromFontStyle(font.CaptionHeader)
		local textSize = font.BaseSize * font.CaptionHeader.RelativeSize
		local textSize2 = GetTextSize(statusText, textSize, fontFromFontStyle, vector2)

		local style = getStyle(theme, statusStyle)

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Image = Images["component_assets/circle_17"],
			ImageColor3 = style.Background.Color,
			ImageTransparency = style.Background.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			Position = UDim2.new(0, tokens.Size.Size_200, 0, tokens.Size.Size_200),
			Size = UDim2.new(0, textSize2.X + vector2_2.X, 0, textSize2.Y + vector2_2.Y)
		}, {
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(fontFromFontStyle),
				TextSize = textSize,
				Text = statusText,
				TextColor3 = style.Text.Color,
				TextTransparency = style.Text.TextTransparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return extended
