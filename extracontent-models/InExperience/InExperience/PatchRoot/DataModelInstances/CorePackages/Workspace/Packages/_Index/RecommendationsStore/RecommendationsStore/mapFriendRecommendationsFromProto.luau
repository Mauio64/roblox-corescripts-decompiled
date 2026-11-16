local RecommendationsStore = script:FindFirstAncestor("RecommendationsStore")

require(RecommendationsStore.FriendRecommendationTypes)
local RecommendationType = require(RecommendationsStore.RecommendationType)

local function mapRecommendationTypeFromProto(recommendationType) -- 1 equivalent call inferred from this helper
	if recommendationType == "RECOMMENDATION_TYPE_USER" or recommendationType == RecommendationType.User then
		return RecommendationType.User
	end

	if recommendationType == "RECOMMENDATION_TYPE_CONTACT" or recommendationType == RecommendationType.Contact then
		return RecommendationType.Contact
	end

	return RecommendationType.Invalid
end

local function mapFriendRecommendationsFromProto(items)
	local clones = {}

	for k, item in items do
		local clone = table.clone(item)

		clone.recommendationType = mapRecommendationTypeFromProto(clone.recommendationType) -- inferred equivalent call
		clones[k] = clone
	end

	return clones
end

return mapFriendRecommendationsFromProto
