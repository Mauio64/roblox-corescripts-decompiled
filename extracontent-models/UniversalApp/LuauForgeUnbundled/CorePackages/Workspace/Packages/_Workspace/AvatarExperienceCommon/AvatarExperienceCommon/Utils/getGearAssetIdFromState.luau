local ASSET_TYPE_NAME_TO_ID_STRING = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_NAME_TO_ID_STRING
local getEquippedAssetIdsForType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getEquippedAssetIdsForType")

return function(p2)
	local equippedAssets = p2.AvatarEditor.Character.EquippedAssets

	if equippedAssets == nil then
		return 0
	end

	local v5 = getEquippedAssetIdsForType(equippedAssets, ASSET_TYPE_NAME_TO_ID_STRING.Gear)
	local v6, v7 = next(v5)

	if v7 then
		return tonumber(v7) or 0
	end

	return 0
end
