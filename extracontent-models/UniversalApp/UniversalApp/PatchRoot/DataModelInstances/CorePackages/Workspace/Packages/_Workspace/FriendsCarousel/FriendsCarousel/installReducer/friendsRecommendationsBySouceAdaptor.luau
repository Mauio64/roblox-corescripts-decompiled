local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local NetworkingFriends = dependencies.NetworkingFriends
local RoduxFriends = dependencies.RoduxFriends
local llama = dependencies.llama
local RecommendationSourceEnum = dependencies.SocialCommon.Enums.RecommendationSourceEnum

return function() -- line: 10
	-- upvalues: NetworkingFriends (copy), llama (copy), RoduxFriends (copy), RecommendationSourceEnum (copy)
	return {
		[NetworkingFriends.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p1) -- line: 12
			-- upvalues: llama (copy), RoduxFriends (copy), RecommendationSourceEnum (copy)
			local v8 = p1.responseBody.data or {}
			local v9 = llama.List.map(v8, function(p2) -- line: 15
				return p2.id
			end)

			return {
				p1,
				(RoduxFriends.Actions.RecommendationSourceCreated({
					source = RecommendationSourceEnum.HomepageFriendsCarousel,
					recommendationIds = v9
				}))
			}
		end
	}
end
