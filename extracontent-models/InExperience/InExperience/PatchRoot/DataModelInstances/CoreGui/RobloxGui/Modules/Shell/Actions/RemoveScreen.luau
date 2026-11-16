local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("RemoveScreen", function(p)
	return { item = p }
end)
