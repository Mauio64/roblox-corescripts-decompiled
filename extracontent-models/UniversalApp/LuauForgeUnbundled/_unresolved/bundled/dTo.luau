local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetFinalPageViewMode", function(p2)
	return { finalPageViewMode = p2 }
end)
