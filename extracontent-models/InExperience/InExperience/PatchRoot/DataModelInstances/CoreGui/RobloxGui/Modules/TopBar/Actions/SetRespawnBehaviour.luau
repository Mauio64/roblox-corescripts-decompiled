local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(respawnEnabled, customCallback)
	return { respawnEnabled = respawnEnabled, customCallback = customCallback }
end)
