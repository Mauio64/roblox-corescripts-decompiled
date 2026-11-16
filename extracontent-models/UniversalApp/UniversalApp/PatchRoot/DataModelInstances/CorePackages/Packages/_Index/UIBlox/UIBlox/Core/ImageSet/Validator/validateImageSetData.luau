local parent = script.Parent.Parent.Parent.Parent.Parent
local t = require(parent.t)

return (t.strictInterface({
	ImageRectOffset = t.Vector2,
	ImageRectSize = t.Vector2,
	Image = t.string
}))
