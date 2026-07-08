local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return t.strictInterface({
	Font = t.EnumItem,
	FontSize = t.numberMinExclusive(0),
	LineHeight = t.numberMinExclusive(0),
	LetterSpacing = t.number
})
