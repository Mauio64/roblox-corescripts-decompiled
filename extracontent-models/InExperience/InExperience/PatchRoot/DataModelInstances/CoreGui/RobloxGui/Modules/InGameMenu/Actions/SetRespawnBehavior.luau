local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_RESPAWN_BEHAVIOR", function(respawnEnabled, customCallback)
	return { respawnEnabled = respawnEnabled, customCallback = customCallback }
end)
