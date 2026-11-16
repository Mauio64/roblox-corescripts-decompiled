local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

require(parent.PYMKCarousel)
local RecommendationsStore = require(parent.RecommendationsStore)
local FriendsRecommendations = require(parent.DataHydration.FriendsRecommendations)
local ContextType = FriendsRecommendations.Enums.ContextType
local FFlagShowClassmatesOnPYMK = require(parent.SharedFlags.FFlagShowClassmatesOnPYMK)

local RecommendationType = RecommendationsStore.FriendRecommendations.RecommendationType

local function normalizeDirectRecommendations(items, p)
	local directRecommendations = {}

	for _, item in items do
		local v = p[item.id]

		if v == nil then
			continue
		end

		if v.recommendationType == RecommendationType.User then
			local mutualFriendsCount = v.mutualFriendsCount or 0
			local contextType

			if v.contextType == ContextType.MutualFriends and mutualFriendsCount > 0 then
				contextType = ContextType.MutualFriends
			elseif v.contextType == ContextType.Frequents then
				contextType = ContextType.Frequents
			elseif FFlagShowClassmatesOnPYMK and v.contextType == ContextType.Classmates then
				contextType = ContextType.Classmates
			else
				contextType = ContextType.None
			end

			table.insert(directRecommendations, {
				id = item.id,
				rank = item.rank,
				contextType = contextType,
				mutualFriendsCount = mutualFriendsCount,
				hasIncomingFriendRequest = item.hasPendingFriendRequest
			})
		elseif v.recommendationType == RecommendationType.Contact then
			table.insert(directRecommendations, {
				id = item.id,
				rank = item.rank,
				contextType = ContextType.Contacts,
				mutualFriendsCount = 0,
				hasIncomingFriendRequest = item.hasPendingFriendRequest,
				entityDisplayName = v.contactName,
				thumbnailEntities = {
					avatarImageUrl = v.avatarThumbnailUrl,
					headshotImageUrl = v.headshotThumbnailUrl
				}
			})
		end
	end

	return directRecommendations
end

return normalizeDirectRecommendations
