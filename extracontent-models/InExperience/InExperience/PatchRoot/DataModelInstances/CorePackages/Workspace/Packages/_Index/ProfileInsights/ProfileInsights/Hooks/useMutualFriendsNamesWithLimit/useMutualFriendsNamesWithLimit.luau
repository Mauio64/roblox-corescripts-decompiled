local parent = script:FindFirstAncestor("ProfileInsights").Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local ApolloProfileInsights = require(parent.ApolloProfileInsights)
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getMutualFriendsByUserIdFromData = ApolloProfileInsights.Selectors.getMutualFriendsByUserIdFromData

local UserProfiles = require(parent.UserProfiles)

local function getUserIdsWithLimit(p, p2: number)
	local slice = Array.slice(p, 1, p2 + 1)

	return Array.map(slice, function(p3)
		return p3.id
	end)
end

local function getUsersNamesFromData(data, mapped) -- 1 equivalent call inferred from this helper
	if data then
		return (Array.map(mapped, function(p)
			return UserProfiles.Selectors.getCombinedNameFromId(data, p)
		end))
	end

	return nil
end

local function useMutualFriendsNamesWithLimit(p)
	local v = useProfileInsightsByUserIds({
		userIds = { p.userId }
	})

	local mutualFriendsByUserIdFromData = getMutualFriendsByUserIdFromData(v.data, p.userId)
	local limit = p.limit
	local slice = Array.slice(mutualFriendsByUserIdFromData, 1, limit + 1)

	local mapped = Array.map(slice, function(p2)
		return p2.id
	end)

	local v2 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = mapped,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local loading = v.loading or v2.loading
	return getUsersNamesFromData(v2.data, mapped), loading -- inferred equivalent call
end

return useMutualFriendsNamesWithLimit
