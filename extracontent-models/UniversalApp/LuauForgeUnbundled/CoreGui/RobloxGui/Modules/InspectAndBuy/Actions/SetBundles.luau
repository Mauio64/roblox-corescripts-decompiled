local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetBundleInfoFromAvatarEditorRecommendedItemsV2", function(p2)
	return { bundles = p2 }
end)
