local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local Constants = require(UserSearch.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local FFlagMigrateFriendshipStatusesUserSearch = require(UserSearch.Flags.FFlagMigrateFriendshipStatusesUserSearch)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiUserSearchTile = SharedFlags.FFlagSduiUserSearchTile

local FFlagUserSearchRefreshPendingFriendshipStatus = require(UserSearch.Flags.FFlagUserSearchRefreshPendingFriendshipStatus)
local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetFriendshipStatus = FriendsHydrationReact.useGetFriendshipStatus
local Following = require(parent.DataHydration.Following)
local FollowingStore = Following.FollowingStore
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

local v2 = { skipFetch = true }

local function useRefetchPendingFriendshipStatus(p: string) -- 2 equivalent calls inferred from this helper
	React.useEffect(function()
		local friendshipStatus = v.GetFriendshipStatus(p, v2)

		if friendshipStatus and friendshipStatus.data(false) == Enum.FriendStatus.FriendRequestSent then
			v.RefetchFriendshipStatus(p)
		end
	end, { p })
end

return function(p: string)
	if FFlagSduiUserSearchTile then
		local status = useGetFriendshipStatus(p)

		if FFlagUserSearchRefreshPendingFriendshipStatus then
			useRefetchPendingFriendshipStatus(p) -- inferred equivalent call
		end

		local v3 = React.useMemo(function()
			return FollowingStore.get().GetIsFollowing(p)
		end, { p })
		local v4 = SignalsReact.useSignalState(v3.data)
		local v5 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)

		return {
			status = status,
			following = v4 == true,
			isMyself = v5 == p
		}
	else
		local v3

		if FFlagMigrateFriendshipStatusesUserSearch then
			v3 = useGetFriendshipStatus(p, v2)

			if FFlagUserSearchRefreshPendingFriendshipStatus then
				useRefetchPendingFriendshipStatus(p) -- inferred equivalent call
			end
		else
			v3 = nil
		end

		return useSelector(function(p2)
			local v4 = getDeepValue(p2, string.format("%s.Friends.followings.followingStatuses.%s", RODUX_KEY, p)) or {}
			local status

			if FFlagMigrateFriendshipStatusesUserSearch then
				status = v3
			else
				status = getDeepValue(p2, string.format("%s.Friends.friendshipStatus.%s", RODUX_KEY, p))
			end

			return {
				status = status,
				following = v4.isFollowing or false,
				isMyself = p2.LocalUserId == p
			}
		end)
	end
end
