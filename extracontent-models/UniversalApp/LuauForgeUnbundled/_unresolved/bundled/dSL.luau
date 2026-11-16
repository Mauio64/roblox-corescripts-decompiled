local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("SetWearTimeFilter", function(p2)
	return { wearTimeFilter = p2 }
end)
