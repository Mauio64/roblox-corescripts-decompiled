require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

function LUAUFORGE_MODULE_GLOBALS_awu_removeMakeupAssetsFromTryOnsIfOverLimit(items)
	local count = 0
	local minItemRecency = 1e999

	for k, item in items do
		if not Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[item.itemSubType] then
			continue
		end

		count += 1
		minItemRecency = math.min(item.itemRecency, minItemRecency)
	end

	if Constants.MAX_MAKEUP_LAYERS < count then
		for k, item in items do
			if item.itemRecency == minItemRecency then
				items[k] = nil
			end
		end
	end

	return items
end

return LUAUFORGE_MODULE_GLOBALS_awu_removeMakeupAssetsFromTryOnsIfOverLimit
