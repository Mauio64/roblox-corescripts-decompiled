local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("UnequipOutfit", function(p2)
	return { assetTypeIdToAssetIdToAssetMetadataModel = p2 }
end)
