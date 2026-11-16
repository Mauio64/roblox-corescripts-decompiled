local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)

return {
	REACTED_REACTION_SIZE = MomentsCommon.Enums.ReactionSize.Medium,
	EXPLOSION_LAYER_ZINDEX = 4,
	MAX_CONCURRENT_EXPLOSIONS = 3
}
