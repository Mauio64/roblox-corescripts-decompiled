local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(priceInRobux)
	return { priceInRobux = priceInRobux }
end)
