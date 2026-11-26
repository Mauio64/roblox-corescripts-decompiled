local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetAvatarsTabSearchInfo", function(p2, p3)
	return { searchUuid = p2, keyword = p3 }
end)
