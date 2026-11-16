local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(id, isFavorite)
	return { id = id, isFavorite = isFavorite }
end)
