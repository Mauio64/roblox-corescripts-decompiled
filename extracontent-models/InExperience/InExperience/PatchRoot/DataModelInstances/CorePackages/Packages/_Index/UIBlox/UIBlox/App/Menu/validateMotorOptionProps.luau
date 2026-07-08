local ParentParent = script.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)

return t.strictInterface({
	targetValue = t.number,
	springParams = t.optional(t.strictInterface({
		frequency = t.number,
		dampingRatio = t.number
	}))
})
