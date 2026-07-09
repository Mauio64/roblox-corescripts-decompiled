local Parent = script:FindFirstAncestor("AvatarExperienceNavigation").Parent
local t = require(Parent.t)
local RouteInfo = require(script.Parent.RouteInfo)

require(script.Parent.Types)

local t1 = {}

t1.__index = t1
t1.maxPreviousCount = 2
t1.Interface = t.strictInterface({
	current = RouteInfo.Interface,
	previousPages = t.optional(t.array(RouteInfo.Interface)),
	opaque = RouteInfo.Interface,
	isVisible = t.boolean,
	isOverlayVisible = t.boolean
})

function t1.new(p1) -- line: 40
	-- upvalues: RouteInfo (copy), t1 (copy)
	local t2 = {
		current = p1.current or RouteInfo.EMPTY,
		previousPages = p1.previousPages or {},
		opaque = p1.opaque or RouteInfo.EMPTY,
		isVisible = p1.isVisible or false,
		isOverlayVisible = p1.isOverlayVisible or false
	}

	setmetatable(t2, t1)

	return t2
end
function t1.__tostring(p2) -- line: 52
	local current = p2.current
	local opaque = p2.opaque
	local v10 = (("AvatarRoute[" .. (not p2.isVisible and "Not Visible" or "Visible")) .. (not p2.isOverlayVisible and "" or " *Overlay")) .. ", " .. tostring(current)

	if current.name ~= opaque.name then
		v10 ..= ", opaque: " .. tostring(opaque)
	end

	return v10 .. "]"
end
function t1.__eq(p3, p4) -- line: 67
	if not p3 or not p4 then
		return false
	end

	if rawequal(p3, p4) then
		return true
	end

	return p3.isVisible == p4.isVisible and (p3.isOverlayVisible == p4.isOverlayVisible and (p3.current == p4.current and p3.opaque == p4.opaque))
end

return t1
