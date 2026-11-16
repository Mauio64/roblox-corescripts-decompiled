local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("NavigatedToDeepLinkAvatarEditor", function(p2)
	return { category = p2.category, subcategory = p2.subcategory }
end)
