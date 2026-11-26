require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/SduiFriendRecommendationTypes")
local SduiRecommendationType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/SduiRecommendationType")

local function mapRecommendationTypeFromProto(p2)
	if p2 == "RECOMMENDATION_TYPE_USER" or p2 == SduiRecommendationType.User then
		return SduiRecommendationType.User
	end

	if p2 == "RECOMMENDATION_TYPE_CONTACT" or p2 == SduiRecommendationType.Contact then
		return SduiRecommendationType.Contact
	end

	return SduiRecommendationType.Invalid
end

local function mapFriendRecommendationsFromProto(items)
	local clones = {}

	for k, item in items do
		local clone = table.clone(item)

		local recommendationType = clone.recommendationType
		local v5

		if recommendationType == "RECOMMENDATION_TYPE_USER" or recommendationType == SduiRecommendationType.User then
			v5 = SduiRecommendationType.User
		elseif
			recommendationType == "RECOMMENDATION_TYPE_CONTACT"
			or recommendationType == SduiRecommendationType.Contact
		then
			v5 = SduiRecommendationType.Contact
		else
			v5 = SduiRecommendationType.Invalid
		end

		clone.recommendationType = v5

		clones[k] = clone
	end

	return clones
end

return mapFriendRecommendationsFromProto
