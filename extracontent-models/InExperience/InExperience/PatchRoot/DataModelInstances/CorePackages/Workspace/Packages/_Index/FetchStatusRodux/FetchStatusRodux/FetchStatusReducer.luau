local FetchStatusRodux = script:FindFirstAncestor("FetchStatusRodux")
local SetFetchStatus = require(FetchStatusRodux.SetFetchStatus)
local FetchStatusNamespace = require(FetchStatusRodux.FetchStatusNamespace)

local parent = FetchStatusRodux.Parent
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
require(parent.DiscoveryTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSortDeeplinkFix = SharedFlags.FFlagLuaAppSortDeeplinkFix

local function initializeFetchStatus()
	local gameSortToken = FetchStatusNamespace.GameSortToken
	local v = {
		Games = RetrievalStatus.NotStarted,
		HomeGames = RetrievalStatus.NotStarted,
		GamesSeeAll = RetrievalStatus.NotStarted,
		GamesList = 0
	}
	local gamesList

	if FFlagLuaAppSortDeeplinkFix then
		gamesList = RetrievalStatus.NotStarted
	end

	v.GamesList = gamesList
	return {
		[gameSortToken] = v,
		[FetchStatusNamespace.GameSorts] = {},
		[FetchStatusNamespace.OmniRecommendations] = {},
		[FetchStatusNamespace.SearchLandingPage] = {}
	}
end

return {
	key = "FetchStatusKey",
	reducer = function(p, data)
		local selected = p or initializeFetchStatus()

		if data.type ~= SetFetchStatus.name then
			return selected
		end

		assert(selected, "state should always exist, assert for linter")
		local fetchNamespace = data.fetchNamespace
		local fetchKey = data.fetchKey
		assert(fetchNamespace, "SetFetchStatus does not have a valid fetch namespace")
		assert(fetchKey, `SetFetchStatus does not have a valid fetch key for namespace {fetchNamespace}`)

		local v = selected[fetchNamespace]

		if not v then
			warn(`No namespace {fetchNamespace} defined in FetchStatusReducer for action`)
			return selected
		end

		assert(v, "namespaceState should always exist, assert for linter")

		local clone = table.clone(v)
		clone[fetchKey] = data.fetchStatus

		local clone2 = table.clone(selected)
		clone2[fetchNamespace] = clone
		return clone2
	end
}
