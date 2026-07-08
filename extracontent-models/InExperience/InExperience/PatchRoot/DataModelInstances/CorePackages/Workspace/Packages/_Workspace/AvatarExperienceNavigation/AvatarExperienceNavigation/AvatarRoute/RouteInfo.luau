local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarExperienceNavigationParent = AvatarExperienceNavigation.Parent
local tutils = require(AvatarExperienceNavigationParent.tutils)
local t = require(AvatarExperienceNavigationParent.t)
local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)

require(script.Parent.Types)

local t1 = {}

t1.__index = t1
t1.Interface = t.strictInterface({
	name = t.string,
	key = t.string,
	params = t.table
})

function t1.new(s1: string, s2: string, p1) -- line: 20
	-- upvalues: t1 (copy)
	local t2 = {
		name = s1,
		key = s2,
		params = p1 or {}
	}

	setmetatable(t2, t1)

	return t2
end

t1.EMPTY = t1.new(AvatarScreen.None, AvatarScreen.None)

function t1.__tostring(p2) -- line: 32
	return string.format("%s(key=%s)", p2.name, (tostring(p2.key)))
end
function t1.__eq(p3, p4) -- line: 36
	-- upvalues: tutils (copy)
	if rawequal(p3, p4) then
		return true
	end

	return p3.key == p4.key and (p3.name == p4.name and tutils.shallowEqual(p3.params, p4.params, nil))
end

return t1
