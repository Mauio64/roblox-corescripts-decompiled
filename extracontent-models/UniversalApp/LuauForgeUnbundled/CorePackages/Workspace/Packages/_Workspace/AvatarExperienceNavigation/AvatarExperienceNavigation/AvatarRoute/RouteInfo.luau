local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/tutils")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/t")

local AvatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarScreen")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Types")

local class = {}
class.__index = class

class.Interface = t.strictInterface({
	name = t.string,
	key = t.string,
	params = t.table
})

function class.new(p2, p3, options)
	local v5 = {
		name = p2,
		key = p3,
		params = options or {}
	}

	setmetatable(v5, class)
	return v5
end

class.EMPTY = class.new(AvatarScreen.None, AvatarScreen.None)

function class.__tostring(p2)
	return string.format("%s(key=%s)", p2.name, (tostring(p2.key)))
end

function class.__eq(data, data2)
	if rawequal(data, data2) then
		return true
	end

	return data.key == data2.key
		and data.name == data2.name
		and tutils.shallowEqual(data.params, data2.params, nil)
end

return class
