local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)
local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local validateColorToken = require(parent.Core.Style.Validator.validateColorToken)
local validateTypographyInfo = require(parent.Core.Style.Validator.validateTypographyInfo)

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local extended = Roact.PureComponent:extend("StyledTextLabel")

extended.validateProps = t.strictInterface({
	text = t.string,
	fontStyle = t.union(validateFontInfo, validateTypographyInfo),
	colorStyle = t.union(validateColorInfo, validateColorToken),
	textTruncate = t.optional(t.EnumItem),
	textWrapped = t.optional(t.boolean),
	textXAlignment = t.optional(t.EnumItem),
	textYAlignment = t.optional(t.EnumItem),
	size = t.optional(t.UDim2),
	maxSize = t.optional(t.Vector2),
	richText = t.optional(t.boolean),
	layoutOrder = t.optional(t.number),
	fluidSizing = t.optional(t.boolean),
	automaticSize = t.optional(t.EnumItem),
	lineHeight = t.optional(t.number),
	clipsDescendants = t.optional(t.boolean),
	onAbsoluteSizeChange = t.optional(t.callback),
	openTypeFeatures = t.optional(t.string)
})

extended.defaultProps = {
	textXAlignment = Enum.TextXAlignment.Left,
	textYAlignment = Enum.TextYAlignment.Center,
	richText = true,
	fluidSizing = true,
	automaticSize = Enum.AutomaticSize.None,
	lineHeight = 1.4,
	clipsDescendants = false,
	openTypeFeatures = nil
}

function extended.render(p)
	return Roact.createElement(GenericTextLabel, {
		maxSize = p.props.maxSize,
		fontStyle = p.props.fontStyle,
		colorStyle = p.props.colorStyle,
		fluidSizing = p.props.fluidSizing,
		Size = p.props.size,
		Text = p.props.text,
		TextXAlignment = p.props.textXAlignment,
		TextYAlignment = p.props.textYAlignment,
		TextTruncate = p.props.textTruncate,
		TextWrapped = p.props.textWrapped,
		LayoutOrder = p.props.layoutOrder,
		RichText = p.props.richText,
		AutomaticSize = p.props.automaticSize,
		LineHeight = p.props.lineHeight,
		ClipsDescendants = p.props.clipsDescendants,
		openTypeFeatures = p.props.openTypeFeatures,
		[Roact.Change.AbsoluteSize] = p.props.onAbsoluteSizeChange
	})
end

return extended
