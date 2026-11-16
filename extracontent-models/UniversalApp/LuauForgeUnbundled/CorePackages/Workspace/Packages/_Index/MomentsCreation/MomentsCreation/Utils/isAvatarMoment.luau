local MomentType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/MomentType")

return function(p2): boolean
	return type(p2) == "table" and p2.MomentType == MomentType.Avatar
end
