local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetConnectionState", function(p2)
	return { connectionState = p2 }
end)
