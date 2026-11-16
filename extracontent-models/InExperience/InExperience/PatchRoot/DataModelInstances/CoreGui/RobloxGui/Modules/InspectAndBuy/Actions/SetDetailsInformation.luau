local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(viewingDetails, assetId)
	return { viewingDetails = viewingDetails, assetId = assetId }
end)
