local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local Rodux = require(AvatarExperienceHeadRefinementParent.Rodux)

require(AvatarExperienceHeadRefinement.Enums.HeadShape)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 13
	return {
		headShapes = t1
	}
end)
