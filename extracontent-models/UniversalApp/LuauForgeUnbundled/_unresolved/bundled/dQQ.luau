local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetItemDetailsExpanded", function(p2)
	return { itemDetailsExpanded = p2 }
end)
