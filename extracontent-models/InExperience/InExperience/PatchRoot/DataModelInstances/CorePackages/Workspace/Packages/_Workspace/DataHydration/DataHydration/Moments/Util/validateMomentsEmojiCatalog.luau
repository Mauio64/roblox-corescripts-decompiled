local parent = script:FindFirstAncestor("DataHydration").Parent

local MomentsTypes = require(parent.MomentsTypes)
local decodeEmojiSets = require(script.Parent.decodeEmojiSets)
local resolveEmoteId = require(script.Parent.resolveEmoteId)

local ReactionType = MomentsTypes.Enums.ReactionType

local v = {
	ReactionType.ThumbsUp,
	ReactionType.Heart,
	ReactionType.LaughJoy,
	ReactionType.Wow,
	ReactionType.Cry,
	ReactionType.Fire,
	ReactionType.Skull
}

local function isValidMomentsEmojiCatalog(list): boolean
	if #list == 0 then
		return false
	end

	for i = 1, #v do
		local v2 = v[i]
		local emoteIdForReaction = resolveEmoteId.resolveEmoteIdForReaction(list, v2)

		if emoteIdForReaction == v2 or string.find(emoteIdForReaction, "-", 1, true) == nil then
			return false
		end
	end

	return true
end

local ValidateMomentsEmojiCatalog = {}
ValidateMomentsEmojiCatalog.isValidMomentsEmojiCatalog = isValidMomentsEmojiCatalog

function ValidateMomentsEmojiCatalog.isValidGetEmojiSetsResponseShape(p)
	if type(p) ~= "table" or type(p.emoji_sets) ~= "table" or #p.emoji_sets == 0 then
		return false
	end

	local decodeGetEmojiSetsResponse = decodeEmojiSets.decodeGetEmojiSetsResponse(p)
	return isValidMomentsEmojiCatalog(decodeEmojiSets.flattenEmojis(decodeGetEmojiSetsResponse))
end

function ValidateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(p)
	return p ~= nil and isValidMomentsEmojiCatalog(decodeEmojiSets.flattenEmojis(p))
end

function ValidateMomentsEmojiCatalog.isUuidLikeEmoteId(value: string): boolean
	return string.find(value, "-", 1, true) ~= nil
end

return ValidateMomentsEmojiCatalog
