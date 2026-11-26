local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetAvatarType", function(p2)
	return { avatarType = p2 }
end)
