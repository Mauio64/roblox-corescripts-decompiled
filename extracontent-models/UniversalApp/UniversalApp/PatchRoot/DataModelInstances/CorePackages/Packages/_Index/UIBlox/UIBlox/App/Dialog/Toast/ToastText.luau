local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)

local extended = Roact.PureComponent:extend("ToastText")

extended.validateProps = t.interface({
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

extended.defaultProps = {
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center
}

function extended.render(p)
	return Roact.createElement(GenericTextLabel, p.props)
end

return extended
