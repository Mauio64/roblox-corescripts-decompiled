local Parent = script:FindFirstAncestor("Moments").Parent
local Medium = require(Parent.MomentsCommon).Enums.ReactionSize.Medium

return {
	EXPLOSION_LAYER_ZINDEX = 4,
	MAX_CONCURRENT_EXPLOSIONS = 3,
	REACTED_REACTION_SIZE = Medium
}
