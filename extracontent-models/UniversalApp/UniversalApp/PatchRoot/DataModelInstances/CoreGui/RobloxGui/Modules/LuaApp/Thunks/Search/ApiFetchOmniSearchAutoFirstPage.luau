local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SetSearchInGamesStatus = Modules.LuaApp.Actions.SetSearchInGamesStatus
local SearchRetrievalStatus = Modules.LuaApp.Enum.SearchRetrievalStatus
local SearchGetOmniSearch = Modules.LuaApp.Http.Requests.SearchGetOmniSearch
local HandleGameSearchResults = Modules.LuaApp.Thunks.Search.HandleGameSearchResults
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local SetSearchType = require(Modules2.LuaApp.Actions.SetSearchType)
local OmniSearchVerticalType = require(Modules2.LuaApp.Enum.OmniSearchVerticalType)
local HandleUserSearchResults = require(Modules2.LuaApp.Components.UserSearch.Thunks.HandleUserSearchResults)
local getAutoFetchName = require(Modules2.LuaApp.Thunks.Search.getAutoFetchName)

return function(p1, t1: {[any]: any}) -- line: 27
	-- upvalues: PerformFetch (copy), getAutoFetchName (copy), SetSearchInGamesStatus (copy), SearchRetrievalStatus (copy), SearchGetOmniSearch (copy), OmniSearchVerticalType (copy), SearchTypes (copy), SetSearchType (copy), HandleUserSearchResults (copy), HandleGameSearchResults (copy), Promise (copy)
	return PerformFetch.Single(getAutoFetchName(t1.searchKeyword), function(p2) -- line: 28
		-- upvalues: t1 (copy), SetSearchInGamesStatus (copy), SearchRetrievalStatus (copy), SearchGetOmniSearch (copy), p1 (copy), OmniSearchVerticalType (copy), SearchTypes (copy), SetSearchType (copy), HandleUserSearchResults (copy), HandleGameSearchResults (copy), Promise (copy)
		local t2 = {
			verticalType = "auto",
			searchQuery = t1.searchKeyword,
			sessionId = t1.searchUuid,
			globalSessionId = t1.omniSearchUuid
		}

		p2:dispatch(SetSearchInGamesStatus(t1.searchUuid, SearchRetrievalStatus.Fetching))

		return SearchGetOmniSearch(p1, t2):andThen(function(p3) -- line: 36
			-- upvalues: OmniSearchVerticalType (copy), SearchTypes (copy), p2 (copy), SetSearchType (copy), t1 (copy), SetSearchInGamesStatus (copy), SearchRetrievalStatus (copy), HandleUserSearchResults (copy), p1 (copy), HandleGameSearchResults (copy)
			local v20 = if p3.responseBody.vertical ~= OmniSearchVerticalType.User then SearchTypes.Games else SearchTypes.Players

			p2:dispatch(SetSearchType(t1.searchUuid, v20))

			if v20 == SearchTypes.Players then
				p2:dispatch(SetSearchInGamesStatus(t1.searchUuid, SearchRetrievalStatus.NotStarted))

				return p2:dispatch(HandleUserSearchResults(p1, t1, p3))
			end

			return p2:dispatch(HandleGameSearchResults(p1, t1, p3))
		end, function(p4) -- line: 50
			-- upvalues: p2 (copy), SetSearchInGamesStatus (copy), t1 (copy), SearchRetrievalStatus (copy), Promise (copy)
			p2:dispatch(SetSearchInGamesStatus(t1.searchUuid, SearchRetrievalStatus.Failed))

			return Promise.reject(p4)
		end)
	end)
end
