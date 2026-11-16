local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local t = require(parent.t)

return {
	isValid = t.strictInterface({ text = t.string, iconName = t.optional(t.string) })
}
