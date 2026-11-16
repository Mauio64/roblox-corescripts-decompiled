local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetCurrentSort", function(p2)
	return { currentSort = p2 }
end)
