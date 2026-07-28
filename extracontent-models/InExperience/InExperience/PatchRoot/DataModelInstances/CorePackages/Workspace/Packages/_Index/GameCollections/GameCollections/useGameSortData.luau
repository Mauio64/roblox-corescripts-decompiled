local Parent = script:FindFirstAncestor("GameCollections").Parent
local RetrievalStatus = require(Parent.Http).Enum.RetrievalStatus
local tutils = require(Parent.tutils)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local AppPage = require(Parent.RobloxAppEnums).AppPage
local memoize = require(Parent.AppCommonLib).memoize
local TopicInfosRodux = require(Parent.TopicInfosRodux)
local TopicInfosReducer = TopicInfosRodux.TopicInfosReducer
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local GameSortGroups = require(Parent.DiscoveryTypes).GameSortGroups
local FetchStatusRodux = require(Parent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local TopicContentsReducer = require(Parent.TopicContentsRodux).TopicContentsReducer
local LoggingProtocol = require(Parent.LoggingProtocol)
local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning
local getTopSearchResultsFetchName = require(Parent.DiscoveryUtils).getTopSearchResultsFetchName
local v18 = memoize(function(p1) -- line: 37
	local t1 = {}

	if p1 and p1.sorts then
		for i, v in ipairs(p1.sorts) do
			if v.topicId then
				t1[tostring(v.topicId)] = i
			end
		end
	end

	return t1
end)

local function useGameSortData(s1: string, s2: string, s3: string?) -- line: 52
	-- upvalues: useSelector (copy), TopicInfosReducer (copy), AppPage (copy), v18 (copy), GameSortGroups (copy), TopicContentsReducer (copy), TopicInfoModel (copy), RetrievalStatus (copy), getTopSearchResultsFetchName (copy), reportWarning (copy), LoggingProtocol (copy), FetchStatusNamespace (copy), FetchStatusReducer (copy), tutils (copy)
	return useSelector(function(p2) -- line: 53
		-- upvalues: TopicInfosReducer (copy), s1 (copy), s2 (copy), AppPage (copy), v18 (copy), GameSortGroups (copy), s3 (copy), TopicContentsReducer (copy), TopicInfoModel (copy), RetrievalStatus (copy), getTopSearchResultsFetchName (copy), reportWarning (copy), LoggingProtocol (copy), FetchStatusNamespace (copy), FetchStatusReducer (copy)
		local v28 = false
		local v29 = false
		local v30 = nil
		local v31 = nil
		local v32 = p2.Personalization[TopicInfosReducer.key][s1]

		if v32 ~= nil then
			if v32:isOmni() then
				if s2 == AppPage.Home then
					local v33 = p2.OmniRecommendations[s2]
					local v34 = v18(v33)[s1]

					if v34 then
						v28 = true
						v29 = true
						v30 = v34
					end
				end
			else
				v28 = true

				local Games = nil

				if s2 == AppPage.Games then
					Games = GameSortGroups.Games
				elseif s2 == AppPage.Home then
					Games = GameSortGroups.HomeGames
				end

				v31 = if not Games then nil else p2.GameSortGroups[Games].pageId
			end
		end

		local v36 = nil
		local v37 = nil
		local v38 = nil

		if s2 == AppPage.SearchPage then
			if s3 then
				v36 = p2.Personalization[TopicContentsReducer.key][s3]

				local v39 = TopicInfoModel.makeSearchTopicKey(s3, s1)

				v37 = p2.Personalization[TopicInfosReducer.key][v39]
				v28 = true

				local v40 = p2.RequestsStatus.SearchesInGamesStatus[s3]

				if v40 == "Removed" then
					v40 = RetrievalStatus.NotStarted
				end

				local v41 = p2.FetchingStatus[getTopSearchResultsFetchName("blended", s3)]

				v38 = v40 or v41
			else
				reportWarning(LoggingProtocol.default, "useGameSortData_MissingSearchUuid", "searchUuid is nil when pageContext is SearchPage")
				v28 = false
			end
		else
			v36 = p2.Personalization[TopicContentsReducer.key][s1]
			v37 = p2.Personalization[TopicInfosReducer.key][s1]

			local OmniRecommendations, v43

			if v29 then
				OmniRecommendations = FetchStatusNamespace.OmniRecommendations
				v43 = s2
			else
				OmniRecommendations = FetchStatusNamespace.GameSorts
				v43 = s1
			end

			v38 = p2.Personalization[FetchStatusReducer.key][OmniRecommendations][v43]
		end

		return {
			sortIndex = v30,
			isOmni = v29,
			gameSortDataFound = v28,
			gamesApiSortPageId = v31,
			sort = v37,
			gameSortContents = v36,
			gameSortFetchingStatus = v38 or RetrievalStatus.NotStarted
		}
	end, tutils.shallowEqual)
end

return useGameSortData
