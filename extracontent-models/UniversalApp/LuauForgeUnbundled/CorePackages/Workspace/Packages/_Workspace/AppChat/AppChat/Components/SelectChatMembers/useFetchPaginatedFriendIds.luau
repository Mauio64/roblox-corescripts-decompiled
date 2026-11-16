local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useFriendsListOrderedByPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsCommon").Hooks.useFriendsListOrderedByPresence

function LUAUFORGE_MODULE_GLOBALS_htd_useFetchPaginatedFriendIds()
	local v5 = useLocalUserId()
	local ref = React.useRef({})

	local v6 = useFriendsListOrderedByPresence({ userId = v5, pageSize = 50 })

	local joined = Cryo.List.join(v6.onlineFriends, v6.offlineFriends)
	local mapped = Cryo.List.map(joined, function(p2)
		return p2.id
	end)

	local set = Cryo.List.toSet(ref.current)
	local filtered = Cryo.List.filter(mapped, function(p2): boolean
		return not set[p2]
	end)

	if #filtered > 0 then
		UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds(filtered)
	end

	ref.current = mapped

	return ref.current, v6.fetchMoreFriends, v6.isEndOfList, v6
end

return LUAUFORGE_MODULE_GLOBALS_htd_useFetchPaginatedFriendIds
