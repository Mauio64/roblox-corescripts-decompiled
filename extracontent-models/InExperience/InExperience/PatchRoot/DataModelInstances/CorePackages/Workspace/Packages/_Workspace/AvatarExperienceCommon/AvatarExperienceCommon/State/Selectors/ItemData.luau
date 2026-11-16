local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceModel = require(AvatarExperienceCommon.Parent.AvatarExperienceModel)

local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

return function(p, p2, p3)
	if p3 == ItemTypeEnum.Asset then
		return p.AssetInfos[p2]
	end

	if p3 == ItemTypeEnum.Bundle then
		return p.BundleInfos[p2]
	end

	return nil
end
