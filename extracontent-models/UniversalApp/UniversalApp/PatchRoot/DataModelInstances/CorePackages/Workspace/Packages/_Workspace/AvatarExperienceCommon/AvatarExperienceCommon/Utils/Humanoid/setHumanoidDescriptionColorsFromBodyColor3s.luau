local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION = require(AvatarExperienceCommon.Constants).BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION

return function(p1, p2) -- line: 6
	-- upvalues: BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION (copy)
	if p2 then
		for v5, v6 in p2 do
			p1[BODY_PART_FOR_SKIN_COLORING_ID_TO_HUMANOID_DESCRIPTION[v5]] = v6
		end
	end
end
