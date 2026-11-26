local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetAvatarSettings", function(p2, p3, p4, p5, p6)
	return {
		minimumDeltaEBodyColorDifference = p2,
		scalesRules = p3,
		accessoryRefinementTypes = p4,
		accessoryRefinementLowerBounds = p5,
		accessoryRefinementUpperBounds = p6
	}
end)
