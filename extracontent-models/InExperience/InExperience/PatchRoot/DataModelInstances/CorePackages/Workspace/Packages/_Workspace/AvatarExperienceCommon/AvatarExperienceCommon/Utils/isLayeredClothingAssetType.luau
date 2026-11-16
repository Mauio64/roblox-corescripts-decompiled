local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

local function isLayeredClothingAssetType(p: string): boolean
	return Constants.LAYERED_ASSET_TYPES[p] ~= nil
end

return isLayeredClothingAssetType
