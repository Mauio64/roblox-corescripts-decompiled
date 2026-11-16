local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)
local BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION = Constants.BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION

return function(p, items)
	if items then
		for k, item in items do
			p[BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[k]] = item
		end
	end
end
