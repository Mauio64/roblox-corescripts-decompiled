local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Http").Enum.RetrievalStatus
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/tutils")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactUtils").Hooks.RoactRodux.useSelector
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/AppCommonLib").memoize
local TopicInfosRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/TopicInfosRodux")
local topicInfosReducer = TopicInfosRodux.TopicInfosReducer
local topicInfoModel = TopicInfosRodux.TopicInfoModel
local gameSortGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameSortGroups
local FetchStatusRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/FetchStatusRodux")
local fetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local fetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local topicContentsReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/TopicContentsRodux").TopicContentsReducer
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/LoggingProtocol")
local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAnalytics").Points.reportWarning
local getTopSearchResultsFetchName = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").getTopSearchResultsFetchName

local v5 = memoize(function(p2)
	local result = {}

	if p2 and p2.sorts then
		for i, sort in ipairs(p2.sorts) do
			if sort.topicId then
				result[tostring(sort.topicId)] = i
			end
		end
	end

	return result
end)

local function useGameSortData(p2, p3, p4)
	return useSelector(function(data)
		local v6 = false
		local flag = false
		local v7 = nil
		local pageId = nil
		local v8 = data.Personalization[topicInfosReducer.key][p2]

		if v8 ~= nil then
			if v8:isOmni() then
				if p3 == appPage.Home then
					local v9 = v5(data.OmniRecommendations[p3])[p2]

					if v9 then
						v7 = v9
						flag = true
						v6 = true
					end
				end
			else
				v6 = true

				local v9 = nil

				if p3 == appPage.Games then
					v9 = gameSortGroups.Games
				elseif p3 == appPage.Home then
					v9 = gameSortGroups.HomeGames
				end

				if v9 then
					pageId = data.GameSortGroups[v9].pageId
				end
			end
		end

		local v9 = nil
		local v10 = nil
		local v11 = nil

		if p3 == appPage.SearchPage then
			if p4 then
				v9 = data.Personalization[topicContentsReducer.key][p4]
				local searchTopicKey = topicInfoModel.makeSearchTopicKey(p4, p2)
				v10 = data.Personalization[topicInfosReducer.key][searchTopicKey]

				v6 = true

				local v12 = data.RequestsStatus.SearchesInGamesStatus[p4]

				if v12 == "Removed" then
					v12 = retrievalStatus.NotStarted
				end

				local v13 = data.FetchingStatus[getTopSearchResultsFetchName("blended", p4)]
				v11 = v12 or v13
			else
				reportWarning(
					LoggingProtocol.default,
					"useGameSortData_MissingSearchUuid",
					"searchUuid is nil when pageContext is SearchPage"
				)
				v6 = false
			end
		else
			v9 = data.Personalization[topicContentsReducer.key][p2]
			v10 = data.Personalization[topicInfosReducer.key][p2]
			local v12, v13

			if flag then
				v12 = fetchStatusNamespace.OmniRecommendations
				v13 = p3
			else
				v12 = fetchStatusNamespace.GameSorts
				v13 = p2
			end

			v11 = data.Personalization[fetchStatusReducer.key][v12][v13]
		end

		return {
			sortIndex = v7,
			isOmni = flag,
			gameSortDataFound = v6,
			gamesApiSortPageId = pageId,
			sort = v10,
			gameSortContents = v9,
			gameSortFetchingStatus = v11 or retrievalStatus.NotStarted
		}
	end, tutils.shallowEqual)
end

return useGameSortData
