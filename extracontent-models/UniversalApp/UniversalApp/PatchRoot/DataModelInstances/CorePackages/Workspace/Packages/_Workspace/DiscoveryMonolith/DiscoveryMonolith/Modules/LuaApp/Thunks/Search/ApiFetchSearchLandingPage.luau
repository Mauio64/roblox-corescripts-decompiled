local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Promise = require(DiscoveryMonolithParent.Promise)
local TopicInfosRodux = require(DiscoveryMonolithParent.TopicInfosRodux)
local parseAndAddGameInfos = require(DiscoveryMonolithParent.GameInfosRodux).parseAndAddGameInfos
local AddTopicInfos = TopicInfosRodux.AddTopicInfos
local TopicContentsRodux = require(DiscoveryMonolithParent.TopicContentsRodux)
local TopicContentsEntryModel = TopicContentsRodux.TopicContentsEntryModel
local TopicContentsModel = TopicContentsRodux.TopicContentsModel
local AddTopicContents = TopicContentsRodux.AddTopicContents
local GameInfoModel = require(DiscoveryMonolithParent.GameModels).GameInfoModel
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local OmniRecommendationsContentType = require(DiscoveryMonolithParent.DiscoveryTypes).OmniRecommendationsContentType
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local SetFetchStatus = FetchStatusRodux.SetFetchStatus
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local Modules = DiscoveryMonolith.Modules
local GetSearchLandingPageSuggestion = require(Modules.LuaApp.Http.Requests.GamesApi.GetSearchLandingPageSuggestion)
local SetOmniAutocompleteSorts = require(Modules.LuaApp.Actions.Games.SetOmniAutocompleteSorts)

local function v24(p1, p2) -- line: 30
	-- upvalues: SetFetchStatus (copy), FetchStatusNamespace (copy)
	return SetFetchStatus(FetchStatusNamespace.SearchLandingPage, p1, p2)
end

function ApiFetchSearchLandingPage(p3, s1: string, p4) -- line: 34
	-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), AppPage (copy), RetrievalStatus (copy), Promise (copy), v24 (copy), GetSearchLandingPageSuggestion (copy), OmniRecommendationsContentType (copy), TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), TopicInfoModel (copy), TopicContentsModel (copy), AddTopicContents (copy), AddTopicInfos (copy), SetOmniAutocompleteSorts (copy)
	return function(p5) -- line: 35
		-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), AppPage (copy), RetrievalStatus (copy), Promise (copy), v24 (copy), s1 (copy), p4 (copy), GetSearchLandingPageSuggestion (copy), p3 (copy), OmniRecommendationsContentType (copy), TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), TopicInfoModel (copy), TopicContentsModel (copy), AddTopicContents (copy), AddTopicInfos (copy), SetOmniAutocompleteSorts (copy)
		if p5:getState().Personalization[FetchStatusReducer.key][FetchStatusNamespace.OmniRecommendations][AppPage.SearchLandingPage] == RetrievalStatus.Fetching then
			return Promise.resolve("Data is fetching")
		end

		p5:dispatch(v24(s1, RetrievalStatus.Fetching))

		local t1 = {
			sessionId = s1
		}

		if p4 then
			t1.surface = p4
		end

		return GetSearchLandingPageSuggestion(p3, t1):andThen(function(p6) -- line: 49
			-- upvalues: Promise (copy), OmniRecommendationsContentType (copy), TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), p3 (copy), p5 (copy), GameInfoModel (copy), TopicInfoModel (copy), TopicContentsModel (copy), AddTopicContents (copy), AddTopicInfos (copy), SetOmniAutocompleteSorts (copy), v24 (copy), s1 (copy), RetrievalStatus (copy)
			local responseBody = p6.responseBody

			if not responseBody.sorts then
				return Promise.reject("No sorts found")
			end

			local t2 = {}
			local t3 = {}

			for _, v in pairs(responseBody.sorts) do
				if v.contentType == OmniRecommendationsContentType.Game then
					local t4 = {}

					if v.games == nil then
						warn(`Sort with { v.contentType } contentType found with no games table! { v.sortDisplayName }`)
					elseif #v.games == 0 then
						warn(`Found no games in this sort: { v.sortDisplayName }`)
					else
						local function forEachGameInfo(p7, p8) -- line: 74
							-- upvalues: TopicContentsEntryModel (copy), Cryo (copy), t4 (copy)
							TopicContentsEntryModel.fromOmniAutocompleteApi(p7):match(function(p9) -- line: 78
								-- upvalues: Cryo (copy), p8 (copy), t4 (copy)
								local v50 = Cryo.Dictionary.join(p8, p9)

								table.insert(t4, v50)
							end):matchError(function(p10) -- line: 82
								warn(p10)
							end)
						end

						parseAndAddGameInfos(p3, p5, v.games, GameInfoModel.fromOmniAutocompleteApi, forEachGameInfo)

						local t5 = {
							hasMoreRows = false,
							nextPageToken = "",
							nextPageExclusiveStartId = 0,
							rowsRequested = 1,
							entries = t4,
							updatedTimestamp = tick()
						}
						local v41 = TopicInfoModel.fromOmniAutocompleteApi(v)
						local v42 = TopicContentsModel.fromData(t5)

						p5:dispatch(AddTopicContents(v.sortId, v42, false))
						table.insert(t3, v)
						table.insert(t2, v41)
					end
				elseif v.contentType == OmniRecommendationsContentType.TrendingSearches then
					local v43 = TopicInfoModel.fromOmniAutocompleteApi(v)
					local t6 = {
						hasMoreRows = false,
						nextPageToken = "",
						nextPageExclusiveStartId = 0,
						rowsRequested = 1,
						entries = v.queries,
						updatedTimestamp = tick()
					}
					local v45 = TopicContentsModel.fromData(t6)

					p5:dispatch(AddTopicContents(v.sortId, v45, false))
					table.insert(t3, v)
					table.insert(t2, v43)
				end
			end

			p5:dispatch(AddTopicInfos(t2))
			p5:dispatch(SetOmniAutocompleteSorts(t3))
			p5:dispatch(v24(s1, RetrievalStatus.Done))

			return Promise.resolve(p6)
		end):catch(function(p11) -- line: 133
			-- upvalues: p5 (copy), v24 (copy), s1 (copy), RetrievalStatus (copy), Promise (copy)
			p5:dispatch(v24(s1, RetrievalStatus.Failed))
			warn(p11)

			return Promise.reject(p11)
		end)
	end
end

return ApiFetchSearchLandingPage
