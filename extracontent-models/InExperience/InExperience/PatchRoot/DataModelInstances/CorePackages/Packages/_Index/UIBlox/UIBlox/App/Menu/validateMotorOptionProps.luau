local parent = script.Parent.Parent.Parent.Parent

local t = require(parent.t)

return t.strictInterface({
	targetValue = t.number,
	springParams = t.optional(t.strictInterface({ frequency = t.number, dampingRatio = t.number }))
})
