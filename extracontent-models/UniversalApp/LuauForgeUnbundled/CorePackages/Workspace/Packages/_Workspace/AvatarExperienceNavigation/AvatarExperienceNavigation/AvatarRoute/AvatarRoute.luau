local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/t")
local RouteInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/RouteInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Types")

local class = {}
class.__index = class
class.maxPreviousCount = 2

class.Interface = t.strictInterface({
	current = RouteInfo.Interface,
	previousPages = t.optional(t.array(RouteInfo.Interface)),
	opaque = RouteInfo.Interface,
	isVisible = t.boolean,
	isOverlayVisible = t.boolean
})

function class.new(data)
	local v5 = {
		current = data.current or RouteInfo.EMPTY,
		previousPages = data.previousPages or {},
		opaque = data.opaque or RouteInfo.EMPTY,
		isVisible = data.isVisible or false,
		isOverlayVisible = data.isOverlayVisible or false
	}

	setmetatable(v5, class)
	return v5
end

function class.__tostring(data)
	local current = data.current
	local opaque = data.opaque

	local v5 = (("AvatarRoute[" .. (data.isVisible and "Visible" or "Not Visible")) .. (data.isOverlayVisible and " *Overlay" or "")) .. ", " .. tostring(current)

	if current.name ~= opaque.name then
		v5 ..= ", opaque: " .. tostring(opaque)
	end

	return v5 .. "]"
end

function class.__eq(data, data2): boolean
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

return class
