local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local FriendsCommon = require(parent.FriendsCommon)
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence

function useFetchPaginatedFriendIds()
	local userId = useLocalUserId()
	local ref = React.useRef({})

	local v = useFriendsListOrderedByPresence({ userId = userId, pageSize = 50 })

	local joined = Cryo.List.join(v.onlineFriends, v.offlineFriends)
	local mapped = Cryo.List.map(joined, function(p)
		return p.id
	end)

	local set = Cryo.List.toSet(ref.current)
	local filtered = Cryo.List.filter(mapped, function(p): boolean
		return not set[p]
	end)

	if #filtered > 0 then
		UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds(filtered)
	end

	ref.current = mapped

	return ref.current, v.fetchMoreFriends, v.isEndOfList, v
end

return useFetchPaginatedFriendIds
