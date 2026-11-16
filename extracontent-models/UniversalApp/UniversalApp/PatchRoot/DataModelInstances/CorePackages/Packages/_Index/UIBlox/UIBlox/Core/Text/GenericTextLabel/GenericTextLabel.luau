local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)
local t = require(parent2.t)

local GetTextSize = require(parent.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent.Core.Text.GetFontFromFontStyle)
local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent.Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local validateColorToken = require(parent.Core.Style.Validator.validateColorToken)
local withStyle = require(parent.Core.Style.withStyle)
local UIBloxConfig = require(parent.UIBloxConfig)

local extended = Roact.PureComponent:extend("GenericTextLabel")

extended.validateProps = t.interface({
	maxSize = t.optional(t.Vector2),
	fontStyle = t.union(validateFontInfo, validateTypographyInfo),
	colorStyle = t.union(validateColorInfo, validateColorToken),
	fluidSizing = t.optional(t.boolean),
	openTypeFeatures = t.optional(t.string)
})

extended.defaultProps = {
	maxSize = Vector2.new(10000, 10000),
	fluidSizing = false,
	openTypeFeatures = nil
}

function extended.render(p)
	local text = p.props.Text
	local fluidSizing = p.props.fluidSizing

	return withStyle(function(p2)
		local fontStyle = p.props.fontStyle
		local colorStyle = p.props.colorStyle
		local color = colorStyle.Color or colorStyle.Color3
		local transparency = colorStyle.Transparency
		local richText = p.props.RichText

		local baseSize = p2.Font.BaseSize
		local minTextSize

		if fontStyle.RelativeMinSize then
			minTextSize = baseSize * fontStyle.RelativeMinSize
		else
			minTextSize = fontStyle.FontSize
		end

		local maxTextSize

		if fontStyle.RelativeSize then
			maxTextSize = baseSize * fontStyle.RelativeSize
		else
			maxTextSize = fontStyle.FontSize
		end

		local fontFromFontStyle = GetFontFromFontStyle(fontStyle)

		local size = p.props.Size

		if size == nil then
			local v = text

			if p.props.TextTruncate == Enum.TextTruncate.AtEnd then
				v ..= "..."
			end

			local maxSize = p.props.maxSize
			local v2

			if p.props.LineHeight then
				v2 = maxTextSize * p.props.LineHeight
			else
				v2 = maxTextSize
			end

			local textSize = GetTextSize(v, v2, fontFromFontStyle, maxSize)
			size = UDim2.new(0, textSize.X, 0, textSize.Y)
		end

		if p.props.AutomaticSize ~= nil and p.props.AutomaticSize ~= Enum.AutomaticSize.None then
			size = nil
		end

		local textSize = p.props.TextSize or maxTextSize
		local automaticSize = p.props.AutomaticSize or nil

		local joined = Cryo.Dictionary.join(p.props, {
			[Roact.Children] = Cryo.None,
			fluidSizing = Cryo.None,
			fontStyle = Cryo.None,
			openTypeFeatures = Cryo.None,
			colorStyle = Cryo.None,
			maxSize = Cryo.None,
			Size = size,
			Text = text,
			Font = Cryo.None,
			FontFace = normalizeFontFace(fontFromFontStyle),
			TextSize = textSize,
			AutomaticSize = automaticSize,
			TextColor3 = color,
			TextTransparency = transparency,
			TextWrapped = p.props.TextWrapped == nil or p.props.TextWrapped,
			TextScaled = fluidSizing,
			BackgroundTransparency = 1,
			RichText = richText
		})

		if UIBloxConfig.enableOpenTypeSupport and p.props.openTypeFeatures then
			joined = Cryo.Dictionary.join(joined, { OpenTypeFeatures = p.props.openTypeFeatures })
		end

		return Roact.createElement("TextLabel", joined, Cryo.Dictionary.join({
			UITextSizeConstraint = fluidSizing and Roact.createElement(
				"UITextSizeConstraint",
				{ MaxTextSize = maxTextSize, MinTextSize = minTextSize } or nil
			)
		}, p.props[Roact.Children] or {}))
	end)
end

return extended
