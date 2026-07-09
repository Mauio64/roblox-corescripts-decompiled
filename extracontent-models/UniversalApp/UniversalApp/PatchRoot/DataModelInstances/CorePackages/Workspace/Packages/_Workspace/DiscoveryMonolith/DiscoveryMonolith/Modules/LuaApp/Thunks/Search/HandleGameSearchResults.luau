local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Promise = require(DiscoveryMonolithParent.Promise)
local GameInfoModel = require(DiscoveryMonolithParent.GameModels).GameInfoModel
local GameIconRodux = require(DiscoveryMonolithParent.GameIconRodux)
local ApiFetchBigGameIcons = GameIconRodux.BigGameIcons.ApiFetchBigGameIcons
local BigGameIconReducer = GameIconRodux.BigGameIcons.BigGameIconReducer
local parseAndAddGameInfos = require(DiscoveryMonolithParent.GameInfosRodux).parseAndAddGameInfos
local OmniFeedConstants = require(DiscoveryMonolithParent.DiscoveryTypes).OmniFeedConstants
local reportWarning = require(DiscoveryMonolithParent.DiscoveryAnalytics).Points.reportWarning
local LoggingProtocol = require(DiscoveryMonolithParent.LoggingProtocol)
local TopicInfosRodux = require(DiscoveryMonolithParent.TopicInfosRodux)
local AddTopicInfos = TopicInfosRodux.AddTopicInfos
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local TopicContentsRodux = require(DiscoveryMonolithParent.TopicContentsRodux)
local AddTopicContents = TopicContentsRodux.AddTopicContents
local TopicContentsModel = TopicContentsRodux.TopicContentsModel
local Modules = DiscoveryMonolith.Modules
local SetSearchInGamesStatus = require(Modules.LuaApp.Actions.SetSearchInGamesStatus)
local SearchRetrievalStatus = require(Modules.LuaApp.Enum.SearchRetrievalStatus)
local SetSearchInGames = require(Modules.LuaApp.Actions.SetSearchInGames)
local AppendSearchInGames = require(Modules.LuaApp.Actions.AppendSearchInGames)
local GameSearchEntry = require(Modules.LuaApp.Models.GamesApi.GameSearchEntry)
local SearchInGames = require(Modules.LuaApp.Models.SearchInGames)
local mapContentTypeToTreatmentType = require(Modules.Personalization.Search.mapContentTypeToTreatmentType)
local AddSearchResultsOmniFeed = require(Modules.Personalization.OmniFeed.DataStore.AddSearchResultsOmniFeed)
local getFormattedTextSearchEntry = require(Modules.LuaApp.Models.DiscoveryApi.getFormattedTextSearchEntry)
local AddTextSearchResults = require(Modules.LuaApp.Actions.AddTextSearchResults)

return function(p1, t1: {[any]: any}, p2) -- line: 41
	-- upvalues: BigGameIconReducer (copy), SearchRetrievalStatus (copy), Promise (copy), mapContentTypeToTreatmentType (copy), OmniFeedConstants (copy), Cryo (copy), GameSearchEntry (copy), AddSearchResultsOmniFeed (copy), reportWarning (copy), LoggingProtocol (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), TopicInfoModel (copy), AddTopicInfos (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), SearchInGames (copy), AppendSearchInGames (copy), SetSearchInGames (copy), AddTopicContents (copy), TopicContentsModel (copy), SetSearchInGamesStatus (copy), ApiFetchBigGameIcons (copy)
	return function(p3) -- line: 42
		-- upvalues: BigGameIconReducer (copy), p2 (copy), t1 (copy), SearchRetrievalStatus (copy), Promise (copy), mapContentTypeToTreatmentType (copy), OmniFeedConstants (copy), Cryo (copy), GameSearchEntry (copy), AddSearchResultsOmniFeed (copy), reportWarning (copy), LoggingProtocol (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), TopicInfoModel (copy), AddTopicInfos (copy), parseAndAddGameInfos (copy), p1 (copy), GameInfoModel (copy), SearchInGames (copy), AppendSearchInGames (copy), SetSearchInGames (copy), AddTopicContents (copy), TopicContentsModel (copy), SetSearchInGamesStatus (copy), ApiFetchBigGameIcons (copy)
		local t2 = {}
		local v35 = p3:getState()[BigGameIconReducer.key]
		local responseBody = p2.responseBody

		if p3:getState().RequestsStatus.SearchesInGamesStatus[t1.searchUuid] == SearchRetrievalStatus.Removed then
			return Promise.resolve("Search with Uuid " .. t1.searchUuid .. " has been terminated")
		end

		local universeId = nil
		local u38 = false
		local t3 = {}
		local n1 = 1
		local t4 = {}

		if responseBody.sorts then
			for _, v43 in responseBody.sorts do
				if v43.topicId and v43.topicLayoutData then
					t4[v43.topicId] = v43.topicLayoutData
				end
			end
		end

		local t5 = {}
		local t6 = {}

		for k, v in pairs(responseBody.searchResults) do
			local v48 = v.contents[1]
			local topicId = v.topicId
			local v50 = t4[topicId] or {}
			local contentGroupType = v.contentGroupType
			local v52 = mapContentTypeToTreatmentType(v.contentGroupType)

			if contentGroupType == OmniFeedConstants.ContentGroupType.Game then
				local str = tostring(v48.rootPlaceId)

				table.insert(t3, v48)

				local v54 = Cryo.Dictionary.join(v48, {
					topicId = topicId,
					placeId = str
				})

				GameSearchEntry.fromJsonData(v54, true):match(function(p4) -- line: 91
					-- upvalues: t2 (copy), n1 (ref), p3 (copy), AddSearchResultsOmniFeed (copy), t1 (copy), topicId (copy), v52 (copy), v50 (copy), v48 (copy), universeId (ref), u38 (ref)
					t2[n1] = p4
					p3:dispatch(AddSearchResultsOmniFeed(t1.searchUuid, topicId, v52, n1, v50))

					if n1 == 1 and v48.emphasis then
						universeId = v48.universeId
						u38 = true
					end

					n1 += 1
				end):matchError(function(p5) -- line: 111
					-- upvalues: reportWarning (copy), LoggingProtocol (copy)
					reportWarning(LoggingProtocol.default, "GameSearchEntryParseError", p5)
				end)
			elseif contentGroupType == OmniFeedConstants.ContentGroupType.Text then
				local v55 = getFormattedTextSearchEntry(v.contents)

				if v55 then
					p3:dispatch(AddSearchResultsOmniFeed(t1.searchUuid, topicId, v52, k, v50))
					p3:dispatch(AddTextSearchResults({
						searchUuid = t1.searchUuid,
						topicId = topicId,
						entry = v55
					}))
				end
			end

			if not t6[topicId] then
				t6[topicId] = true
				table.insert(t5, (TopicInfoModel.fromSearchApi({
					topicId = topicId,
					treatmentType = mapContentTypeToTreatmentType(v.contentGroupType),
					topicLayoutData = v50
				}, t1.searchUuid)))
			end
		end

		p3:dispatch(AddTopicInfos(t5))
		parseAndAddGameInfos(p1, p3, t3, GameInfoModel.fromSearchApi, nil)

		local v56 = SearchInGames.fromOmniSearch(t1.searchKeyword, t2, u38, responseBody.nextPageToken, responseBody.paginationMethod)

		if t1.isAppend then
			p3:dispatch(AppendSearchInGames(t1.searchUuid, v56))
		else
			p3:dispatch(SetSearchInGames(t1.searchUuid, v56))
		end

		p3:dispatch(AddTopicContents(t1.searchUuid, TopicContentsModel.fromData(v56), t1.isAppend))
		p3:dispatch(SetSearchInGamesStatus(t1.searchUuid, SearchRetrievalStatus.Done))

		if universeId and v35[universeId] == nil then
			p3:dispatch(ApiFetchBigGameIcons(p1, { universeId }))
		end

		return Promise.resolve()
	end
end
