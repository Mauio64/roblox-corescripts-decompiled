local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetSearchInCatalog", function(p2, p3)
	return { searchUuid = p2, searchInCatalog = p3 }
end)
