local parent = script.Parent.Parent.Parent.Parent.Parent

local t = require(parent.t)

local validateFontFace = require(script.Parent.validateFontFace)

return t.strictInterface({
	RelativeSize = t.numberMinExclusive(0),
	RelativeMinSize = t.numberMinExclusive(0),
	Font = t.union(t.EnumItem, validateFontFace),
	FontFace = t.optional(validateFontFace)
})
