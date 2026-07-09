local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local ReportToDiagByCountryCode = require(DiscoveryMonolithParent.Analytics).ReportToDiagByCountryCode
local Promise = require(DiscoveryMonolithParent.Promise)
local Modules = DiscoveryMonolith.Modules
local SetSearchInGamesStatus = require(Modules.LuaApp.Actions.SetSearchInGamesStatus)
local SearchRetrievalStatus = require(Modules.LuaApp.Enum.SearchRetrievalStatus)
local SearchGetOmniSearch = require(Modules.LuaApp.Http.Requests.SearchGetOmniSearch)
local HandleGameSearchResults = require(Modules.LuaApp.Thunks.Search.HandleGameSearchResults)
local num = tonumber(settings():GetFVariable("PercentReportingGamesListRTT"))

return function(p1, p2) -- line: 15
	-- upvalues: Promise (copy), SearchRetrievalStatus (copy), SetSearchInGamesStatus (copy), SearchGetOmniSearch (copy), HandleGameSearchResults (copy), ReportToDiagByCountryCode (copy), num (copy)
	return function(p3) -- line: 16
		-- upvalues: p2 (copy), Promise (copy), SearchRetrievalStatus (copy), SetSearchInGamesStatus (copy), SearchGetOmniSearch (copy), p1 (copy), HandleGameSearchResults (copy), ReportToDiagByCountryCode (copy), num (copy)
		local searchKeyword = p2.searchKeyword
		local searchUuid = p2.searchUuid

		if not searchUuid then
			return Promise.reject("Must have a searchUuid.")
		end

		if not searchKeyword then
			return Promise.reject("Must have a searchKeyword to search with.")
		end

		if p3:getState().RequestsStatus.SearchesInGamesStatus[searchUuid] == SearchRetrievalStatus.Fetching then
			return Promise.resolve("Search with Uuid " .. searchUuid .. " has been debounced")
		end

		local t1 = {
			SearchQuery = searchKeyword,
			SessionId = searchUuid,
			PageType = "all",
			GlobalSessionId = p2.omniSearchUuid
		}

		if p2.isAppend then
			local v17 = p3:getState().Search.SearchesInGames[searchUuid]

			assert(v17, "Should always have SearchesInGames for searchUuid")
			t1.PageToken = v17.nextPageToken
		end

		p3:dispatch(SetSearchInGamesStatus(searchUuid, SearchRetrievalStatus.Fetching))

		return SearchGetOmniSearch(p1, t1):andThen(function(p4) -- line: 49
			-- upvalues: p3 (copy), HandleGameSearchResults (copy), p1 (copy), p2 (copy), ReportToDiagByCountryCode (copy), num (copy)
			local v19 = p3:dispatch(HandleGameSearchResults(p1, p2, p4))

			ReportToDiagByCountryCode("GamesList", "RoundTripTime", p4.responseTimeMs, num)

			return v19
		end, function(p5) -- line: 54
			-- upvalues: p3 (copy), SetSearchInGamesStatus (copy), searchUuid (copy), SearchRetrievalStatus (copy), Promise (copy)
			p3:dispatch(SetSearchInGamesStatus(searchUuid, SearchRetrievalStatus.Failed))

			return Promise.reject(p5)
		end)
	end
end
