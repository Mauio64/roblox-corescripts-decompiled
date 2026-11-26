local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetBundleInfoFromSortResults", function(p2)
	module.isType(p2, "table", "SetBundleInfoFromSortResults expects sortResults")

	return { sortResults = p2 }
end)
