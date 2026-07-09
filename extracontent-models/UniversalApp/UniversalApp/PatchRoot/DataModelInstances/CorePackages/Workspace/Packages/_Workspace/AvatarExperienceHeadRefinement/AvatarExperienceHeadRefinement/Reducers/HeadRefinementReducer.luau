local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local Rodux = require(AvatarExperienceHeadRefinementParent.Rodux)
local Cryo = require(AvatarExperienceHeadRefinementParent.Cryo)
local HeadShape = require(AvatarExperienceHeadRefinement.Enums.HeadShape)
local SetAvailableHeadShapes = require(AvatarExperienceHeadRefinement.Actions.SetAvailableHeadShapes)
local SetLastSelectedHeadShape = require(AvatarExperienceHeadRefinement.Actions.SetLastSelectedHeadShape)

local function getDefaultState() -- line: 25
	-- upvalues: HeadShape (copy)
	return {
		availableHeadShapes = {},
		lastSelectedHeadShape = HeadShape.Default
	}
end

return Rodux.createReducer({
	availableHeadShapes = {},
	lastSelectedHeadShape = HeadShape.Default
}, {
	[SetAvailableHeadShapes.name] = function(p1, p2) -- line: 38
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			availableHeadShapes = p2.headShapes
		})
	end,
	[SetLastSelectedHeadShape.name] = function(p3, p4) -- line: 44
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			lastSelectedHeadShape = p4.headShape
		})
	end
})
