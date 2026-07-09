local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local RoduxFriends = dependencies.RoduxFriends
local llama = dependencies.llama
local filterOutPYMKRecommendations = require(script.Parent.filterOutPYMKRecommendations)

return function(s1: string) -- line: 15
	-- upvalues: filterOutPYMKRecommendations (copy), RoduxFriends (copy), llama (copy)
	return function(p1) -- line: 16
		-- upvalues: filterOutPYMKRecommendations (copy), RoduxFriends (copy), s1 (copy), llama (copy)
		local v8 = filterOutPYMKRecommendations(RoduxFriends.Selectors.getSortedByRankRecommendations(p1, s1))(p1)

		return llama.List.map(v8, function(p2, p3) -- line: 20
			return {
				id = p2.id,
				absolutePosition = p3,
				recommendationRank = p2.rank,
				recommendationContextType = p2.contextType
			}
		end)
	end
end
