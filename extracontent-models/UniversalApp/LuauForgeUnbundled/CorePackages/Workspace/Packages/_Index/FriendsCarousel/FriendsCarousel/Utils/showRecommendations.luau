local isSubjectTo10ftPolicies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies").isSubjectTo10ftPolicies
local getFIntShowFriendRecommendationsLimit = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Flags/getFIntShowFriendRecommendationsLimit")

return function(p2): boolean
	if isSubjectTo10ftPolicies() then
		return true
	end

	return p2 <= getFIntShowFriendRecommendationsLimit()
end
