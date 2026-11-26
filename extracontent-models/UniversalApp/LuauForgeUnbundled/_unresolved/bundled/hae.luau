local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("RemoveSearchInCatalog", function(p2)
	return { searchUuid = p2 }
end)
