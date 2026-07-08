local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local GenericTextLabel = require(ParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local v8 = Roact.PureComponent:extend("ToastText")

v8.validateProps = t.interface({
	colorStyle = validateColorInfo,
	fontStyle = validateFontInfo,
	Size = t.UDim2,
	Text = t.string,
	AnchorPoint = t.optional(t.Vector2),
	fluidSizing = t.optional(t.boolean),
	LayoutOrder = t.optional(t.integer),
	maxSize = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	TextTruncate = t.optional(t.EnumItem),
	TextXAlignment = t.optional(t.EnumItem),
	TextYAlignment = t.optional(t.EnumItem)
})
v8.defaultProps = {
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center
}

function v8.render(p1) -- line: 39
	-- upvalues: Roact (copy), GenericTextLabel (copy)
	return Roact.createElement(GenericTextLabel, p1.props)
end

return v8
