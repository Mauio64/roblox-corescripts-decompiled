local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local function isLayeredClothingAssetType(p2): boolean
	return Constants.LAYERED_ASSET_TYPES[p2] ~= nil
end

return isLayeredClothingAssetType
