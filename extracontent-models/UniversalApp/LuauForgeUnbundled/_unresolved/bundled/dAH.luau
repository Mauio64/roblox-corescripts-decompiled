local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetIsLocalUserSoothsayer", function(p2)
	return { isSoothsayer = p2 }
end)
