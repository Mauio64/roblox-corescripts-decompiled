local parent = script.Parent.Parent.Parent.Parent
local t = require(parent.Parent.t)

return t.strictInterface({
	Color = t.Color3,
	Transparency = t.numberConstrained(0, 1),
	Image = t.string
})
