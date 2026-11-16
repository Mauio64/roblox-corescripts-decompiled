local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("RemoveLayeredClothing", function(p2)
	return { hasLayeredHair = p2 }
end)
