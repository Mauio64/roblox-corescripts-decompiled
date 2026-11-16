local parent = script:FindFirstAncestor("GameCollections").Parent
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local tutils = require(parent.tutils)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize
local TopicInfosRodux = require(parent.TopicInfosRodux)
local TopicInfosReducer = TopicInfosRodux.TopicInfosReducer
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameSortGroups = DiscoveryTypes.GameSortGroups
local FetchStatusRodux = require(parent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local TopicContentsRodux = require(parent.TopicContentsRodux)
local TopicContentsReducer = TopicContentsRodux.TopicContentsReducer
local LoggingProtocol = require(parent.LoggingProtocol)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning
local DiscoveryUtils = require(parent.DiscoveryUtils)
local getTopSearchResultsFetchName = DiscoveryUtils.getTopSearchResultsFetchName

local v = memoize(function(p)
	local result = {}

	if p and p.sorts then
		for i, sort in ipairs(p.sorts) do
			if sort.topicId then
				result[tostring(sort.topicId)] = i
			end
		end
	end

	return result
end)

local function useGameSortData(p: string, p2: string, p3: string?)
	return useSelector(function(data)
		local gameSortDataFound = false
		local flag = false
		local sortIndex = nil
		local pageId = nil
		local v2 = data.Personalization[TopicInfosReducer.key][p]

		if v2 ~= nil then
			if v2:isOmni() then
				if p2 == AppPage.Home then
					local v3 = v(data.OmniRecommendations[p2])[p]

					if v3 then
						sortIndex = v3
						flag = true
						gameSortDataFound = true
					end
				end
			else
				gameSortDataFound = true

				local v3 = nil

				if p2 == AppPage.Games then
					v3 = GameSortGroups.Games
				elseif p2 == AppPage.Home then
					v3 = GameSortGroups.HomeGames
				end

				if v3 then
					pageId = data.GameSortGroups[v3].pageId
				end
			end
		end

		local gameSortContents = nil
		local sort = nil
		local v3 = nil

		if p2 == AppPage.SearchPage then
			if p3 then
				gameSortContents = data.Personalization[TopicContentsReducer.key][p3]
				local searchTopicKey = TopicInfoModel.makeSearchTopicKey(p3, p)
				sort = data.Personalization[TopicInfosReducer.key][searchTopicKey]

				gameSortDataFound = true

				local v4 = data.RequestsStatus.SearchesInGamesStatus[p3]

				if v4 == "Removed" then
					v4 = RetrievalStatus.NotStarted
				end

				local v5 = data.FetchingStatus[getTopSearchResultsFetchName("blended", p3)]
				v3 = v4 or v5
			else
				reportWarning(
					LoggingProtocol.default,
					"useGameSortData_MissingSearchUuid",
					"searchUuid is nil when pageContext is SearchPage"
				)
				gameSortDataFound = false
			end
		else
			gameSortContents = data.Personalization[TopicContentsReducer.key][p]
			sort = data.Personalization[TopicInfosReducer.key][p]
			local v4, v5

			if flag then
				v4 = FetchStatusNamespace.OmniRecommendations
				v5 = p2
			else
				v4 = FetchStatusNamespace.GameSorts
				v5 = p
			end

			v3 = data.Personalization[FetchStatusReducer.key][v4][v5]
		end

		return {
			sortIndex = sortIndex,
			isOmni = flag,
			gameSortDataFound = gameSortDataFound,
			gamesApiSortPageId = pageId,
			sort = sort,
			gameSortContents = gameSortContents,
			gameSortFetchingStatus = v3 or RetrievalStatus.NotStarted
		}
	end, tutils.shallowEqual)
end

return useGameSortData
