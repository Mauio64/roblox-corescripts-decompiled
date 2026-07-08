local FetchStatusRodux = script:FindFirstAncestor("FetchStatusRodux")
local SetFetchStatus = require(FetchStatusRodux.SetFetchStatus)
local FetchStatusNamespace = require(FetchStatusRodux.FetchStatusNamespace)
local FetchStatusRoduxParent = FetchStatusRodux.Parent
local RetrievalStatus = require(FetchStatusRoduxParent.Http).Enum.RetrievalStatus

require(FetchStatusRoduxParent.DiscoveryTypes)

local FFlagLuaAppSortDeeplinkFix = require(FetchStatusRoduxParent.SharedFlags).FFlagLuaAppSortDeeplinkFix

local function initializeFetchStatus() -- line: 11
	-- upvalues: FetchStatusNamespace (copy), RetrievalStatus (copy), FFlagLuaAppSortDeeplinkFix (copy)
	return {
		[FetchStatusNamespace.GameSortToken] = {
			Games = RetrievalStatus.NotStarted,
			HomeGames = RetrievalStatus.NotStarted,
			GamesSeeAll = RetrievalStatus.NotStarted,
			GamesList = if not FFlagLuaAppSortDeeplinkFix then nil else RetrievalStatus.NotStarted
		},
		[FetchStatusNamespace.GameSorts] = {},
		[FetchStatusNamespace.OmniRecommendations] = {},
		[FetchStatusNamespace.SearchLandingPage] = {}
	}
end

return {
	key = "FetchStatusKey",
	reducer = function(p1, p2) -- line: 25
		-- upvalues: initializeFetchStatus (copy), SetFetchStatus (copy)
		local v10 = p1 or initializeFetchStatus()

		if p2.type == SetFetchStatus.name then
			assert(v10, "state should always exist, assert for linter")

			local fetchNamespace = p2.fetchNamespace
			local fetchKey = p2.fetchKey

			assert(fetchNamespace, "SetFetchStatus does not have a valid fetch namespace")
			assert(fetchKey, `SetFetchStatus does not have a valid fetch key for namespace { fetchNamespace }`)

			local v13 = v10[fetchNamespace]

			if not v13 then
				warn(`No namespace { fetchNamespace } defined in FetchStatusReducer for action`)

				return v10
			end

			assert(v13, "namespaceState should always exist, assert for linter")

			local v14 = table.clone(v13)

			v14[fetchKey] = p2.fetchStatus

			local v15 = table.clone(v10)

			v15[fetchNamespace] = v14

			return v15
		end

		return v10
	end
}
