local CorePackages = game:GetService("CorePackages")
require(script.Parent.Parent.Models.CollectibleInstance)
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(collectibleItemId: string?, collectibleItemInstances)
	return {
		collectibleItemId = collectibleItemId,
		collectibleItemInstances = collectibleItemInstances
	}
end)
