local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParent.Core
local t = require(ParentParentParent.t)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local validateFontInfo = require(Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(ParentParent.Core.Style.Validator.validateTypographyInfo)

return t.array(t.strictInterface({
	icon = t.optional(t.union(t.table, t.string)),
	text = t.string,
	onActivated = t.callback,
	disabled = t.optional(t.boolean),
	inputBindingKey = t.optional(t.string),
	keyCodeLabel = t.optional(t.union(t.enum(Enum.KeyCode), t.strictInterface({
		key = t.enum(Enum.KeyCode),
		axis = t.optional(t.string)
	}))),
	selected = t.optional(t.boolean),
	stayOnActivated = t.optional(t.boolean),
	renderRightSideGadget = t.optional(t.callback),
	rightSideGadgetSize = t.optional(t.Vector2),
	iconColorOverride = t.optional(t.Color3),
	textColorOverride = t.optional(t.Color3),
	dividerOffset = t.optional(t.number),
	dividerSize = t.optional(t.number),
	leftPaddingOffset = t.optional(t.number),
	fontStyle = t.optional(t.union(t.string, validateFontInfo, validateTypographyInfo)),
	iconSize = t.optional(t.integer),
	selectedIconSize = t.optional(t.integer),
	iconPaddingLeft = t.optional(t.integer),
	textPadding = t.optional(t.strictInterface({
		left = t.integer,
		right = t.integer
	})),
	selectedIconPaddingRight = t.optional(t.integer),
	keyLabelPaddingRight = t.optional(t.integer),
	textOnlyPadding = t.optional(t.integer),
	buttonTextOverride = t.optional(t.table),
	borderCornerRadius = t.optional(t.integer),
	background = t.optional(validateColorInfo)
}))
