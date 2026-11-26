local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("GrantEditableOutfit", function(p2)
	return { outfitId = p2 }
end)
