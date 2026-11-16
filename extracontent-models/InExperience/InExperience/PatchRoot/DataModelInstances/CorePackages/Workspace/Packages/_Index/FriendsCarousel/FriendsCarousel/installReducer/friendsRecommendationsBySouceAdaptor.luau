local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)

local networkingFriends = dependencies.NetworkingFriends
local roduxFriends = dependencies.RoduxFriends
local llama = dependencies.llama
local recommendationSourceEnum = dependencies.SocialCommon.Enums.RecommendationSourceEnum

return function()
	return {
		[networkingFriends.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p)
			local data = p.responseBody.data or {}

			local mapped = llama.List.map(data, function(p2)
				return p2.id
			end)

			return {
				p,
				(roduxFriends.Actions.RecommendationSourceCreated({
					source = recommendationSourceEnum.HomepageFriendsCarousel,
					recommendationIds = mapped
				}))
			}
		end
	}
end
