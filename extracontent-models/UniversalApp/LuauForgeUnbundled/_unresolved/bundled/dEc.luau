local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require("@luauforge/bundled/cBc")

return makeActionCreator("AddSearchResultsOmniFeedSorts", function(p2, p3)
	return { searchUuid = p2, sorts = p3 }
end)
