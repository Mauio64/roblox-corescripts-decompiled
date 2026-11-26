local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("RemoveScreen", function(p2)
	return { item = p2 }
end)
