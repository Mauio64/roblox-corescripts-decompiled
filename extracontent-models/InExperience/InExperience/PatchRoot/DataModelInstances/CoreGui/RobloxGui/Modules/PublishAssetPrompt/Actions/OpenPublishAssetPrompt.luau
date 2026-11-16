local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator(script.Name, function(promptType: string, assetInstance, assetType, guid: string, scopes)
	return {
		promptInfo = {
			promptType = promptType,
			assetInstance = assetInstance,
			assetType = assetType,
			guid = guid,
			scopes = scopes
		}
	}
end)
