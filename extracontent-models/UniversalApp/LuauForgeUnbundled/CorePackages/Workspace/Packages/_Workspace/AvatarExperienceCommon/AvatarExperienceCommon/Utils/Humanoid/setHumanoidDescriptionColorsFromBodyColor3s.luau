local BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION

return function(p2, items)
	if items then
		for k, item in items do
			p2[BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[k]] = item
		end
	end
end
