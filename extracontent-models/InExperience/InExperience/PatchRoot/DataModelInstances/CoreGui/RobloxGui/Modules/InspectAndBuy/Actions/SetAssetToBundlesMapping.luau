local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(assetId, bundleIds)
	return { assetId = assetId, bundleIds = bundleIds }
end)
