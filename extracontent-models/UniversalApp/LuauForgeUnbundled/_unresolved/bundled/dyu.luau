local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SetPassesThumbnails", function(p2)
	return { passesThumbnails = p2 }
end)
