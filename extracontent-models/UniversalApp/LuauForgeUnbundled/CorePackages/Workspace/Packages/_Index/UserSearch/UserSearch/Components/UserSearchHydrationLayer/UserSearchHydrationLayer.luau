local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Cryo")

local useMatchSearchPagination = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Utils/useMatchSearchPagination")

local usePaginatedProfileInsightsFetch = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/ProfileInsightsContextFetchWrapper/usePaginatedProfileInsightsFetch")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RoactUtils").Hooks.RoactRodux.useDispatch
local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/NetworkingPresence")
require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")
local HydrateFriendStatuses = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Thunks/HydrateFriendStatuses")
local HydrateFollowingStatuses = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Thunks/HydrateFollowingStatuses")

local fFlagPlayerSearchEnableOnlineFrequents = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagPlayerSearchEnableOnlineFrequents

local fFlagPlayerSearchEnableOnlineFrequentsForAll = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagPlayerSearchEnableOnlineFrequentsForAll
local fFlagUserSearchClassmatesInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagUserSearchClassmatesInsight
local FFlagUserSearchPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchPresenceStoreMigration")
local FFlagMigrateFriendshipStatusesUserSearch = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagMigrateFriendshipStatusesUserSearch")
local fFlagSduiUserSearchTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SharedFlags").FFlagSduiUserSearchTile
local v5

if FFlagMigrateFriendshipStatusesUserSearch or fFlagSduiUserSearchTile then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/DataHydration").Friends.FriendsStore.get()
else
	v5 = nil
end

local v6 = if fFlagSduiUserSearchTile then require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/DataHydration/Following").FollowingStore.get() else nil

local v7 = if fFlagSduiUserSearchTile then require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/DataHydration/ProfileInsights").ProfileInsightsStore.get() else nil

require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/GraphQLServer")

return function(data)
	local v8 = useDispatch()
	local v9 = useMatchSearchPagination({ users = data.users })
	local v10 = fFlagSduiUserSearchTile and {} or usePaginatedProfileInsightsFetch({
		users = data.users or {},
		searchKeyword = data.searchParameters.searchKeyword,
		rankingStrategy = (fFlagPlayerSearchEnableOnlineFrequents and data.enableOnlineFrequents or fFlagPlayerSearchEnableOnlineFrequentsForAll) and "profile_info_boost" or nil
	}) or {}

	local v11 = React.useMemo(function()
		return Cryo.List.map(v9, function(p2)
			return p2.id
		end)
	end, { data.users })

	React.useEffect(function()
		if not FFlagUserSearchPresenceStoreMigration then
			v8(NetworkingPresence.GetPresencesFromUserIds.API(v11))
		end

		if fFlagSduiUserSearchTile then
			local v12 = fFlagPlayerSearchEnableOnlineFrequentsForAll and "profile_info_boost" or nil
			local v13 = {
				rankingStrategy = v12,
				count = fFlagUserSearchClassmatesInsight and v12 and 3 or nil
			}

			for k, v14 in v11 do
				v6.GetIsFollowing(v14)
				v7.GetProfileInsight(v14, v13)
			end
		else
			v8(HydrateFollowingStatuses(v11))
		end

		if FFlagMigrateFriendshipStatusesUserSearch or fFlagSduiUserSearchTile then
			for k, v12 in v11 do
				v5.GetFriendshipStatus(v12)
			end
		else
			v8(HydrateFriendStatuses(v11))
		end
	end, { v11 })

	return data.renderComponent({ mappedProfilesInsights = v10 })
end
