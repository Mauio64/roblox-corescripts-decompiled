local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local React = require(UserSearchParent.React)
local Cryo = require(UserSearchParent.Cryo)
local useMatchSearchPagination = require(UserSearch.Utils.useMatchSearchPagination)
local usePaginatedProfileInsightsFetch = require(script.Parent.Parent.ProfileInsightsContextFetchWrapper.usePaginatedProfileInsightsFetch)
local useDispatch = require(UserSearchParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NetworkingPresence = require(UserSearch.Networking.NetworkingPresence)

require(UserSearch.Common.LocalTypes)

local HydrateFriendStatuses = require(UserSearch.Thunks.HydrateFriendStatuses)
local HydrateFollowingStatuses = require(UserSearch.Thunks.HydrateFollowingStatuses)
local FFlagPlayerSearchEnableOnlineFrequents = require(UserSearchParent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents
local FFlagPlayerSearchEnableOnlineFrequentsForAll = require(UserSearchParent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequentsForAll

require(UserSearchParent.GraphQLServer)

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: useDispatch (copy), useMatchSearchPagination (copy), usePaginatedProfileInsightsFetch (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy), React (copy), Cryo (copy), NetworkingPresence (copy), HydrateFollowingStatuses (copy), HydrateFriendStatuses (copy)
	local v14 = useDispatch()
	local v15 = useMatchSearchPagination({
		users = t1.users
	})
	local v16 = usePaginatedProfileInsightsFetch({
		users = t1.users or {},
		searchKeyword = t1.searchParameters.searchKeyword,
		rankingStrategy = if not (not not FFlagPlayerSearchEnableOnlineFrequents and t1.enableOnlineFrequents) and not FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else "profile_info_boost"
	}) or {}
	local v17 = React.useMemo(function() -- line: 51
		-- upvalues: Cryo (copy), v15 (copy)
		return Cryo.List.map(v15, function(p1) -- line: 52
			return p1.id
		end)
	end, { t1.users })

	React.useEffect(function() -- line: 57
		-- upvalues: v14 (copy), NetworkingPresence (copy), v17 (copy), HydrateFollowingStatuses (copy), HydrateFriendStatuses (copy)
		v14(NetworkingPresence.GetPresencesFromUserIds.API(v17))
		v14(HydrateFollowingStatuses(v17))
		v14(HydrateFriendStatuses(v17))
	end, { v17 })

	return t1.renderComponent({
		mappedProfilesInsights = v16
	})
end
