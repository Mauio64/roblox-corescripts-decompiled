local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Promise = require(DiscoveryMonolithParent.Promise)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local TopicInfosRodux = require(DiscoveryMonolithParent.TopicInfosRodux)
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local AddTopicInfos = TopicInfosRodux.AddTopicInfos
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local SetFetchStatus = FetchStatusRodux.SetFetchStatus
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local ExploreContentType = require(DiscoveryMonolithParent.DiscoveryTypes).ExploreContentType
local updateGameFiltersData = require(DiscoveryMonolithParent.GameFilters).DataStore.updateGameFiltersData
local GameFiltersReducer = require(DiscoveryMonolithParent.GameFilters).DataStore.GameFiltersReducer
local getSelectedGameFilterOptions = require(DiscoveryMonolithParent.GameFilters).DataStore.getSelectedGameFilterOptions
local flaggedMutedError = require(DiscoveryMonolithParent.Loggers).flaggedMutedError
local OmniFeedPageSection = require(DiscoveryMonolithParent.DiscoveryTypes).OmniFeedConstants.OmniFeedPageSection
local Modules = DiscoveryMonolith.Modules
local DiscoverPageSession = require(Modules.Personalization.Sessions.DiscoverPageSession)
local updateGamesSortData = require(Modules.LuaApp.Thunks.Games.updateGamesSortData)
local updateSongsSortData = require(Modules.LuaApp.Thunks.Songs.updateSongsSortData)
local SetPageSessionTimestamp = require(Modules.Personalization.Sessions.DataStore.SetPageSessionTimestamp)
local ExploreGetSorts = require(Modules.LuaApp.Http.Requests.ExploreApi.ExploreGetSorts)
local ExploreGetSortsMetadata = require(Modules.LuaApp.Http.Requests.ExploreApi.ExploreGetSortsMetadata)
local AppendGameSortsInGroup = require(Modules.LuaApp.Actions.Games.AppendGameSortsInGroup)
local SetGameSortsInGroup = require(Modules.LuaApp.Actions.Games.SetGameSortsInGroup)
local SetDiscoveryNextPageId = require(Modules.Personalization.Games.Discovery.SetDiscoveryNextPageId)
local AddExploreOmniItems = require(Modules.Personalization.OmniFeed.DataStore.AddExploreOmniItems)
local NextDataExpirationTimeRodux = require(DiscoveryMonolithParent.NextDataExpirationTimeRodux)
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local FFlagEnableTopSongsSort = require(DiscoveryMonolithParent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppFixGamesListSortTokenExpiringTime = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppFixGamesListSortTokenExpiringTime
local FFlagLuaAppChartsStickyHeader = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsStickyHeader
local FFlagLuaAppFixChartsRenderOnFail = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppFixChartsRenderOnFail
local v39 = game:DefineFastFlag("LuaAppErrorOnBadSortGroup", false)
local v40 = game:DefineFastInt("LuaAppGamesListSortTokenExpiryInSec", 600)

local function v41(p1, p2) -- line: 49
	-- upvalues: SetFetchStatus (copy), FetchStatusNamespace (copy)
	return SetFetchStatus(FetchStatusNamespace.GameSortToken, p1, p2)
end
local function parseExploreSortDataIntoStore(p3, p4, p5, p6, p7, p8) -- line: 53
	-- upvalues: FFlagLuaAppFixChartsRenderOnFail (copy), Promise (copy), FFlagLuaAppChartsStickyHeader (copy), AppPage (copy), OmniFeedPageSection (copy), TopicInfoModel (copy), ExploreContentType (copy), updateGameFiltersData (copy), updateGamesSortData (copy), SetFetchStatus (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), FFlagEnableTopSongsSort (copy), updateSongsSortData (copy), AddTopicInfos (copy), AppendGameSortsInGroup (copy), SetGameSortsInGroup (copy), GameSortGroups (copy), AddExploreOmniItems (copy)
	if FFlagLuaAppFixChartsRenderOnFail then
		if not p6 then
			return Promise.reject("No sort list found in response.")
		end

		if #p6 == 0 then
			return Promise.resolve()
		end
	elseif not p6 or #p6 == 0 then
		return Promise.reject("No sort data found in response.")
	end

	if FFlagLuaAppChartsStickyHeader then
		local v52 = p4:getState()
		local v53 = v52.Personalization.OrderedOmniItems and v52.Personalization.OrderedOmniItems[AppPage.Games]
		local v54 = if not v53 then {} else v53.allItems or {}

		if p8 == OmniFeedPageSection.Header and #v54 > 0 and v54[#v54].pageSection ~= OmniFeedPageSection.Header and p7 then
			return Promise.reject("Header sorts should not be added when there is already body content, to avoid adding header items in the middle of the feed.")
		end
	end

	local t1 = {}
	local t2 = {}
	local t3 = {}

	for i, v in ipairs(p6) do
		local v60 = TopicInfoModel.fromExploreJsonData(v)

		t1[i] = v60
		t2[i] = v60.name
		t3[i] = v60.topicLayoutData

		if v.contentType == ExploreContentType.Filters then
			updateGameFiltersData(p4, p5, v.filters)
		elseif v.contentType == ExploreContentType.Games then
			if v.games then
				updateGamesSortData(p3, p4, v)
				p4:dispatch(SetFetchStatus(FetchStatusNamespace.GameSorts, v60.name, RetrievalStatus.Done))
			end
		elseif FFlagEnableTopSongsSort and v.contentType == ExploreContentType.Songs then
			if v.songs then
				updateSongsSortData(p4, v, false, p3)
				p4:dispatch(SetFetchStatus(FetchStatusNamespace.GameSorts, v60.name, RetrievalStatus.Done))
			end
		else
			warn(`unsupported explore content type: { v.contentType }`)
		end
	end

	p4:dispatch(AddTopicInfos(t1))

	if p7 then
		p4:dispatch(AppendGameSortsInGroup(p5, t2, t3))
	else
		p4:dispatch(SetGameSortsInGroup(p5, t2, "", t3))
	end

	if p5 == GameSortGroups.Games then
		p4:dispatch(AddExploreOmniItems(AppPage.Games, t1, p7, if not FFlagLuaAppChartsStickyHeader then nil else p8))
	end

	return Promise.resolve()
end
local function fetchToken(p9, p10, p11, p12, p13) -- line: 149
	-- upvalues: GameSortGroups (copy), ExploreGetSortsMetadata (copy), DiscoverPageSession (copy), parseExploreSortDataIntoStore (copy), FFlagLuaAppFixGamesListSortTokenExpiringTime (copy), v40 (copy), SetNextDataExpirationTime (copy), ExpirationTimeNamespace (copy), v41 (copy), RetrievalStatus (copy), GameFiltersReducer (copy), getSelectedGameFilterOptions (copy), Cryo (copy), ExploreGetSorts (copy), Promise (copy), FFlagLuaAppChartsStickyHeader (copy), SetDiscoveryNextPageId (copy), SetPageSessionTimestamp (copy), AppPage (copy), OmniFeedPageSection (copy), v39 (copy), flaggedMutedError (copy)
	local v66 = p12 and p12 ~= ""

	if p11 == GameSortGroups.GamesList then
		return ExploreGetSortsMetadata(p9, DiscoverPageSession:Get()):andThen(function(p14) -- line: 152
			-- upvalues: parseExploreSortDataIntoStore (copy), p9 (copy), p10 (copy), p11 (copy), FFlagLuaAppFixGamesListSortTokenExpiringTime (copy), v40 (copy), SetNextDataExpirationTime (copy), GameSortGroups (copy), ExpirationTimeNamespace (copy), v41 (copy), RetrievalStatus (copy)
			local v76 = p14 and (p14.responseBody and p14.responseBody.sortMetadata)

			return parseExploreSortDataIntoStore(p9, p10, p11, v76):andThen(function() -- line: 154
				-- upvalues: FFlagLuaAppFixGamesListSortTokenExpiringTime (copy), v40 (copy), p10 (copy), SetNextDataExpirationTime (copy), GameSortGroups (copy), ExpirationTimeNamespace (copy), v41 (copy), p11 (copy), RetrievalStatus (copy)
				if FFlagLuaAppFixGamesListSortTokenExpiringTime then
					local v83 = math.floor(tick() + v40)

					p10:dispatch(SetNextDataExpirationTime(GameSortGroups.GamesList, v83, ExpirationTimeNamespace.GameSortGroup))
				end

				p10:dispatch(v41(p11, RetrievalStatus.Done))
			end)
		end):catch(function() -- line: 168
			-- upvalues: p10 (copy), v41 (copy), p11 (copy), RetrievalStatus (copy)
			p10:dispatch(v41(p11, RetrievalStatus.Failed))
		end)
	end

	if p11 == GameSortGroups.Games then
		if not v66 then
			DiscoverPageSession:Refresh()
		end

		local v67 = p10:getState().Personalization[GameFiltersReducer.key][p11]
		local v68 = getSelectedGameFilterOptions(if not v67 then {} else v67.allFilters)
		local v69 = Cryo.Dictionary.join(v68, p13 or {})

		return ExploreGetSorts(p9, p12, v69, DiscoverPageSession:Get()):andThen(function(p15) -- line: 183
			-- upvalues: Promise (copy), FFlagLuaAppChartsStickyHeader (copy), p10 (copy), SetDiscoveryNextPageId (copy), SetPageSessionTimestamp (copy), AppPage (copy), parseExploreSortDataIntoStore (copy), p9 (copy), p11 (copy), v66 (copy), OmniFeedPageSection (copy), v41 (copy), RetrievalStatus (copy)
			if not p15 or (not p15.responseBody or not p15.responseBody.sorts) then
				return Promise.reject("Invalid response")
			end

			local v78 = if not FFlagLuaAppChartsStickyHeader or not p15.responseBody.header then nil else p15.responseBody.header.sorts
			local sorts = p15.responseBody.sorts
			local v80 = p15.responseBody.nextSortsPageToken or ""

			p10:dispatch(SetDiscoveryNextPageId(v80))
			p10:dispatch(SetPageSessionTimestamp(AppPage.Games))

			if FFlagLuaAppChartsStickyHeader and v78 and #v78 > 0 then
				return parseExploreSortDataIntoStore(p9, p10, p11, v78, v66, OmniFeedPageSection.Header):andThen(function() -- line: 197
					-- upvalues: sorts (copy), parseExploreSortDataIntoStore (copy), p9 (copy), p10 (copy), p11 (copy), Promise (copy)
					if sorts and #sorts > 0 then
						return parseExploreSortDataIntoStore(p9, p10, p11, sorts, true)
					end

					return Promise.resolve()
				end):andThen(function() -- line: 211
					-- upvalues: p10 (copy), v41 (copy), p11 (copy), RetrievalStatus (copy)
					return p10:dispatch(v41(p11, RetrievalStatus.Done))
				end)
			end

			return parseExploreSortDataIntoStore(p9, p10, p11, sorts, v66):andThen(function() -- line: 217
				-- upvalues: p10 (copy), v41 (copy), p11 (copy), RetrievalStatus (copy)
				return p10:dispatch(v41(p11, RetrievalStatus.Done))
			end)
		end):catch(function(p16) -- line: 222
			-- upvalues: p10 (copy), v41 (copy), p11 (copy), RetrievalStatus (copy), Promise (copy), FFlagLuaAppChartsStickyHeader (copy)
			p10:dispatch(v41(p11, RetrievalStatus.Failed))

			return Promise.reject(not FFlagLuaAppChartsStickyHeader and "Update failed" or (p16 or "Update failed"))
		end)
	end

	local v70 = `Unsupported GameSortGroups { p11 } called.`

	p10:dispatch(v41(p11, RetrievalStatus.Failed))

	if v39 then
		flaggedMutedError("BadGameSortGroups", v70)
	end

	return Promise.reject(v70)
end

return function(p17, p18, p19, p20) -- line: 241
	-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), Promise (copy), v41 (copy), fetchToken (copy)
	return function(p21) -- line: 242
		-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), p18 (copy), RetrievalStatus (copy), Promise (copy), v41 (copy), fetchToken (copy), p17 (copy), p19 (copy), p20 (copy)
		if p21:getState().Personalization[FetchStatusReducer.key][FetchStatusNamespace.GameSortToken][p18] == RetrievalStatus.Fetching then
			return Promise.resolve("Data is fetching.")
		end

		p21:dispatch(v41(p18, RetrievalStatus.Fetching))

		return fetchToken(p17, p21, p18, p19, p20)
	end
end
