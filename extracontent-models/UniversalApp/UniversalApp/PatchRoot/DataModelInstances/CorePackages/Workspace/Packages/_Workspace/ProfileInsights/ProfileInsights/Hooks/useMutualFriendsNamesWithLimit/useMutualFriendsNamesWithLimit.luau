local Parent = script:FindFirstAncestor("ProfileInsights").Parent
local Array = require(Parent.LuauPolyfill).Array
local ApolloProfileInsights = require(Parent.ApolloProfileInsights)
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getMutualFriendsByUserIdFromData = ApolloProfileInsights.Selectors.getMutualFriendsByUserIdFromData
local UserProfiles = require(Parent.UserProfiles)

local function getUserIdsWithLimit(p1, n1: number) -- line: 18
	-- upvalues: Array (copy)
	local v12 = Array.slice(p1, 1, n1 + 1)

	return Array.map(v12, function(p2) -- line: 21
		return p2.id
	end)
end
local function getUsersNamesFromData(p3, t1: {[any]: any}) -- line: 26
	-- upvalues: Array (copy), UserProfiles (copy)
	if p3 then
		return (Array.map(t1, function(p4) -- line: 28
			-- upvalues: UserProfiles (copy), p3 (copy)
			return UserProfiles.Selectors.getCombinedNameFromId(p3, p4)
		end))
	end

	return nil
end
local function useMutualFriendsNamesWithLimit(t2: {[any]: any}) -- line: 34
	-- upvalues: useProfileInsightsByUserIds (copy), getMutualFriendsByUserIdFromData (copy), Array (copy), UserProfiles (copy)
	local v16 = useProfileInsightsByUserIds({
		userIds = { t2.userId }
	})
	local v17 = getMutualFriendsByUserIdFromData(v16.data, t2.userId)
	local limit = t2.limit
	local v19 = Array.slice(v17, 1, limit + 1)
	local v20 = Array.map(v19, function(p5) -- line: 21
		return p5.id
	end)
	local v21 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v20,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local v22 = v16.loading or v21.loading
	local data = v21.data

	return if not data then nil else Array.map(v20, function(p6) -- line: 28
		-- upvalues: UserProfiles (copy), data (copy)
		return UserProfiles.Selectors.getCombinedNameFromId(data, p6)
	end), v22
end

return useMutualFriendsNamesWithLimit
