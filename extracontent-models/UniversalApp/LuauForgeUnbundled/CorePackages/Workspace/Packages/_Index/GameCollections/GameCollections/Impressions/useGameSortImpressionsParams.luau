local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppHooks").useRoactService
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactServiceTags").AppEventIngestService
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactServiceTags").RoactAnalytics
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/AppCommonLib").Signal
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")
local gameSortLoadSource = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAvailability").GameSortLoadSource
local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAnalytics").Points.reportWarning
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/LoggingProtocol")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").DiscoveryEventErrorLogger
local apportioningDiagnosticTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").ApportioningDiagnosticTelemetry
local gameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local SendGameImpressions = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/SendGameImpressions")
local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppEnableNxMApportioningExtraLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableNxMApportioningExtraLogging

local function getGameSetTypeId(p2, p3)
	if p2 == nil then
		return nil
	end

	if p3 then
		return p2.topicId
	end

	return p2.gameSetTypeId
end

local function getGameSetTargetId(p2, p3)
	if p3 or p2 == nil then
		return nil
	end

	return p2.gameSetTargetId
end

local function getAppliedFilters(p2, p3)
	if p3 or not p2 then
		return nil
	end

	return p2.appliedFilters
end

local function useGameSortImpressionsParams(data, p2, p3, p4, p5, p6, p7, p8, object, p9, p10, list, p11)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useRoactService(roactAnalytics)
	local v7

	if p4 == appPage.Home and data and data.topicId then
		v7 = gameSortLoadSource.getSortLoadSource(data.topicId)
	else
		v7 = nil
	end

	local sortSubId = if data then data.sortSubId else nil
	local analyticsData = if data then data.analyticsData else nil

	local v8 = React.useCallback(function(list2)
		if list == nil or #list == 0 then
			discoveryEventErrorLogger.reportError(
				"useGameSortImpressionsParams_MissingEntries",
				"useGameSortImpressionsParams: entries is nil or empty for game sort impressions",
				{ pageContext = p4, gameSortId = p8 }
			)

			return
		end

		if fFlagLuaAppEnableNxMApportioningExtraLogging then
			local v9 = nil
			local v10 = nil
			local count = 0
			local count2 = 0
			local count3 = 0

			for i, item in ipairs(list2) do
				if v9 == nil or item < v9 then
					v9 = item
				end

				if v10 == nil or v10 < item then
					v10 = item
				end

				local v11 = list and list[item]

				if v11 == nil then
					count3 += 1
				elseif v11.gameCollectionItemTypeOverride == gameCollectionItemTypes.GameCollectionItemType.Blank then
					count += 1
				else
					count2 += 1
				end
			end

			apportioningDiagnosticTelemetry.log("ImpressionsBatchSent", {
				batchSize = #list2,
				realTileCount = count2,
				blankCount = count,
				missingCount = count3,
				firstIndex = v9,
				lastIndex = v10,
				entriesCount = #list,
				pageContext = p4,
				gameSortId = p8,
				sortIndexOnPage = p3,
				topicId = data and data.topicId,
				nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
			})
		end

		if p4 == appPage.SearchPage then
			if not p11 then
				reportWarning(
					LoggingProtocol.default,
					"useGameSortImpressionsParams_MissingSearchParams",
					"useGameSortImpressionsParams: searchParams is nil for search page game sort impressions"
				)
			end

			local v9 = {
				searchUuid = p11 and p11.searchUuid,
				emphasisFlag = p11 and p11.hasEmphasizedTile and 1 or 0,
				seeAllFlag = 1,
				sortPos = p3,
				gameSetTypeId = data and data.topicId
			}

			SendGameImpressions.sendFromSearch(v5, v6, list2, list, p4, v9, p9, p10, p5, p6)
		else
			local v9 = data
			local v10 = p2
			local v11 = if v9 ~= nil then (if v10 then v9.topicId else v9.gameSetTypeId) else nil

			local v12 = data
			local gameSetTargetId = if not (p2 or v12 == nil) then v12.gameSetTargetId else nil

			local v14 = if not (p2 or not data) then data.appliedFilters else nil

			SendGameImpressions.sendFromTopicContents(
				v5,
				v6,
				list2,
				list,
				p4,
				v11,
				p3,
				p10,
				gameSetTargetId,
				p7,
				p9,
				p5,
				p6,
				v14,
				v7,
				nil,
				sortSubId,
				analyticsData
			)
		end
	end, {
		v5,
		v6,
		p3,
		p5,
		p6,
		p2,
		data,
		p4,
		p9,
		p10,
		p7,
		list,
		v7,
		sortSubId,
		analyticsData,
		p11,
		p8
	})

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = signal.new()
	end

	local current = ref.current

	React.useEffect(function()
		current:fire()
		local connection

		if object then
			connection = object:connect(function()
				current:fire()
			end)
		else
			connection = nil
		end

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, { object, current })

	return v8, current, (React.useCallback(function()
		current:fire()
	end, { current }))
end

return useGameSortImpressionsParams
