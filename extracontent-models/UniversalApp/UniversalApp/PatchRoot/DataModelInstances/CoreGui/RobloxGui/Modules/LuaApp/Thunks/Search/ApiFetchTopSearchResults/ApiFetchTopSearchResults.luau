local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Cryo = require(CorePackages.Packages.Cryo)
local TopicInfosRodux = require(CorePackages.Workspace.Packages.TopicInfosRodux)
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local AddTopicInfos = TopicInfosRodux.AddTopicInfos
local OmniFeedConstants = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedConstants
local parseAndAddGameInfos = require(CorePackages.Workspace.Packages.GameInfosRodux).parseAndAddGameInfos
local GameInfoModel = require(CorePackages.Workspace.Packages.GameModels).GameInfoModel
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local GameIconRodux = require(CorePackages.Workspace.Packages.GameIconRodux)
local BigGameIconReducer = GameIconRodux.BigGameIcons.BigGameIconReducer
local ApiFetchBigGameIcons = GameIconRodux.BigGameIcons.ApiFetchBigGameIcons
local getTopSearchResultsFetchName = require(CorePackages.Workspace.Packages.DiscoveryUtils).getTopSearchResultsFetchName
local TopicContentsRodux = require(CorePackages.Workspace.Packages.TopicContentsRodux)
local AddTopicContents = TopicContentsRodux.AddTopicContents
local TopicContentsModel = TopicContentsRodux.TopicContentsModel
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SearchGetOmniSearch = Modules.LuaApp.Http.Requests.SearchGetOmniSearch
local SetSearchInGames = Modules.LuaApp.Actions.SetSearchInGames
local GameSearchEntry = Modules.LuaApp.Models.GamesApi.GameSearchEntry
local SearchInGames = Modules.LuaApp.Models.SearchInGames
local mapContentTypeToTreatmentType = Modules.Personalization.Search.mapContentTypeToTreatmentType
local AddTextSearchResults = Modules.LuaApp.Actions.AddTextSearchResults
local getFormattedTextSearchEntry = Modules.LuaApp.Models.DiscoveryApi.getFormattedTextSearchEntry
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local getFormattedUserSearchEntries = require(Modules2.LuaApp.Components.UserSearch.Models.getFormattedUserSearchEntries)
local AddUsersSearchResults = require(Modules2.LuaApp.Components.UserSearch.Actions.AddUsersSearchResults)
local AddSearchResultsOmniFeedSorts = require(Modules2.Personalization.OmniFeed.DataStore.AddSearchResultsOmniFeedSorts)
local AddSduiRootConfig = require(CorePackages.Workspace.Packages.ServerDrivenUi).AddSduiRootConfig
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local OmniFeedTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedTypes
local SduiErrors = require(CorePackages.Workspace.Packages.ServerDrivenUi).SduiErrors
local SduiLogger = require(CorePackages.Workspace.Packages.ServerDrivenUi).SduiLogger

local function v37(p1) -- line: 44
	-- upvalues: OmniFeedTypes (copy), SduiLogger (copy), SduiErrors (copy), AppPage (copy)
	local t1 = {}

	if p1 and p1.sorts then
		for v41, v42 in p1.sorts do
			local v43 = v42.treatmentType == OmniFeedTypes.ServerDrivenUi
			local v44 = v42.feedItemKey ~= nil and v42.feedItemKey ~= ""

			if v43 and v44 then
				table.insert(t1, {
					feedItemKey = v42.feedItemKey,
					topicId = v42.topicId,
					sortIndex = v41
				})
			elseif v43 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.NilFeedItemKeyForSduiSort, {
					name = `{ v42.topicId }`,
					message = `Sdui treatmentType but no feedItemKey for topicId { v42.topicId } at index { v41 }`
				}, AppPage.SearchPage)
			elseif v44 then
				SduiLogger.reportError(SduiErrors.SduiErrorType.InvalidTreatmentTypeWithFeedItemKey, {
					name = `{ v42.topicId }`,
					message = `Has sdui feedItemKey { v42.feedItemKey } but treatmentType { v42.treatmentType } for topicId { v42.topicId } at index { v41 }`
				}, AppPage.SearchPage)
			end
		end
	end

	return t1
end
local function ApiFetchTopSearchResults(p2, t2: {[any]: any}) -- line: 88
	-- upvalues: PerformFetch (copy), getTopSearchResultsFetchName (copy), SearchGetOmniSearch (copy), Promise (copy), mutedError (copy), ArgCheck (copy), OmniFeedConstants (copy), getFormattedUserSearchEntries (copy), AddUsersSearchResults (copy), GameSearchEntry (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), SearchInGames (copy), SetSearchInGames (copy), AddTopicContents (copy), TopicContentsModel (copy), BigGameIconReducer (copy), ApiFetchBigGameIcons (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), mapContentTypeToTreatmentType (copy), TopicInfoModel (copy), Cryo (copy), AddTopicInfos (copy), AddSearchResultsOmniFeedSorts (copy), v37 (copy), AddSduiRootConfig (copy), AppPage (copy), SduiLogger (copy), SduiErrors (copy)
	local searchUuid = t2.searchUuid

	return PerformFetch.Single(getTopSearchResultsFetchName(t2.searchVertical, searchUuid), function(p3) -- line: 90
		-- upvalues: SearchGetOmniSearch (copy), p2 (copy), t2 (copy), searchUuid (copy), Promise (copy), mutedError (copy), ArgCheck (copy), OmniFeedConstants (copy), getFormattedUserSearchEntries (copy), AddUsersSearchResults (copy), GameSearchEntry (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), SearchInGames (copy), SetSearchInGames (copy), AddTopicContents (copy), TopicContentsModel (copy), BigGameIconReducer (copy), ApiFetchBigGameIcons (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), mapContentTypeToTreatmentType (copy), TopicInfoModel (copy), Cryo (copy), AddTopicInfos (copy), AddSearchResultsOmniFeedSorts (copy), v37 (copy), AddSduiRootConfig (copy), AppPage (copy), SduiLogger (copy), SduiErrors (copy)
		return SearchGetOmniSearch(p2, {
			searchQuery = t2.keyword,
			sessionId = searchUuid,
			globalSessionId = t2.omniSearchUuid,
			verticalType = t2.searchVertical
		}):andThen(function(p4) -- line: 98
			-- upvalues: Promise (copy), mutedError (copy), ArgCheck (copy), OmniFeedConstants (copy), getFormattedUserSearchEntries (copy), p3 (copy), AddUsersSearchResults (copy), searchUuid (copy), t2 (copy), GameSearchEntry (copy), parseAndAddGameInfos (copy), p2 (copy), GameInfoModel (copy), SearchInGames (copy), SetSearchInGames (copy), AddTopicContents (copy), TopicContentsModel (copy), BigGameIconReducer (copy), ApiFetchBigGameIcons (copy), getFormattedTextSearchEntry (copy), AddTextSearchResults (copy), mapContentTypeToTreatmentType (copy), TopicInfoModel (copy), Cryo (copy), AddTopicInfos (copy), AddSearchResultsOmniFeedSorts (copy), v37 (copy), AddSduiRootConfig (copy), AppPage (copy), SduiLogger (copy), SduiErrors (copy)
			if not p4 or not p4.responseBody then
				return Promise.reject("No response body")
			end

			local responseBody = p4.responseBody
			local t3 = {}
			local t4 = {}

			for _, v54 in responseBody.searchResults or {} do
				local contentGroupType = v54.contentGroupType
				local topicId = v54.topicId

				if contentGroupType == nil or t3[contentGroupType] then
					mutedError(`Duplicate content group type received in ApiFetchTopSearchResults: { contentGroupType }. Search results may be wonky.`)
				end

				t3[contentGroupType] = true
				ArgCheck.assert(not t4[topicId], `Already have contentGroupType for topicId { topicId }! Overwriting existing "{ t4[topicId] }" with "{ contentGroupType }"`)
				t4[topicId] = contentGroupType

				if contentGroupType == OmniFeedConstants.ContentGroupType.User then
					local v57 = getFormattedUserSearchEntries(v54.contents)

					p3:dispatch(AddUsersSearchResults({
						searchUuid = searchUuid,
						keyword = t2.keyword,
						entries = v57
					}))
				elseif contentGroupType == OmniFeedConstants.ContentGroupType.Game then
					local t5 = {}
					local universeId = nil

					parseAndAddGameInfos(p2, p3, v54.contents, GameInfoModel.fromSearchApi, function(p5, p6) -- line: 141
						-- upvalues: topicId (copy), t5 (copy), universeId (ref), GameSearchEntry (copy)
						if not p5.placeId then
							p5.placeId = p5.rootPlaceId
						end

						if not p5.topicId then
							p5.topicId = topicId
						end

						if p5.emphasis and #t5 == 0 then
							universeId = p6.universeId
						end

						GameSearchEntry.fromJsonData(p5, true):match(function(p7) -- line: 153
							-- upvalues: t5 (copy)
							table.insert(t5, p7)
						end):matchError(function(p8) -- line: 156
							warn(p8)
						end)
					end)

					local v60 = SearchInGames.fromOmniSearch(t2.keyword, t5, universeId ~= nil, nil)

					p3:dispatch(SetSearchInGames(searchUuid, v60))
					p3:dispatch(AddTopicContents(t2.searchUuid, TopicContentsModel.fromData(v60), false))

					local v61 = p3:getState()[BigGameIconReducer.key]

					if universeId and v61[universeId] == nil then
						p3:dispatch(ApiFetchBigGameIcons(p2, { universeId }))
					end
				elseif contentGroupType == OmniFeedConstants.ContentGroupType.Text then
					local v62 = getFormattedTextSearchEntry(v54.contents)

					if v62 then
						p3:dispatch(AddTextSearchResults({
							searchUuid = t2.searchUuid,
							topicId = topicId,
							entry = v62
						}))
					end
				end
			end

			local t6 = {}

			for _, v65 in responseBody.sorts or {} do
				if not v65.treatmentType then
					local v66 = t4[v65.topicId]

					v65.treatmentType = mapContentTypeToTreatmentType(v66)
				end

				local v67 = TopicInfoModel.fromTopSearchApi(v65, searchUuid)

				v67.topicLayoutData = Cryo.Dictionary.join(v67.topicLayoutData, {
					showHeader = v67.topicLayoutData.showHeader == nil or v67.topicLayoutData.showHeader
				})
				table.insert(t6, v67)
			end

			p3:dispatch(AddTopicInfos(t6))
			p3:dispatch(AddSearchResultsOmniFeedSorts(searchUuid, t6))

			if responseBody.sdui then
				local u68 = v37(responseBody)
				local ok, result = pcall(function() -- line: 225
					-- upvalues: p3 (copy), AddSduiRootConfig (copy), AppPage (copy), responseBody (copy), u68 (ref), searchUuid (copy)
					p3:dispatch(AddSduiRootConfig(AppPage.SearchPage, responseBody.sdui, tick(), u68, `{ AppPage.SearchPage }_{ searchUuid }`))
				end)

				if not ok then
					local s1 = ""

					if u68 and #u68 > 0 then
						for _, v73 in u68 do
							s1 = `{ s1 } { v73.topicId }`
						end
					end

					SduiLogger.reportError(SduiErrors.SduiErrorType.ErrorStoringTopSearchData, {
						name = "search-api/omni-search",
						message = `Error storing top search response: { result } topicIds: { s1 }`
					}, AppPage.SearchPage)
				end
			end

			return Promise.resolve()
		end, function(p9) -- line: 251
			-- upvalues: Promise (copy)
			warn(`Promise rejection for ApiFetchTopSearchResults: { p9 }`)

			return Promise.reject()
		end)
	end)
end

return ApiFetchTopSearchResults
