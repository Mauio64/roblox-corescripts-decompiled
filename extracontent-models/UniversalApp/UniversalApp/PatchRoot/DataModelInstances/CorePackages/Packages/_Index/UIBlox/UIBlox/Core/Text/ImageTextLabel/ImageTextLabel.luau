local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local GetTextSize = require(ParentParent.Core.Text.GetTextSize)
local GetWrappedTextWithIcon = require(ParentParent.Core.Text.GetWrappedTextWithIcon)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(ParentParent.Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local withStyle = require(ParentParent.Core.Style.withStyle)
local v14 = Roact.PureComponent:extend("ImageTextLabel")

v14.validateProps = t.interface({
	imageProps = t.optional(t.interface({
		Size = t.UDim2
	})),
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
	frameProps = t.optional(t.interface({
		Size = t.None
	})),
	maxSize = t.optional(t.Vector2),
	padding = t.optional(t.number)
})
v14.defaultProps = {
	padding = 0,
	maxSize = Vector2.new(10000, 10000),
	frameProps = {}
}

function v14.render(p1) -- line: 68
	-- upvalues: withStyle (copy), GetWrappedTextWithIcon (copy), GetTextSize (copy), Roact (copy), Cryo (copy), ImageSetComponent (copy), GenericTextLabel (copy)
	local genericTextLabelProps = p1.props.genericTextLabelProps
	local imageProps = p1.props.imageProps
	local frameProps = p1.props.frameProps
	local padding = p1.props.padding
	local genericTextLabelPropsText = p1.props.genericTextLabelProps.Text
	local maxSize = p1.props.maxSize
	local useMaxHeight = p1.props.useMaxHeight
	local richText = p1.props.richText

	return withStyle(function(p2) -- line: 78
		-- upvalues: genericTextLabelProps (copy), imageProps (copy), genericTextLabelPropsText (ref), GetWrappedTextWithIcon (copy), padding (copy), GetTextSize (copy), maxSize (copy), useMaxHeight (copy), Roact (copy), Cryo (copy), frameProps (copy), ImageSetComponent (copy), GenericTextLabel (copy), p1 (copy), richText (copy)
		local fontStyle = genericTextLabelProps.fontStyle
		local BaseSize = p2.Font.BaseSize
		local v27 = if not fontStyle.RelativeSize then fontStyle.FontSize else BaseSize * fontStyle.RelativeSize
		local fontStyleFont = fontStyle.Font

		if imageProps then
			genericTextLabelPropsText = GetWrappedTextWithIcon(genericTextLabelPropsText, v27, fontStyleFont, imageProps.Size.X.Offset, padding)
		end

		local v29 = GetTextSize(genericTextLabelPropsText, v27, fontStyleFont, Vector2.new(maxSize.X, maxSize.Y))
		local v30 = useMaxHeight and maxSize.Y or v29.Y

		return Roact.createElement("Frame", Cryo.Dictionary.join(frameProps, {
			Size = UDim2.new(0, v29.X, 0, v30)
		}), {
			Icon = if not imageProps then nil else Roact.createElement(ImageSetComponent.Label, imageProps),
			Name = Roact.createElement(GenericTextLabel, Cryo.Dictionary.join(genericTextLabelProps, {
				Text = genericTextLabelPropsText,
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				TextXAlignment = genericTextLabelProps.TextXAlignment or Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				fluidSizing = not imageProps and p1.props.fluidSizing,
				maxSize = maxSize,
				RichText = richText
			}))
		})
	end)
end

return v14
