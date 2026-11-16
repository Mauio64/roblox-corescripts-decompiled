local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("BatchUnequipByAssetType", function(p2)
	return { assetTypeIds = p2 }
end)
