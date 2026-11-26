require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/PYMKCarousel")
local FriendsRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/DataHydration/FriendsRecommendations")
local contextType = FriendsRecommendations.Enums.ContextType
local FFlagShowClassmatesOnPYMK = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SharedFlags/FFlagShowClassmatesOnPYMK")

local recommendationType = FriendsRecommendations.FriendRecommendations.RecommendationType

local function normalizeDirectRecommendations(items, p2)
	local directRecommendations = {}

	for k, item in items do
		local v5 = p2[item.id]

		if v5 == nil then
			continue
		end

		if v5.recommendationType == recommendationType.User then
			local mutualFriendsCount = v5.mutualFriendsCount or 0
			local v6

			if v5.contextType == contextType.MutualFriends and mutualFriendsCount > 0 then
				v6 = contextType.MutualFriends
			elseif v5.contextType == contextType.Frequents then
				v6 = contextType.Frequents
			elseif FFlagShowClassmatesOnPYMK and v5.contextType == contextType.Classmates then
				v6 = contextType.Classmates
			else
				v6 = contextType.None
			end

			table.insert(directRecommendations, {
				id = item.id,
				rank = item.rank,
				contextType = v6,
				mutualFriendsCount = mutualFriendsCount,
				hasIncomingFriendRequest = item.hasPendingFriendRequest
			})
		elseif v5.recommendationType == recommendationType.Contact then
			table.insert(directRecommendations, {
				id = item.id,
				rank = item.rank,
				contextType = contextType.Contacts,
				mutualFriendsCount = 0,
				hasIncomingFriendRequest = item.hasPendingFriendRequest,
				entityDisplayName = v5.contactName,
				thumbnailEntities = {
					avatarImageUrl = v5.avatarThumbnailUrl,
					headshotImageUrl = v5.headshotThumbnailUrl
				}
			})
		end
	end

	return directRecommendations
end

return normalizeDirectRecommendations
