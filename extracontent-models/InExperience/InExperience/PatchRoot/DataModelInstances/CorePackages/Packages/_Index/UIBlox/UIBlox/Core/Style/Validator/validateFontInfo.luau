local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return t.strictInterface({
	RelativeSize = t.numberMinExclusive(0),
	RelativeMinSize = t.numberMinExclusive(0),
	Font = t.EnumItem
})
