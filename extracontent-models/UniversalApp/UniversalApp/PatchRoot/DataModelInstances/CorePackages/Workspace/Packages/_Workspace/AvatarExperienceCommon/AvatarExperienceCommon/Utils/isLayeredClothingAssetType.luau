local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function isLayeredClothingAssetType(s1: string) -- line: 7
	-- upvalues: Constants (copy)
	return Constants.LAYERED_ASSET_TYPES[s1] ~= nil
end

return isLayeredClothingAssetType
