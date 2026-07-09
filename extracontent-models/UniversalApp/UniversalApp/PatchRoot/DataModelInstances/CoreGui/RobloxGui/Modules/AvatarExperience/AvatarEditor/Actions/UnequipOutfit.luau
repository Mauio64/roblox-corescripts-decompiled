local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 16
	return {
		assetTypeIdToAssetIdToAssetMetadataModel = t1
	}
end)
