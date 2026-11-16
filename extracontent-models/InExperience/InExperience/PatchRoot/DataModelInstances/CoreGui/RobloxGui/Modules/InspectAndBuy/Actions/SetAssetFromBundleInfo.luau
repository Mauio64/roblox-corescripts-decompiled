local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(assetId, bundleInfo)
	return { assetId = assetId, bundleInfo = bundleInfo }
end)
