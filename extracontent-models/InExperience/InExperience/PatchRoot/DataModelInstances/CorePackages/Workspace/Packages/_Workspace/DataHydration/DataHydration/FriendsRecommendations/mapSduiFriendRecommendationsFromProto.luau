require(script.Parent.SduiFriendRecommendationTypes)
local SduiRecommendationType = require(script.Parent.SduiRecommendationType)

local function mapRecommendationTypeFromProto(recommendationType) -- 1 equivalent call inferred from this helper
	if recommendationType == "RECOMMENDATION_TYPE_USER" or recommendationType == SduiRecommendationType.User then
		return SduiRecommendationType.User
	end

	if recommendationType == "RECOMMENDATION_TYPE_CONTACT" or recommendationType == SduiRecommendationType.Contact then
		return SduiRecommendationType.Contact
	end

	return SduiRecommendationType.Invalid
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
