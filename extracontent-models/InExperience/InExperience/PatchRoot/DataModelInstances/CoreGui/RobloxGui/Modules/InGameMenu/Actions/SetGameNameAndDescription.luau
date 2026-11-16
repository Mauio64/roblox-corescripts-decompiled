local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(gameName, gameDescription)
	return { gameName = gameName, gameDescription = gameDescription }
end)
