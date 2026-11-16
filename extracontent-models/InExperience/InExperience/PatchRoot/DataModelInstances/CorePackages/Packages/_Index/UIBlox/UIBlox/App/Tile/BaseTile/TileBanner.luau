local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = require(parent.Core.Style.withStyle)

local extended = Roact.PureComponent:extend("TileBanner")

extended.validateProps = t.strictInterface({ bannerText = t.string })

function extended.render(p)
	local bannerText = p.props.bannerText

	return withStyle(function(p2)
		local font = p2.Font
		local theme = p2.Theme

		local v = 6 + font.CaptionBody.RelativeSize * font.BaseSize

		return Roact.createElement(
			"Frame",
			{
				BackgroundColor3 = theme.SystemPrimaryDefault.Color,
				BackgroundTransparency = theme.SystemPrimaryDefault.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, v)
			},
			{
				TextLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = normalizeFontFace(font.CaptionBody.Font),
					TextSize = font.CaptionBody.RelativeSize * font.BaseSize,
					Text = bannerText,
					TextColor3 = theme.SystemPrimaryContent.Color,
					TextTransparency = theme.SystemPrimaryContent.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 1, 0)
				})
			}
		)
	end)
end

return extended
