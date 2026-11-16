local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local t = require(parent2.t)

local validateFont = require(parent.validateFont)
local validateSettings = require(parent.validateSettings)
local validateTheme = require(parent.validateTheme)

return (t.strictInterface({
	Theme = t.optional(validateTheme),
	Font = t.optional(validateFont),
	Tokens = t.optional(t.any),
	Settings = t.optional(validateSettings)
}))
