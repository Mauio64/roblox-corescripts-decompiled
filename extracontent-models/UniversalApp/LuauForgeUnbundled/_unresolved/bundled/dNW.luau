local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetBodyColor3s", function(p2)
	return { bodyColor3s = p2 }
end)
