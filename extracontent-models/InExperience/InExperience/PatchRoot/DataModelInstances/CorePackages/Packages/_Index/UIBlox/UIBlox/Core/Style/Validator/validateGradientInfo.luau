local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return t.strictInterface({
	Color = t.ColorSequence,
	Transparency = t.NumberSequence,
	Rotation = t.number,
	Offset = t.optional(t.Vector2)
})
