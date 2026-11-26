local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel").Enums.ItemTypeEnum

return function(p2, p3, p4)
	if p4 == itemTypeEnum.Asset then
		return p2.AssetInfos[p3]
	end

	if p4 == itemTypeEnum.Bundle then
		return p2.BundleInfos[p3]
	end

	return nil
end
