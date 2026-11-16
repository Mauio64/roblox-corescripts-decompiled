local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetLastSavedSort", function(p2)
	return { savedAccessories = p2 }
end)
