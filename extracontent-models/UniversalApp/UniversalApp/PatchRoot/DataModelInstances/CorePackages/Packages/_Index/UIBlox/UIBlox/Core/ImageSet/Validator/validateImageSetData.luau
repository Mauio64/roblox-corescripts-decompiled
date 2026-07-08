local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return (t.strictInterface({
	ImageRectOffset = t.Vector2,
	ImageRectSize = t.Vector2,
	Image = t.string
}))
