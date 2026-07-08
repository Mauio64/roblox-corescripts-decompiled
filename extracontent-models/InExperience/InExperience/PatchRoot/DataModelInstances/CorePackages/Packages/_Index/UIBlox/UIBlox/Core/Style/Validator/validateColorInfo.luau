local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)
local validateBinding = require(scriptParent.validateBinding)

return t.strictInterface({
	Color = t.Color3,
	Transparency = t.union(t.numberConstrained(0, 1), validateBinding)
})
