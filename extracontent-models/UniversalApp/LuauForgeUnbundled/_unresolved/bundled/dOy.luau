local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

require("@luauforge/bundled/dHL")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("ToggleEquipAsset", function(p2, p3, p4, p5)
	return {
		assetTypeId = p2,
		assetId = p3,
		overrideOrder = p4,
		overrideAdjustments = p5
	}
end)
