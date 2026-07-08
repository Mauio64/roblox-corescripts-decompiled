local Parent = script:FindFirstAncestor("AppBlox").Parent
local ContentPosition = require(script.Parent.ContentPosition)
local t = require(Parent.t)
local FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex = require(Parent.SharedFlags).FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex

return t.map(t.string, t.strictInterface({
	portraitLayoutOrder = t.integer,
	portraitZIndex = if not FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex then nil else t.optional(t.integer),
	landscapeLayoutOrder = t.integer,
	landscapePosition = ContentPosition.isEnumValue,
	renderComponent = t.callback,
	showCornerGradient = t.optional(t.boolean),
	useSelectionBumper = t.optional(t.boolean),
	visible = t.optional(t.boolean)
}))
