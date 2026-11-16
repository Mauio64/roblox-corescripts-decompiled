local ContentPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/ContentPosition")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

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
