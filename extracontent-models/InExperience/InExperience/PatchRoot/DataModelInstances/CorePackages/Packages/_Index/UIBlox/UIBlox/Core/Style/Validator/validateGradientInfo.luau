local parent = script.Parent.Parent.Parent.Parent.Parent

local t = require(parent.t)

return t.strictInterface({
	Color = t.ColorSequence,
	Transparency = t.NumberSequence,
	Rotation = t.number,
	Offset = t.optional(t.Vector2)
})
