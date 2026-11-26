local ASSET_TYPE_NAME_TO_ID_STRING = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_NAME_TO_ID_STRING
local isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")
local OutfitTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/OutfitTypes")

local function isValidAssetTypeForOutfitType(p2, p3)
	if not p3 then
		return true
	end

	if p3 == OutfitTypes.Makeup then
		return isMakeupAssetType(p2)
			or p2 == ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory
			or p2 == ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory
	end

	return p3 == OutfitTypes.Avatar or p3 == OutfitTypes.EditableAvatar or true
end

return isValidAssetTypeForOutfitType
