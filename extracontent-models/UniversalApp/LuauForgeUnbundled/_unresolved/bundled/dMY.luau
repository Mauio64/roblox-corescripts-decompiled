local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

return Rodux.makeActionCreator("UpdateAssetModerationStatus", function(p2, p3, p4, p5)
	return {
		assetId = tostring(p2),
		moderationStatus = p3,
		assetName = p4,
		universeId = p5
	}
end)
