local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactAnalytics = RoactServiceTags2.RoactAnalytics
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local DiscoveryTypes = require(parent.DiscoveryTypes)
local DiscoveryAvailability = require(parent.DiscoveryAvailability)
local GameSortLoadSource = DiscoveryAvailability.GameSortLoadSource
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning
local LoggingProtocol = require(parent.LoggingProtocol)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local DiscoveryUtils2 = require(parent.DiscoveryUtils)
local ApportioningDiagnosticTelemetry = DiscoveryUtils2.ApportioningDiagnosticTelemetry
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local SendGameImpressions = require(script.Parent.SendGameImpressions)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMApportioningExtraLogging = SharedFlags2.FFlagLuaAppEnableNxMApportioningExtraLogging

local function getGameSetTypeId(data, flag: boolean) -- 1 equivalent call inferred from this helper
	if data == nil then
		return nil
	end

	return if flag then data.topicId else data.gameSetTypeId
end

local function getGameSetTargetId(data, flag: boolean) -- 1 equivalent call inferred from this helper
	if flag or data == nil then
		return nil
	end

	return data.gameSetTargetId
end

local function getAppliedFilters(data, flag: boolean) -- 1 equivalent call inferred from this helper
	return if not (flag or not data) then data.appliedFilters else nil
end

local function useGameSortImpressionsParams(data, flag: boolean, p: number, pageContext: string, flag2: boolean?, p2: string?, p3: string?, gameSortId: string, object, p4: number?, p5: number?, list, p6)
	local v = useRoactService(AppEventIngestService)
	local v2 = useRoactService(RoactAnalytics)
	local v3

	if pageContext == AppPage.Home and data and data.topicId then
		v3 = GameSortLoadSource.getSortLoadSource(data.topicId)
	else
		v3 = nil
	end

	local sortSubId

	if data then
		sortSubId = data.sortSubId
	else
		sortSubId = nil
	end

	local analyticsData

	if data then
		analyticsData = data.analyticsData
	else
		analyticsData = nil
	end

	local v4 = React.useCallback(function(list2)
		if list == nil or #list == 0 then
			DiscoveryEventErrorLogger.reportError(
				"useGameSortImpressionsParams_MissingEntries",
				"useGameSortImpressionsParams: entries is nil or empty for game sort impressions",
				{ pageContext = pageContext, gameSortId = gameSortId }
			)

			return
		end

		if FFlagLuaAppEnableNxMApportioningExtraLogging then
			local firstIndex = nil
			local lastIndex = nil
			local count = 0
			local count2 = 0
			local count3 = 0

			for _, item in ipairs(list2) do
				if firstIndex == nil or item < firstIndex then
					firstIndex = item
				end

				if lastIndex == nil or lastIndex < item then
					lastIndex = item
				end

				local v4 = list and list[item]

				if v4 == nil then
					count3 += 1
				elseif v4.gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.Blank then
					count += 1
				else
					count2 += 1
				end
			end

			ApportioningDiagnosticTelemetry.log("ImpressionsBatchSent", {
				batchSize = #list2,
				realTileCount = count2,
				blankCount = count,
				missingCount = count3,
				firstIndex = firstIndex,
				lastIndex = lastIndex,
				entriesCount = #list,
				pageContext = pageContext,
				gameSortId = gameSortId,
				sortIndexOnPage = p,
				topicId = data and data.topicId,
				nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
			})
		end

		if pageContext == AppPage.SearchPage then
			if not p6 then
				reportWarning(
					LoggingProtocol.default,
					"useGameSortImpressionsParams_MissingSearchParams",
					"useGameSortImpressionsParams: searchParams is nil for search page game sort impressions"
				)
			end

			local v4 = {
				searchUuid = p6 and p6.searchUuid,
				emphasisFlag = p6 and p6.hasEmphasizedTile and 1 or 0,
				seeAllFlag = 1,
				sortPos = p,
				gameSetTypeId = data and data.topicId
			}

			SendGameImpressions.sendFromSearch(v, v2, list2, list, pageContext, v4, p4, p5, flag2, p2)
		else
			local gameSetTypeId = getGameSetTypeId(data, flag) -- inferred equivalent call
			local gameSetTargetId = getGameSetTargetId(data, flag) -- inferred equivalent call
			local appliedFilters = getAppliedFilters(data, flag) -- inferred equivalent call
			SendGameImpressions.sendFromTopicContents(
				v,
				v2,
				list2,
				list,
				pageContext,
				gameSetTypeId,
				p,
				p5,
				gameSetTargetId,
				p3,
				p4,
				flag2,
				p2,
				appliedFilters,
				v3,
				nil,
				sortSubId,
				analyticsData
			)
		end
	end, {
		v,
		v2,
		p,
		flag2,
		p2,
		flag,
		data,
		pageContext,
		p4,
		p5,
		p3,
		list,
		v3,
		sortSubId,
		analyticsData,
		p6,
		gameSortId
	})

	local ref = React.useRef(nil)

	if ref.current == nil then
		ref.current = Signal.new()
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

	return v4, current, (React.useCallback(function()
		current:fire()
	end, { current }))
end

return useGameSortImpressionsParams
