require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")

local getTryOnItemComparisonData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/TryOns/getTryOnItemComparisonData")
local getShouldReplaceTryOn = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/TryOns/getShouldReplaceTryOn")

function LUAUFORGE_MODULE_GLOBALS_awr_getFilteredTryOnItems(items, p2)
	local v5 = getTryOnItemComparisonData(p2)
	local result = {}
	local result2 = {}

	for k, item in items do
		if getShouldReplaceTryOn(v5, (getTryOnItemComparisonData(item))) then
			result[k] = item
		else
			result2[k] = item
		end
	end

	return result2, result
end

return LUAUFORGE_MODULE_GLOBALS_awr_getFilteredTryOnItems
