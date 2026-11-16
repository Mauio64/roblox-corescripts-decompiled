local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetBodyPartRangeIds", function(p2)
	return { bodyPartRangeIds = p2 }
end)
