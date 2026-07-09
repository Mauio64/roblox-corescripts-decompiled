local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local UserProfiles = require(Parent.UserProfiles)
local useLocalUserId = require(Parent.RobloxAppHooks).useLocalUserId
local useFriendsListOrderedByPresence = require(Parent.FriendsCommon).Hooks.useFriendsListOrderedByPresence

function useFetchPaginatedFriendIds() -- line: 14
	-- upvalues: useLocalUserId (copy), React (copy), useFriendsListOrderedByPresence (copy), Cryo (copy), UserProfiles (copy)
	local v7 = useLocalUserId()
	local v8 = React.useRef({})
	local v9 = useFriendsListOrderedByPresence({
		pageSize = 50,
		userId = v7
	})
	local v10 = Cryo.List.join(v9.onlineFriends, v9.offlineFriends)
	local v11 = Cryo.List.map(v10, function(p1) -- line: 23
		return p1.id
	end)
	local v12 = Cryo.List.toSet(v8.current)
	local v13 = Cryo.List.filter(v11, function(p2) -- line: 27
		-- upvalues: v12 (copy)
		return not v12[p2]
	end)

	if #v13 > 0 then
		UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds(v13)
	end

	v8.current = v11

	return v8.current, v9.fetchMoreFriends, v9.isEndOfList, v9
end

return useFetchPaginatedFriendIds
