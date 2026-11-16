local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetLastSavedTriedOnOutfit", function(p2)
	return { savedOutfit = p2 }
end)
