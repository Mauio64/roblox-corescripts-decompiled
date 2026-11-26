local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local decodeEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeEmojiSets")
local resolveEmoteId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/resolveEmoteId")

local reactionType = MomentsTypes.Enums.ReactionType

local v5 = {
	reactionType.ThumbsUp,
	reactionType.Heart,
	reactionType.LaughJoy,
	reactionType.Wow,
	reactionType.Cry,
	reactionType.Fire,
	reactionType.Skull
}

local function isValidMomentsEmojiCatalog(list): boolean
	if #list == 0 then
		return false
	end

	for i = 1, #v5 do
		local v6 = v5[i]
		local emoteIdForReaction = resolveEmoteId.resolveEmoteIdForReaction(list, v6)

		if emoteIdForReaction == v6 or string.find(emoteIdForReaction, "-", 1, true) == nil then
			return false
		end
	end

	return true
end

return {
	isValidMomentsEmojiCatalog = isValidMomentsEmojiCatalog,
	isValidGetEmojiSetsResponseShape = function(p2)
		if type(p2) ~= "table" or type(p2.emoji_sets) ~= "table" or #p2.emoji_sets == 0 then
			return false
		end

		local decodeGetEmojiSetsResponse = decodeEmojiSets.decodeGetEmojiSetsResponse(p2)
		return isValidMomentsEmojiCatalog(decodeEmojiSets.flattenEmojis(decodeGetEmojiSetsResponse))
	end,
	isValidCachedGetEmojiSetsResponse = function(p2)
		if p2 == nil then
			return false
		end

		return isValidMomentsEmojiCatalog(decodeEmojiSets.flattenEmojis(p2))
	end,
	isUuidLikeEmoteId = function(value): boolean
		return string.find(value, "-", 1, true) ~= nil
	end
}
