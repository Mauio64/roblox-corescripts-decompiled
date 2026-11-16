local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)
local t = require(parent2.t)

local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)
local GetTextSize = require(parent.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent.Core.Text.GetFontFromFontStyle)
local GetWrappedTextWithIcon = require(parent.Core.Text.GetWrappedTextWithIcon)
local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent.Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local withStyle = require(parent.Core.Style.withStyle)

local extended = Roact.PureComponent:extend("ImageTextLabel")

extended.validateProps = t.interface({
	imageProps = t.optional(t.interface({ Size = t.UDim2 })),
	genericTextLabelProps = t.interface({
		Text = t.string,
		fontStyle = t.union(validateFontInfo, validateTypographyInfo),
		colorStyle = validateColorInfo,
		fluidSizing = t.optional(t.boolean),
		AnchorPoint = t.None,
		Position = t.None,
		Size = t.None,
		TextXAlignment = t.None,
		TextYAlignment = t.None,
		TextScaled = t.None,
		maxSize = t.None,
		richText = t.optional(t.boolean)
	}),
	frameProps = t.optional(t.interface({ Size = t.None })),
	maxSize = t.optional(t.Vector2),
	padding = t.optional(t.number)
})

extended.defaultProps = { maxSize = Vector2.new(10000, 10000), frameProps = {}, padding = 0 }

function extended.render(p)
	local genericTextLabelProps = p.props.genericTextLabelProps
	local imageProps = p.props.imageProps
	local frameProps = p.props.frameProps
	local padding = p.props.padding
	local text = p.props.genericTextLabelProps.Text
	local maxSize = p.props.maxSize
	local useMaxHeight = p.props.useMaxHeight
	local richText = p.props.richText

	return withStyle(function(p2)
		local fontStyle = genericTextLabelProps.fontStyle

		local baseSize = p2.Font.BaseSize
		local v

		if fontStyle.RelativeSize then
			v = baseSize * fontStyle.RelativeSize
		else
			v = fontStyle.FontSize
		end

		local fontFromFontStyle = GetFontFromFontStyle(fontStyle)

		if imageProps then
			text = GetWrappedTextWithIcon(text, v, fontFromFontStyle, imageProps.Size.X.Offset, padding)
		end

		local textSize = GetTextSize(text, v, fontFromFontStyle, Vector2.new(maxSize.X, maxSize.Y))
		local y = useMaxHeight and maxSize.Y or textSize.Y

		local createElement = Roact.createElement

		local joined = Cryo.Dictionary.join(frameProps, { Size = UDim2.new(0, textSize.X, 0, y) })
		local icon

		if imageProps then
			icon = Roact.createElement(ImageSetComponent.Label, imageProps)
		end

		return createElement("Frame", joined, {
			Icon = icon,
			Name = Roact.createElement(GenericTextLabel, Cryo.Dictionary.join(genericTextLabelProps, {
				Text = text,
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				TextXAlignment = genericTextLabelProps.TextXAlignment or Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				fluidSizing = not imageProps and p.props.fluidSizing,
				maxSize = maxSize,
				RichText = richText
			}))
		})
	end)
end

return extended
