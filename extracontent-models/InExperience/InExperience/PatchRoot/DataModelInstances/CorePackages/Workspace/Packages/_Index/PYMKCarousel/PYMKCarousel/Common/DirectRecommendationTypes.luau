local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local parent = PYMKCarousel.Parent

require(parent.DataHydration.FriendsRecommendationsContextType)
local v = require(PYMKCarousel.dependencies)
v = v.RoduxFriends.Enums.RecommendationContextType

return nil
