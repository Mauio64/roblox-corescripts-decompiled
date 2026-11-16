local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(tryingOn, assetId, assetTypeId)
	return { tryingOn = tryingOn, assetId = assetId, assetTypeId = assetTypeId }
end)
