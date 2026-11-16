local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_RESPAWNING", function(respawning)
	return { respawning = respawning }
end)
