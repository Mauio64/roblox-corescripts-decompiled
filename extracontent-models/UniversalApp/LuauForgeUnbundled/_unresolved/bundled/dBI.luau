local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SetDeveloperProductsThumbnails", function(p2)
	return { developerProductsThumbnails = p2 }
end)
