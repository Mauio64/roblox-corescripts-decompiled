local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Dash")

local getTryOnItemReducerKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getTryOnItemReducerKey")

local function findItemInTryOnItems(p2, p3, p4)
	if p4 then
		return p2[getTryOnItemReducerKey(tostring(p3), p4)]
	end

	return Dash.find(p2, function(p5): boolean
		return tostring(p5.itemId) == tostring(p3)
	end)
end

return findItemInTryOnItems
