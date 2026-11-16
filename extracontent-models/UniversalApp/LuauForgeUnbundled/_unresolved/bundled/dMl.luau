local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("ApplyNavigateIntoAvatarExperience", function(p2, p3)
	return { screen = p2, params = p3 }
end)
