require("@game/CorePackages/Workspace/Packages/_Index/RecommendationsStore/RecommendationsStore/FriendRecommendationTypes")
local RecommendationType = require("@game/CorePackages/Workspace/Packages/_Index/RecommendationsStore/RecommendationsStore/RecommendationType")

local function mapRecommendationTypeFromProto(p2)
	if p2 == "RECOMMENDATION_TYPE_USER" or p2 == RecommendationType.User then
		return RecommendationType.User
	end

	if p2 == "RECOMMENDATION_TYPE_CONTACT" or p2 == RecommendationType.Contact then
		return RecommendationType.Contact
	end

	return RecommendationType.Invalid
end

local function mapFriendRecommendationsFromProto(items)
	local clones = {}

	for k, item in items do
		local clone = table.clone(item)

		local recommendationType = clone.recommendationType
		local v5

		if recommendationType == "RECOMMENDATION_TYPE_USER" or recommendationType == RecommendationType.User then
			v5 = RecommendationType.User
		elseif
			recommendationType == "RECOMMENDATION_TYPE_CONTACT"
			or recommendationType == RecommendationType.Contact
		then
			v5 = RecommendationType.Contact
		else
			v5 = RecommendationType.Invalid
		end

		clone.recommendationType = v5

		clones[k] = clone
	end

	return clones
end

return mapFriendRecommendationsFromProto
