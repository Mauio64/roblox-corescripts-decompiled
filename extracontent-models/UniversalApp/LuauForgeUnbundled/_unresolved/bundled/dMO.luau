local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("SetAssetInfoFromAvatarEditorRecommendedItemsV2", function(p2, p3)
	return { assets = p2, assetTypeId = p3 }
end)
