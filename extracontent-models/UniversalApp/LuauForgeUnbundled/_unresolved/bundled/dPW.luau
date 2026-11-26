local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("SetRecommendedAssetsAction", function(p2, p3, p4)
	return { assetId = p2, assetTypeId = p3, recommendedItems = p4 }
end)
