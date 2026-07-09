local HttpService = game:GetService("HttpService")
local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local tutils = require(DiscoveryMonolithParent.tutils)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local useDispatch = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useSelector
local TopicInfosReducer = require(DiscoveryMonolithParent.TopicInfosRodux).TopicInfosReducer
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local SetFetchStatus = FetchStatusRodux.SetFetchStatus
local NextDataExpirationTimeRodux = require(DiscoveryMonolithParent.NextDataExpirationTimeRodux)
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local Modules = DiscoveryMonolith.Modules
local ApiFetchGamesInSort = require(Modules.LuaApp.Thunks.Games.ApiFetchGamesInSort)

local function useLoadGamesForSortFromGamesApi(s1: string) -- line: 31
	-- upvalues: React (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useSelector (copy), TopicInfosReducer (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), tutils (copy), ApiFetchGamesInSort (copy), HttpService (copy), SetFetchStatus (copy), SetNextDataExpirationTime (copy), GameSortGroups (copy), ExpirationTimeNamespace (copy)
	local v24, v25 = React.useState(0)
	local v26 = useRoactService(RoactNetworking)
	local v27 = useDispatch()
	local v28 = useSelector(function(p1) -- line: 35
		-- upvalues: TopicInfosReducer (copy), s1 (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy)
		local v32 = p1.Personalization[TopicInfosReducer.key][s1]

		if v32 and v32:isOmni() then
			v32 = nil
		end

		local v33 = p1.Personalization[FetchStatusReducer.key][FetchStatusNamespace.GameSorts][s1] or RetrievalStatus.NotStarted

		return {
			gamesApiGameSort = v32,
			gameSortFetchingStatus = v33
		}
	end, tutils.shallowEqual)
	local gamesApiGameSort = v28.gamesApiGameSort
	local gameSortFetchingStatus = v28.gameSortFetchingStatus

	return (React.useCallback(function() -- line: 53
		-- upvalues: gamesApiGameSort (copy), gameSortFetchingStatus (copy), RetrievalStatus (copy), v27 (copy), ApiFetchGamesInSort (copy), v26 (copy), v24 (copy), HttpService (copy), SetFetchStatus (copy), FetchStatusNamespace (copy), SetNextDataExpirationTime (copy), GameSortGroups (copy), ExpirationTimeNamespace (copy), v25 (copy)
		if gamesApiGameSort == nil or gameSortFetchingStatus ~= RetrievalStatus.NotStarted then
			return
		end

		assert(gamesApiGameSort, "gamesApiGameSort can never be nil")
		v27(ApiFetchGamesInSort(v26, gamesApiGameSort, false, nil)):catch(function(p2) -- line: 58
			-- upvalues: v24 (copy), HttpService (copy), v27 (copy), SetFetchStatus (copy), FetchStatusNamespace (copy), gamesApiGameSort (copy), RetrievalStatus (copy), SetNextDataExpirationTime (copy), GameSortGroups (copy), ExpirationTimeNamespace (copy), v25 (copy)
			if v24 > 2 then
				return
			end

			if p2 and p2.Body then
				local ok, result = pcall(function() -- line: 69
					-- upvalues: HttpService (copy), p2 (copy)
					return HttpService:JSONDecode(p2.Body)
				end)

				if ok and result and result.errors then
					for _, v in ipairs(result.errors) do
						if v.code == 400 and v.field == "sortToken" then
							v27(SetFetchStatus(FetchStatusNamespace.GameSorts, gamesApiGameSort.name, RetrievalStatus.NotStarted))
							v27(SetNextDataExpirationTime(GameSortGroups.Games, 0, ExpirationTimeNamespace.GameSortGroup))
							v25(v24 + 1)
						end
					end
				end
			end
		end)
	end, {
		gamesApiGameSort,
		gameSortFetchingStatus,
		v24,
		v26,
		v27
	}))
end

return useLoadGamesForSortFromGamesApi
