local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetAvatarScales", function(p2)
	return { scales = p2 }
end)
