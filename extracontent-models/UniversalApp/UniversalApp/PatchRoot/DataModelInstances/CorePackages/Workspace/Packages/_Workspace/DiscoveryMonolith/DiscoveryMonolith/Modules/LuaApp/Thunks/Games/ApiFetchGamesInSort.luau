local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Promise = require(DiscoveryMonolithParent.Promise)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local GameSortGroups = DiscoveryTypes.GameSortGroups
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local SetFetchStatus = FetchStatusRodux.SetFetchStatus
local GameFiltersReducer = require(DiscoveryMonolithParent.GameFilters).DataStore.GameFiltersReducer
local getSelectedGameFilterOptions = require(DiscoveryMonolithParent.GameFilters).DataStore.getSelectedGameFilterOptions
local Modules = DiscoveryMonolith.Modules
local ExploreGetSortContents = require(Modules.LuaApp.Http.Requests.ExploreApi.ExploreGetSortContents)
local updateGamesSortData = require(script.Parent.updateGamesSortData)
local DiscoverPageSession = require(Modules.Personalization.Sessions.DiscoverPageSession)

local function v17(p1, p2) -- line: 21
	-- upvalues: SetFetchStatus (copy), FetchStatusNamespace (copy)
	return SetFetchStatus(FetchStatusNamespace.GameSorts, p1, p2)
end

return function(p3, p4, p5, t1: {[any]: any}?) -- line: 25
	-- upvalues: Promise (copy), DiscoveryTypes (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), DiscoverPageSession (copy), GameFiltersReducer (copy), GameSortGroups (copy), getSelectedGameFilterOptions (copy), v17 (copy), ExploreGetSortContents (copy), updateGamesSortData (copy)
	return function(p6) -- line: 26
		-- upvalues: p4 (copy), Promise (copy), DiscoveryTypes (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), t1 (copy), DiscoverPageSession (copy), GameFiltersReducer (copy), GameSortGroups (copy), getSelectedGameFilterOptions (copy), v17 (copy), ExploreGetSortContents (copy), p3 (copy), updateGamesSortData (copy), p5 (copy)
		if p4 == nil or p4.name == nil then
			return Promise.resolve("Invalid sort request")
		end

		assert(p4, "sort should always exist; assert for linter")

		if p4.dataSource ~= DiscoveryTypes.DataSourceType.ExploreApi then
			return Promise.resolve(`Could not fetch games for { p4.name }; expected an ExploreApi sort but the sort is from { p4.dataSource }`)
		end

		if p6:getState().Personalization[FetchStatusReducer.key][FetchStatusNamespace.GameSorts][p4.name] == RetrievalStatus.Fetching then
			return Promise.resolve("Request for sort " .. p4.name .. " has been debounced")
		end

		local v25 = t1 or {}

		v25.sortId = p4.name
		v25.sessionId = DiscoverPageSession:Get()

		local v26 = p6:getState().Personalization[GameFiltersReducer.key][GameSortGroups.Games]

		for v27, v28 in (getSelectedGameFilterOptions(if not v26 then {} else v26.allFilters)) do
			if v25[v27] then
				warn(`URL parameter { v27 } already exists`)
			else
				v25[v27] = v28
			end
		end

		p6:dispatch(v17(p4.name, RetrievalStatus.Fetching))

		return ExploreGetSortContents(p3, v25):andThen(function(p7) -- line: 64
			-- upvalues: updateGamesSortData (copy), p3 (copy), p6 (copy), p5 (copy), v17 (copy), p4 (copy), RetrievalStatus (copy)
			updateGamesSortData(p3, p6, p7.responseBody, p5)
			p6:dispatch(v17(p4.name, RetrievalStatus.Done))
		end, function(p8) -- line: 68
			-- upvalues: p6 (copy), v17 (copy), p4 (copy), RetrievalStatus (copy), Promise (copy)
			p6:dispatch(v17(p4.name, RetrievalStatus.Failed))

			return Promise.reject(p8)
		end)
	end
end
