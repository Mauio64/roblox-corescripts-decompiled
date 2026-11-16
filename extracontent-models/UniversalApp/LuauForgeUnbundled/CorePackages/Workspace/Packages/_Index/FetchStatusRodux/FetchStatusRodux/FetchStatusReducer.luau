local SetFetchStatus = require("@game/CorePackages/Workspace/Packages/_Index/FetchStatusRodux/FetchStatusRodux/SetFetchStatus")
local FetchStatusNamespace = require("@game/CorePackages/Workspace/Packages/_Index/FetchStatusRodux/FetchStatusRodux/FetchStatusNamespace")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/FetchStatusRodux/Http").Enum.RetrievalStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/FetchStatusRodux/DiscoveryTypes")

local fFlagLuaAppSortDeeplinkFix = require("@game/CorePackages/Workspace/Packages/_Workspace/FetchStatusRodux/SharedFlags").FFlagLuaAppSortDeeplinkFix

local function initializeFetchStatus()
	local gameSortToken = FetchStatusNamespace.GameSortToken
	local v6 = {
		Games = retrievalStatus.NotStarted,
		HomeGames = retrievalStatus.NotStarted,
		GamesSeeAll = retrievalStatus.NotStarted,
		GamesList = 0
	}
	local v7 = if fFlagLuaAppSortDeeplinkFix then retrievalStatus.NotStarted else nil
	v6.GamesList = v7
	return {
		[gameSortToken] = v6,
		[FetchStatusNamespace.GameSorts] = {},
		[FetchStatusNamespace.OmniRecommendations] = {},
		[FetchStatusNamespace.SearchLandingPage] = {}
	}
end

return {
	key = "FetchStatusKey",
	reducer = function(p2, data)
		local v5 = p2 or initializeFetchStatus()

		if data.type ~= SetFetchStatus.name then
			return v5
		end

		assert(v5, "state should always exist, assert for linter")
		local fetchNamespace = data.fetchNamespace
		local fetchKey = data.fetchKey
		assert(fetchNamespace, "SetFetchStatus does not have a valid fetch namespace")
		assert(fetchKey, `SetFetchStatus does not have a valid fetch key for namespace {fetchNamespace}`)

		local v6 = v5[fetchNamespace]

		if not v6 then
			warn(`No namespace {fetchNamespace} defined in FetchStatusReducer for action`)
			return v5
		end

		assert(v6, "namespaceState should always exist, assert for linter")

		local clone = table.clone(v6)
		clone[fetchKey] = data.fetchStatus

		local clone2 = table.clone(v5)
		clone2[fetchNamespace] = clone
		return clone2
	end
}
