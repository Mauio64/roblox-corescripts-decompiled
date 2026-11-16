local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetEntryPage", function(p2)
	return { entryPage = p2 }
end)
