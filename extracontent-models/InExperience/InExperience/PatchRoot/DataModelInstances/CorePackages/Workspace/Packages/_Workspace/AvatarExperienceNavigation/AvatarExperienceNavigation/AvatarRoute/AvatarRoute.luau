local parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent
local t = require(parent.t)
local RouteInfo = require(script.Parent.RouteInfo)
require(script.Parent.Types)

local AvatarRoute = {}
AvatarRoute.__index = AvatarRoute
AvatarRoute.maxPreviousCount = 2

AvatarRoute.Interface = t.strictInterface({
	current = RouteInfo.Interface,
	previousPages = t.optional(t.array(RouteInfo.Interface)),
	opaque = RouteInfo.Interface,
	isVisible = t.boolean,
	isOverlayVisible = t.boolean
})

function AvatarRoute.new(data)
	local v = {
		current = data.current or RouteInfo.EMPTY,
		previousPages = data.previousPages or {},
		opaque = data.opaque or RouteInfo.EMPTY,
		isVisible = data.isVisible or false,
		isOverlayVisible = data.isOverlayVisible or false
	}

	setmetatable(v, AvatarRoute)
	return v
end

function AvatarRoute.__tostring(data)
	local current = data.current
	local opaque = data.opaque

	local v = (("AvatarRoute[" .. (data.isVisible and "Visible" or "Not Visible")) .. (data.isOverlayVisible and " *Overlay" or "")) .. ", " .. tostring(current)

	if current.name ~= opaque.name then
		v ..= ", opaque: " .. tostring(opaque)
	end

	return v .. "]"
end

function AvatarRoute.__eq(data, data2): boolean
	if not (data and data2) then
		return false
	end

	if rawequal(data, data2) then
		return true
	end

	return data.isVisible == data2.isVisible
		and data.isOverlayVisible == data2.isOverlayVisible
		and data.current == data2.current
		and data.opaque == data2.opaque
end

return AvatarRoute
