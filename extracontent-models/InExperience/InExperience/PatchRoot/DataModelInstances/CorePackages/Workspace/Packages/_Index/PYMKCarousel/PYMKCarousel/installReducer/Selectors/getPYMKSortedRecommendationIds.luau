local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local roduxFriends = dependencies.RoduxFriends
local llama = dependencies.llama
local recommendationContextType = roduxFriends.Enums.RecommendationContextType

local filterOutPYMKRecommendations = require(script.Parent.filterOutPYMKRecommendations)

return function(p: string)
	return function(p2)
		local v = filterOutPYMKRecommendations(roduxFriends.Selectors.getSortedByRankRecommendations(p2, p))(p2)

		return llama.List.map(v, function(data, absolutePosition)
			return {
				id = data.id,
				absolutePosition = absolutePosition,
				recommendationRank = data.rank,
				recommendationContextType = data.contextType,
				hasIncomingFriendRequest = nil
			}
		end)
	end
end
