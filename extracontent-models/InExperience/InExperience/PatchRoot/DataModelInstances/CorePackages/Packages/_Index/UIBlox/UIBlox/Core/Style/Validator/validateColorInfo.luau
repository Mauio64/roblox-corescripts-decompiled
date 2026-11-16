local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local t = require(parent2.t)
local validateBinding = require(parent.validateBinding)

return t.strictInterface({
	Color = t.Color3,
	Transparency = t.union(t.numberConstrained(0, 1), validateBinding)
})
