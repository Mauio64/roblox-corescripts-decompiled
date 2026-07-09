local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 21
	return {
		assetData = t1.assetData,
		bundleData = t1.bundleData,
		widget = t1.widget
	}
end)
