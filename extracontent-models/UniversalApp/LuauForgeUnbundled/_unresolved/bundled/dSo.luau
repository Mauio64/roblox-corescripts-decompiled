local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetDefaultBodyColorRanges", function(p2)
	return { defaultBodyColorRanges = p2 }
end)
