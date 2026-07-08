local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local t = require(ParentParent.t)
local validateFont = require(scriptParent.validateFont)
local validateSettings = require(scriptParent.validateSettings)
local validateTheme = require(scriptParent.validateTheme)
local validateTokens = require(scriptParent.validateTokens)

return (t.strictInterface({
	Theme = t.optional(validateTheme),
	Font = t.optional(validateFont),
	Tokens = t.optional(validateTokens),
	Settings = t.optional(validateSettings)
}))
