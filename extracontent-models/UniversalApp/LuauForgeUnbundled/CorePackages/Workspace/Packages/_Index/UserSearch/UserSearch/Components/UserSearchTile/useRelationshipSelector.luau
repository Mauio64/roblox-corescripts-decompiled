local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SignalsReact")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/Constants").RODUX_KEY
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local FFlagMigrateFriendshipStatusesUserSearch = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagMigrateFriendshipStatusesUserSearch")
local fFlagSduiUserSearchTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagSduiUserSearchTile

local FFlagUserSearchRefreshPendingFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchRefreshPendingFriendshipStatus")
local useGetFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/FriendsHydrationReact").useGetFriendshipStatus
local followingStore = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/DataHydration/Following").FollowingStore
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LocalUserIdStore").LocalUserIdStore
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/DataHydration").Friends.FriendsStore.get()

local v6 = { skipFetch = true }

local function useRefetchPendingFriendshipStatus(p2)
	React.useEffect(function()
		local friendshipStatus = v5.GetFriendshipStatus(p2, v6)

		if friendshipStatus and friendshipStatus.data(false) == Enum.FriendStatus.FriendRequestSent then
			v5.RefetchFriendshipStatus(p2)
		end
	end, { p2 })
end

return function(p2)
	if fFlagSduiUserSearchTile then
		local v7 = useGetFriendshipStatus(p2)

		if FFlagUserSearchRefreshPendingFriendshipStatus then
			React.useEffect(function()
				local friendshipStatus = v5.GetFriendshipStatus(p2, v6)

				if
					friendshipStatus
					and friendshipStatus.data(false) == Enum.FriendStatus.FriendRequestSent
				then
					v5.RefetchFriendshipStatus(p2)
				end
			end, { p2 })
		end

		local v8 = React.useMemo(function()
			return followingStore.get().GetIsFollowing(p2)
		end, { p2 })
		local v9 = SignalsReact.useSignalState(v8.data)
		local v10 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)

		return {
			status = v7,
			following = v9 == true,
			isMyself = v10 == p2
		}
	else
		local v7

		if FFlagMigrateFriendshipStatusesUserSearch then
			v7 = useGetFriendshipStatus(p2, v6)

			if FFlagUserSearchRefreshPendingFriendshipStatus then
				React.useEffect(function()
					local friendshipStatus = v5.GetFriendshipStatus(p2, v6)

					if
						friendshipStatus
						and friendshipStatus.data(false) == Enum.FriendStatus.FriendRequestSent
					then
						v5.RefetchFriendshipStatus(p2)
					end
				end, { p2 })
			end
		else
			v7 = nil
		end

		return useSelector(function(p3)
			local v8 = getDeepValue(
					p3,
					string.format("%s.Friends.followings.followingStatuses.%s", RODUX_KEY, p2)
				)
				or {}

			return {
				status = if FFlagMigrateFriendshipStatusesUserSearch then v7 else getDeepValue(
					p3,
					string.format("%s.Friends.friendshipStatus.%s", RODUX_KEY, p2)
				),
				following = v8.isFollowing or false,
				isMyself = p3.LocalUserId == p2
			}
		end)
	end
end
