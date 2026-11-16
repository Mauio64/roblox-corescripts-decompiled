local parent = script:FindFirstAncestor("AppBlox").Parent

local ContentPosition = require(script.Parent.ContentPosition)

local t = require(parent.t)

return t.map(t.string, t.strictInterface({
	portraitLayoutOrder = t.integer,
	portraitZIndex = t.optional(t.integer),
	landscapeLayoutOrder = t.integer,
	landscapePosition = ContentPosition.isEnumValue,
	renderComponent = t.callback,
	showCornerGradient = t.optional(t.boolean),
	useSelectionBumper = t.optional(t.boolean),
	visible = t.optional(t.boolean)
}))
