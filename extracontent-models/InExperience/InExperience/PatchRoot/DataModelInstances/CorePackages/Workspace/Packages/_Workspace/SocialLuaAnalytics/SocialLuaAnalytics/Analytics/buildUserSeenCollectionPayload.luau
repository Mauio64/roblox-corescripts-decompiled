local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields

local function buildUserSeenCollectionPayload(items, sessionEventCount: number)
	local userIds = {}
	local indices = {}
	local presences = {}
	local recommendationRanks = {}
	local friendStatuses = {}
	local recommendationContextTypes = {}
	local isRecommendations = {}
	local universeIds = {}

	for _, item in items do
		table.insert(userIds, (tostring(item.userId)))
		table.insert(indices, (tostring(item.index)))
		table.insert(presences, (tostring(item.presence)))
		table.insert(recommendationRanks, (tostring(item.recommendationRank)))
		table.insert(friendStatuses, (tostring(item.friendStatus)))
		table.insert(recommendationContextTypes, (tostring(item.recommendationContextType)))
		table.insert(isRecommendations, (tostring(item.isRecommendation)))
		table.insert(universeIds, (tostring(item.universeId)))
	end

	return {
		userIds = table.concat(userIds, ","),
		absolutePositions = table.concat(indices, ","),
		presences = table.concat(presences, ","),
		recommendationRanks = table.concat(recommendationRanks, ","),
		friendStatuses = table.concat(friendStatuses, ","),
		recommendationContextTypes = table.concat(recommendationContextTypes, ","),
		isRecommendations = table.concat(isRecommendations, ","),
		universeIds = table.concat(universeIds, ","),
		tileCount = #userIds,
		sessionEventCount = sessionEventCount,
		contentType = FFlagLuaAppUserSeenCollectionUnifiedFields and "User" or nil
	}
end

return buildUserSeenCollectionPayload
