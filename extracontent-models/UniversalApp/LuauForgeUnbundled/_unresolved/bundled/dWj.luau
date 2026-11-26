local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

return Rodux.makeActionCreator("SetSponsoredItems", function(p2, p3)
	return { category = p2, items = p3 }
end)
