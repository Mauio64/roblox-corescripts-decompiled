local getTemporaryPlusBackgroundIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Backgrounds/getTemporaryPlusBackgroundIds")

local function isPlusExclusiveBackground(p2, p3)
	if p3 ~= nil then
		return p3
	end

	local v5, v6 = getTemporaryPlusBackgroundIds()

	if v6 then
		return p2 ~= nil
	end

	return p2 ~= nil and v5[tostring(p2)] == true
end

return isPlusExclusiveBackground
