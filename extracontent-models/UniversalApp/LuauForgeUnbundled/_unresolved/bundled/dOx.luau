local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

require("@luauforge/bundled/dMc")

require("@luauforge/bundled/dHL")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("UpdateAvatarEquips", function(p2)
	return { assets = p2.assets }
end)
