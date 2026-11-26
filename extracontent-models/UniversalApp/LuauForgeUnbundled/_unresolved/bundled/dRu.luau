local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("GrantPurchasedOutfit", function(p2)
	return { outfitId = p2 }
end)
