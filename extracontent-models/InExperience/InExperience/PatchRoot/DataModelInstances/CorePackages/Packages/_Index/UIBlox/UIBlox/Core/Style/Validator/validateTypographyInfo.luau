local parent = script.Parent.Parent.Parent.Parent.Parent

local t = require(parent.t)

local validateFontFace = require(script.Parent.validateFontFace)

return t.strictInterface({
	Font = t.union(t.EnumItem, validateFontFace),
	FontSize = t.numberMinExclusive(0),
	LineHeight = t.numberMinExclusive(0),
	LetterSpacing = t.number
})
