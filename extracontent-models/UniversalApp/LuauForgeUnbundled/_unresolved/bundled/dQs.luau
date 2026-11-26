local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dPs")

return Rodux.makeActionCreator("ReceivedAvatarData", function(p2)
	return { avatarData = p2 }
end)
