local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SetPageLoaded", function(p2)
	return { value = p2 }
end)
