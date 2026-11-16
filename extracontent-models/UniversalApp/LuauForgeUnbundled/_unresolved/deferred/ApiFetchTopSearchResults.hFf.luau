local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dzL")
local topicInfoModel = module.TopicInfoModel
local addTopicInfos = module.AddTopicInfos
local omniFeedConstants = require("@luauforge/bundled/cyO").OmniFeedConstants
local parseAndAddGameInfos = require("@luauforge/bundled/dzK").parseAndAddGameInfos
local gameInfoModel = require("@luauforge/deferred/fWM").GameInfoModel
local module2 = require("@luauforge/bundled/dwM")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local module3 = require("@luauforge/bundled/dPI")

local getTopSearchResultsFetchName = require("@luauforge/bundled/edc").getTopSearchResultsFetchName
local module4 = require("@luauforge/bundled/dzJ")
local addTopicContents = module4.AddTopicContents
local topicContentsModel = module4.TopicContentsModel

local modules = require("@luauforge/bundled/dpZ").Modules
local searchGetOmniSearch = modules.LuaApp.Http.Requests.SearchGetOmniSearch
local setSearchInGames = modules.LuaApp.Actions.SetSearchInGames
local gameSearchEntry = modules.LuaApp.Models.GamesApi.GameSearchEntry
local searchInGames = modules.LuaApp.Models.SearchInGames
local mapContentTypeToTreatmentType = modules.Personalization.Search.mapContentTypeToTreatmentType
local addTextSearchResults = modules.LuaApp.Actions.AddTextSearchResults
local getFormattedTextSearchEntry = modules.LuaApp.Models.DiscoveryApi.getFormattedTextSearchEntry
local fFlagSearchEmphasisViewportNonSdui = modules.LuaApp.Flags.FFlagSearchEmphasisViewportNonSdui
local resolveSearchViewportSize = modules.Personalization.OmniFeed.resolveSearchViewportSize

local module5 = require("@luauforge/deferred/hFg")
local module6 = require("@luauforge/bundled/dCb")
local module7 = require("@luauforge/bundled/dAX")

local addSduiRootConfig = require("@luauforge/bundled/dAU").AddSduiRootConfig
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local omniFeedTypes = require("@luauforge/bundled/cyO").OmniFeedTypes
local sduiErrors = require("@luauforge/bundled/dAU").SduiErrors
local sduiLogger = require("@luauforge/bundled/dAU").SduiLogger

local function fn(responseBody)
	local feedItemEntries = {}

	if not (responseBody and responseBody.sorts) then
		return feedItemEntries
	end

	for k, sort in responseBody.sorts do
		local v5 = sort.treatmentType == omniFeedTypes.ServerDrivenUi
		local v6 = not (sort.feedItemKey == nil) and sort.feedItemKey ~= ""

		if v5 and v6 then
			table.insert(feedItemEntries, {
				feedItemKey = sort.feedItemKey,
				topicId = sort.topicId,
				sortIndex = k
			})
		elseif v5 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.NilFeedItemKeyForSduiSort,
				{
					name = `{sort.topicId}`,
					message = `Sdui treatmentType but no feedItemKey for topicId {sort.topicId} at index {k}`
				},
				appPage.SearchPage
			)
		elseif v6 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.InvalidTreatmentTypeWithFeedItemKey,
				{
					name = `{sort.topicId}`,
					message = `Has sdui feedItemKey {sort.feedItemKey} but treatmentType {sort.treatmentType} for topicId {sort.topicId} at index {k}`
				},
				appPage.SearchPage
			)
		end
	end

	return feedItemEntries
end

local function ApiFetchTopSearchResults(p2, data)
	local searchUuid = data.searchUuid
	return performFetch.Single(
		getTopSearchResultsFetchName(data.searchVertical, searchUuid),
		function(object)
			local v5 = {
				searchQuery = data.keyword,
				sessionId = searchUuid,
				globalSessionId = data.omniSearchUuid,
				verticalType = data.searchVertical
			}
			local v6

			if fFlagSearchEmphasisViewportNonSdui then
				local state = object:getState()
				local v7 = if state.Search then state.Search.SearchesInGames[searchUuid] else nil

				v6 = resolveSearchViewportSize(v7, false)

				if v6 then
					v5.viewportWidth = v6.X
					v5.viewportHeight = v6.Y
				end
			else
				v6 = nil
			end

			return searchGetOmniSearch(p2, v5):andThen(function(p3)
				if not (p3 and p3.responseBody) then
					return Promise.reject("No response body")
				end

				local responseBody = p3.responseBody

				local contentGroupTypeSet = {}
				local contentGroupTypesByTopicId = {}

				for k, v7 in responseBody.searchResults or {} do
					local contentGroupType = v7.contentGroupType
					local topicId = v7.topicId

					if contentGroupType == nil or contentGroupTypeSet[contentGroupType] then
						mutedError(`Duplicate content group type received in ApiFetchTopSearchResults: {contentGroupType}. Search results may be wonky.`)
					end

					contentGroupTypeSet[contentGroupType] = true

					module2.assert(
						not contentGroupTypesByTopicId[topicId],
						`Already have contentGroupType for topicId {topicId}! Overwriting existing "{contentGroupTypesByTopicId[topicId]}" with "{contentGroupType}"`
					)

					contentGroupTypesByTopicId[topicId] = contentGroupType

					if contentGroupType == omniFeedConstants.ContentGroupType.User then
						local v8 = module5(v7.contents)

						object:dispatch(module6({
							searchUuid = searchUuid,
							keyword = data.keyword,
							entries = v8
						}))
					elseif contentGroupType == omniFeedConstants.ContentGroupType.Game then
						local v8 = {}
						local universeId = nil
						local function fn2(state, p4)
							if not state.placeId then
								state.placeId = state.rootPlaceId
							end

							if not state.topicId then
								state.topicId = topicId
							end

							if state.emphasis and #v8 == 0 then
								universeId = p4.universeId
							end

							gameSearchEntry.fromJsonData(state, true):match(function(p5)
								table.insert(v8, p5)
							end):matchError(function(p5)
								warn(p5)
							end)
						end

						parseAndAddGameInfos(p2, object, v7.contents, gameInfoModel.fromSearchApi, fn2)

						local v9 = searchInGames.fromOmniSearch(data.keyword, v8, universeId ~= nil, nil)

						if fFlagSearchEmphasisViewportNonSdui then
							v9.viewportSize = v6
						end

						object:dispatch(setSearchInGames(searchUuid, v9))

						object:dispatch(addTopicContents(
							data.searchUuid,
							topicContentsModel.fromData(v9),
							false
						))

						if universeId then
							module3.Game.getGameIconStore(false).getAndFetchGameIcons(
								{ universeId },
								module3.Game.GameIconSize.Large
							)
						end
					elseif contentGroupType == omniFeedConstants.ContentGroupType.Text then
						local formattedTextSearchEntry = getFormattedTextSearchEntry(v7.contents)

						if formattedTextSearchEntry then
							object:dispatch(addTextSearchResults({
								searchUuid = data.searchUuid,
								topicId = topicId,
								entry = formattedTextSearchEntry
							}))
						end
					end
				end

				local v7 = {}

				for k, v8 in responseBody.sorts or {} do
					if not v8.treatmentType then
						v8.treatmentType = mapContentTypeToTreatmentType(contentGroupTypesByTopicId[v8.topicId])
					end

					local v9 = topicInfoModel.fromTopSearchApi(v8, searchUuid)
					v9.topicLayoutData = Cryo.Dictionary.join(v9.topicLayoutData, {
						showHeader = v9.topicLayoutData.showHeader == nil or v9.topicLayoutData.showHeader
					})

					table.insert(v7, v9)
				end

				object:dispatch(addTopicInfos(v7))
				object:dispatch(module7(searchUuid, v7))

				if responseBody.sdui then
					local v8 = fn(responseBody)

					local success, result = pcall(function()
						object:dispatch(addSduiRootConfig(
							appPage.SearchPage,
							responseBody.sdui,
							tick(),
							v8,
							`{appPage.SearchPage}_{searchUuid}`
						))
					end)

					if not success then
						local v9 = ""

						if v8 and #v8 > 0 then
							for k, v10 in v8 do
								v9 = `{v9} {v10.topicId}`
							end
						end

						sduiLogger.reportError(
							sduiErrors.SduiErrorType.ErrorStoringTopSearchData,
							{
								name = "search-api/omni-search",
								message = `Error storing top search response: {result} topicIds: {v9}`
							},
							appPage.SearchPage
						)
					end
				end

				return Promise.resolve()
			end, function(p3)
				warn(`Promise rejection for ApiFetchTopSearchResults: {p3}`)
				return Promise.reject()
			end)
		end
	)
end

return ApiFetchTopSearchResults
