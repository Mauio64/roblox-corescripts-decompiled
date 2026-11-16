local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local useMatchSearchPagination = require(UserSearch.Utils.useMatchSearchPagination)

local usePaginatedProfileInsightsFetch = require(script.Parent.Parent.ProfileInsightsContextFetchWrapper.usePaginatedProfileInsightsFetch)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NetworkingPresence = require(UserSearch.Networking.NetworkingPresence)
require(UserSearch.Common.LocalTypes)
local HydrateFriendStatuses = require(UserSearch.Thunks.HydrateFriendStatuses)
local HydrateFollowingStatuses = require(UserSearch.Thunks.HydrateFollowingStatuses)

local SharedFlags = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequents = SharedFlags.FFlagPlayerSearchEnableOnlineFrequents

local SharedFlags2 = require(parent.SharedFlags)
local FFlagPlayerSearchEnableOnlineFrequentsForAll = SharedFlags2.FFlagPlayerSearchEnableOnlineFrequentsForAll
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserSearchClassmatesInsight = SharedFlags3.FFlagUserSearchClassmatesInsight
local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)
local FFlagMigrateFriendshipStatusesUserSearch = require(UserSearch.Flags.FFlagMigrateFriendshipStatusesUserSearch)
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiUserSearchTile = SharedFlags4.FFlagSduiUserSearchTile
local v

if FFlagMigrateFriendshipStatusesUserSearch or FFlagSduiUserSearchTile then
	local DataHydration = require(parent.DataHydration)
	v = DataHydration.Friends.FriendsStore.get()
else
	v = nil
end

local v2

if FFlagSduiUserSearchTile then
	local Following = require(parent.DataHydration.Following)
	v2 = Following.FollowingStore.get()
else
	v2 = nil
end

local v3

if FFlagSduiUserSearchTile then
	local ProfileInsights = require(parent.DataHydration.ProfileInsights)
	v3 = ProfileInsights.ProfileInsightsStore.get()
else
	v3 = nil
end

require(parent.GraphQLServer)

return function(data)
	local v4 = useDispatch()
	local v5 = useMatchSearchPagination({ users = data.users })
	local mappedProfilesInsights = FFlagSduiUserSearchTile and {} or usePaginatedProfileInsightsFetch({
		users = data.users or {},
		searchKeyword = data.searchParameters.searchKeyword,
		rankingStrategy = (FFlagPlayerSearchEnableOnlineFrequents and data.enableOnlineFrequents or FFlagPlayerSearchEnableOnlineFrequentsForAll) and "profile_info_boost" or nil
	}) or {}

	local v6 = React.useMemo(function()
		return Cryo.List.map(v5, function(p)
			return p.id
		end)
	end, { data.users })

	React.useEffect(function()
		if not FFlagUserSearchPresenceStoreMigration then
			v4(NetworkingPresence.GetPresencesFromUserIds.API(v6))
		end

		if FFlagSduiUserSearchTile then
			local rankingStrategy = FFlagPlayerSearchEnableOnlineFrequentsForAll and "profile_info_boost" or nil
			local v7 = {
				rankingStrategy = rankingStrategy,
				count = FFlagUserSearchClassmatesInsight and rankingStrategy and 3 or nil
			}

			for _, v8 in v6 do
				v2.GetIsFollowing(v8)
				v3.GetProfileInsight(v8, v7)
			end
		else
			v4(HydrateFollowingStatuses(v6))
		end

		if FFlagMigrateFriendshipStatusesUserSearch or FFlagSduiUserSearchTile then
			for _, v7 in v6 do
				v.GetFriendshipStatus(v7)
			end
		else
			v4(HydrateFriendStatuses(v6))
		end
	end, { v6 })

	return data.renderComponent({ mappedProfilesInsights = mappedProfilesInsights })
end
