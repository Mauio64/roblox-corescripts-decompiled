local module = require("@luauforge/bundled/dqd")
local module2 = require("@luauforge/bundled/dqe")
local module3 = require("@luauforge/bundled/dqr")
local parseAndAddGameInfos = require("@luauforge/bundled/dqm").parseAndAddGameInfos
local addTopicInfos = module3.AddTopicInfos
local module4 = require("@luauforge/bundled/dqs")
local topicContentsEntryModel = module4.TopicContentsEntryModel
local topicContentsModel = module4.TopicContentsModel
local addTopicContents = module4.AddTopicContents
local gameInfoModel = require("@luauforge/bundled/dqf").GameInfoModel
local topicInfoModel = module3.TopicInfoModel
local omniRecommendationsContentType = require("@luauforge/bundled/dqn").OmniRecommendationsContentType
local module5 = require("@luauforge/bundled/drs")
local fetchStatusReducer = module5.FetchStatusReducer
local fetchStatusNamespace = module5.FetchStatusNamespace
local setFetchStatus = module5.SetFetchStatus
local appPage = require("@luauforge/bundled/drn").AppPage
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus

local module6 = require("@luauforge/bundled/dti")
local module7 = require("@luauforge/bundled/dqR")

local function fn(p2, p3)
	return setFetchStatus(fetchStatusNamespace.SearchLandingPage, p2, p3)
end

function LUAUFORGE_MODULE_GLOBALS_dtK_ApiFetchSearchLandingPage(p2, p3, surface)
	return function(object)
		if object:getState().Personalization[fetchStatusReducer.key][fetchStatusNamespace.OmniRecommendations][appPage.SearchLandingPage] == retrievalStatus.Fetching then
			return module2.resolve("Data is fetching")
		end

		object:dispatch(fn(p3, retrievalStatus.Fetching))

		local v5 = { sessionId = p3 }

		if surface then
			v5.surface = surface
		end

		return module6(p2, v5):andThen(function(p4)
			local responseBody = p4.responseBody

			if not responseBody.sorts then
				return module2.reject("No sorts found")
			end

			local sorts = {}
			local v6 = {}

			for k, sort in pairs(responseBody.sorts) do
				if sort.contentType == omniRecommendationsContentType.Game then
					local values = {}

					if sort.games == nil then
						warn(`Sort with {sort.contentType} contentType found with no games table! {sort.sortDisplayName}`)
					elseif #sort.games == 0 then
						warn(`Found no games in this sort: {sort.sortDisplayName}`)
					else
						local function forEachGameInfo(p5, p6)
							topicContentsEntryModel.fromOmniAutocompleteApi(p5):match(function(p7)
								local joined = module.Dictionary.join(p6, p7)
								table.insert(values, joined)
							end):matchError(function(p7)
								warn(p7)
							end)
						end

						parseAndAddGameInfos(
							p2,
							object,
							sort.games,
							gameInfoModel.fromOmniAutocompleteApi,
							forEachGameInfo
						)

						local v7 = {
							entries = values,
							hasMoreRows = false,
							nextPageToken = "",
							nextPageExclusiveStartId = 0,
							rowsRequested = 1,
							updatedTimestamp = tick()
						}

						local v8 = topicInfoModel.fromOmniAutocompleteApi(sort)
						local v9 = topicContentsModel.fromData(v7)
						object:dispatch(addTopicContents(sort.sortId, v9, false))

						table.insert(sorts, sort)
						table.insert(v6, v8)
					end
				elseif sort.contentType == omniRecommendationsContentType.TrendingSearches then
					local v7 = topicInfoModel.fromOmniAutocompleteApi(sort)
					local v8 = {
						entries = sort.queries,
						hasMoreRows = false,
						nextPageToken = "",
						nextPageExclusiveStartId = 0,
						rowsRequested = 1,
						updatedTimestamp = tick()
					}

					local v9 = topicContentsModel.fromData(v8)
					object:dispatch(addTopicContents(sort.sortId, v9, false))
					table.insert(sorts, sort)
					table.insert(v6, v7)
				end
			end

			object:dispatch(addTopicInfos(v6))
			object:dispatch(module7(sorts))
			object:dispatch(fn(p3, retrievalStatus.Done))
			return module2.resolve(p4)
		end):catch(function(p4)
			object:dispatch(fn(p3, retrievalStatus.Failed))
			warn(p4)
			return module2.reject(p4)
		end)
	end
end

return LUAUFORGE_MODULE_GLOBALS_dtK_ApiFetchSearchLandingPage
