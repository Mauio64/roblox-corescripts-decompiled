local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local roduxFriends = dependencies.RoduxFriends
local llama = dependencies.llama
local recommendationContextType = roduxFriends.Enums.RecommendationContextType

local filterOutPYMKRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/Selectors/filterOutPYMKRecommendations")

return function(p2)
	return function(p3)
		local v5 = filterOutPYMKRecommendations(roduxFriends.Selectors.getSortedByRankRecommendations(p3, p2))(p3)

		return llama.List.map(v5, function(data, p4)
			return {
				id = data.id,
				absolutePosition = p4,
				recommendationRank = data.rank,
				recommendationContextType = data.contextType,
				hasIncomingFriendRequest = nil
			}
		end)
	end
end
