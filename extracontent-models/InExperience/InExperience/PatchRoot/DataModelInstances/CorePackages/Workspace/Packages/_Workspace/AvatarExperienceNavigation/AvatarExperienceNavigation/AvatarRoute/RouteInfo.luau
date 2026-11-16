local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local parent = AvatarExperienceNavigation.Parent
local tutils = require(parent.tutils)
local t = require(parent.t)

local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)
require(script.Parent.Types)

local RouteInfo = {}
RouteInfo.__index = RouteInfo

RouteInfo.Interface = t.strictInterface({ name = t.string, key = t.string, params = t.table })

function RouteInfo.new(name: string, p: string, options)
	local v = {
		name = name,
		key = p,
		params = options or {}
	}

	setmetatable(v, RouteInfo)
	return v
end

RouteInfo.EMPTY = RouteInfo.new(AvatarScreen.None, AvatarScreen.None)

function RouteInfo.__tostring(p)
	return string.format("%s(key=%s)", p.name, (tostring(p.key)))
end

function RouteInfo.__eq(data, data2)
	if rawequal(data, data2) then
		return true
	end

	return data.key == data2.key and data.name == data2.name and tutils.shallowEqual(data.params, data2.params, nil)
end

return RouteInfo
