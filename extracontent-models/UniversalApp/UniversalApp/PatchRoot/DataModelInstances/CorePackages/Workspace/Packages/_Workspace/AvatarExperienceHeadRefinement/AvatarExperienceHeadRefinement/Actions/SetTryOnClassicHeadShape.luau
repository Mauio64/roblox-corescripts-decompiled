local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local Rodux = require(AvatarExperienceHeadRefinementParent.Rodux)

require(AvatarExperienceHeadRefinement.Enums.HeadShape)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 13
	return {
		headShape = p1
	}
end)
