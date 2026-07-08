local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local validateColorToken = require(ParentParent.Core.Style.Validator.validateColorToken)
local validateTypographyInfo = require(ParentParent.Core.Style.Validator.validateTypographyInfo)
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local v10 = Roact.PureComponent:extend("StyledTextLabel")

v10.validateProps = t.strictInterface({
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
v10.defaultProps = {
	richText = true,
	fluidSizing = true,
	lineHeight = 1.4,
	clipsDescendants = false,
	openTypeFeatures = nil,
	textXAlignment = Enum.TextXAlignment.Left,
	textYAlignment = Enum.TextYAlignment.Center,
	automaticSize = Enum.AutomaticSize.None
}

function v10.render(p1) -- line: 64
	-- upvalues: Roact (copy), GenericTextLabel (copy)
	return Roact.createElement(GenericTextLabel, {
		maxSize = p1.props.maxSize,
		fontStyle = p1.props.fontStyle,
		colorStyle = p1.props.colorStyle,
		fluidSizing = p1.props.fluidSizing,
		Size = p1.props.size,
		Text = p1.props.text,
		TextXAlignment = p1.props.textXAlignment,
		TextYAlignment = p1.props.textYAlignment,
		TextTruncate = p1.props.textTruncate,
		TextWrapped = p1.props.textWrapped,
		LayoutOrder = p1.props.layoutOrder,
		RichText = p1.props.richText,
		AutomaticSize = p1.props.automaticSize,
		LineHeight = p1.props.lineHeight,
		ClipsDescendants = p1.props.clipsDescendants,
		openTypeFeatures = p1.props.openTypeFeatures,
		[Roact.Change.AbsoluteSize] = p1.props.onAbsoluteSizeChange
	})
end

return v10
