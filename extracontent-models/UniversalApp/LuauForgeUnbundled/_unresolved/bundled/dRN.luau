local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dPs")

require("@luauforge/bundled/dKU")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("UpdateAvatarEquips", function(p2)
	return { assets = p2.assets }
end)
