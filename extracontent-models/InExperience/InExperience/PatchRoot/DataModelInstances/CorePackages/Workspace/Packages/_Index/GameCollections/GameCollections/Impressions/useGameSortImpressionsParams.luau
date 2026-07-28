local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppPage = require(Parent.RobloxAppEnums).AppPage
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local RoactAnalytics = require(Parent.RoactServiceTags).RoactAnalytics
local Signal = require(Parent.AppCommonLib).Signal
local DiscoveryTypes = require(Parent.DiscoveryTypes)
local GameSortLoadSource = require(Parent.DiscoveryAvailability).GameSortLoadSource
local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning
local LoggingProtocol = require(Parent.LoggingProtocol)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local ApportioningDiagnosticTelemetry = require(Parent.DiscoveryUtils).ApportioningDiagnosticTelemetry
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
local SendGameImpressions = require(script.Parent.SendGameImpressions)
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppFixSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppFixSearchImpressions
local FFlagLuaAppEnableNxMRoduxApportioning = require(Parent.SharedFlags).FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppEnableNxMApportioningExtraLogging = require(Parent.SharedFlags).FFlagLuaAppEnableNxMApportioningExtraLogging

local function getGameSetTypeId(p1, b1: boolean) -- line: 33
	if p1 ~= nil then
		if b1 then
			return p1.topicId
		end

		return p1.gameSetTypeId
	end

	return nil
end
local function getGameSetTargetId(p2, b2: boolean) -- line: 45
	if not b2 and p2 ~= nil then
		return p2.gameSetTargetId
	end

	return nil
end
local function getAppliedFilters(p3, b3: boolean) -- line: 55
	if not b3 and p3 then
		return p3.appliedFilters
	end

	return nil
end
local function useGameSortImpressionsParams(p4, b4: boolean, n1: number, s1: string, b5: boolean?, s2: string?, s3: string?, s4: string, p5, n2: number?, n3: number?, t1: {[any]: any}?, p6) -- line: 71
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), AppPage (copy), GameSortLoadSource (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), React (copy), DiscoveryEventErrorLogger (copy), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), GameCollectionItemTypes (copy), ApportioningDiagnosticTelemetry (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), reportWarning (copy), LoggingProtocol (copy), SendGameImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), FFlagLuaAppFixSearchImpressions (copy), Signal (copy)
	local v44 = useRoactService(AppEventIngestService)
	local v45 = useRoactService(RoactAnalytics)
	local v46 = if s1 ~= AppPage.Home or (not p4 or not p4.topicId) then nil else GameSortLoadSource.getSortLoadSource(p4.topicId)
	local v47 = if not FFlagLuaAppAddSubIdToHomeEvents or not p4 then nil else p4.sortSubId
	local v48 = if not p4 then nil else p4.analyticsData
	local v49 = React.useCallback(function(p7) -- line: 99
		-- upvalues: t1 (copy), DiscoveryEventErrorLogger (copy), s1 (copy), s4 (copy), FFlagLuaAppEnableNxMApportioningExtraLogging (copy), GameCollectionItemTypes (copy), ApportioningDiagnosticTelemetry (copy), n1 (copy), p4 (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), AppPage (copy), p6 (copy), reportWarning (copy), LoggingProtocol (copy), SendGameImpressions (copy), v44 (copy), v45 (copy), n2 (copy), n3 (copy), b5 (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), s2 (copy), b4 (copy), s3 (copy), v46 (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), v47 (copy), v48 (copy)
		if t1 == nil or #t1 == 0 then
			DiscoveryEventErrorLogger.reportError("useGameSortImpressionsParams_MissingEntries", "useGameSortImpressionsParams: entries is nil or empty for game sort impressions", {
				pageContext = s1,
				gameSortId = s4
			})

			return
		end

		if FFlagLuaAppEnableNxMApportioningExtraLogging then
			local n4 = 0
			local n5 = 0
			local n6 = 0
			local v56 = nil
			local v57 = nil

			for _, v in ipairs(p7) do
				if v56 == nil or v < v56 then
					v56 = v
				end

				if v57 == nil or v57 < v then
					v57 = v
				end

				local v60 = t1 and t1[v]

				if v60 == nil then
					n6 += 1
				elseif v60.gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.Blank then
					n4 += 1
				else
					n5 += 1
				end
			end

			ApportioningDiagnosticTelemetry.log("ImpressionsBatchSent", {
				batchSize = #p7,
				realTileCount = n5,
				blankCount = n4,
				missingCount = n6,
				firstIndex = v56,
				lastIndex = v57,
				entriesCount = #t1,
				pageContext = s1,
				gameSortId = s4,
				sortIndexOnPage = n1,
				topicId = p4 and p4.topicId,
				nxmApportioningFlagValue = FFlagLuaAppEnableNxMRoduxApportioning
			})
		end

		if s1 == AppPage.SearchPage then
			if not p6 then
				reportWarning(LoggingProtocol.default, "useGameSortImpressionsParams_MissingSearchParams", "useGameSortImpressionsParams: searchParams is nil for search page game sort impressions")
			end

			local t2 = {
				seeAllFlag = 1,
				searchUuid = p6 and p6.searchUuid,
				emphasisFlag = (not p6 or not p6.hasEmphasizedTile) and 0 or 1,
				sortPos = n1,
				gameSetTypeId = p4 and p4.topicId
			}

			SendGameImpressions.sendFromSearch(v44, v45, p7, t1, s1, t2, n2, n3, b5, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else s2)

			return
		end

		local v62 = p4
		local v63 = b4
		local v64 = if v62 == nil then nil else if not v63 then v62.gameSetTypeId else v62.topicId
		local v65 = p4
		local v66 = if b4 or v65 == nil then nil else v65.gameSetTargetId
		local v67 = p4
		local v68 = if b4 or not v67 then nil else v67.appliedFilters

		SendGameImpressions.sendFromTopicContents(v44, v45, p7, t1, s1, v64, n1, n3, v66, s3, n2, b5, s2, v68, v46, nil, if not FFlagLuaAppAddSubIdToHomeEvents then nil else v47, v48)
	end, {
		v44,
		v45,
		n1,
		b5,
		s2,
		b4,
		p4,
		s1,
		n2,
		n3,
		s3,
		t1,
		v46,
		if not FFlagLuaAppAddSubIdToHomeEvents then nil else v47,
		v48,
		if not FFlagLuaAppFixSearchImpressions then nil else p6,
		if not FFlagLuaAppFixSearchImpressions then nil else s4
	})
	local v50 = React.useRef(nil)

	if v50.current == nil then
		v50.current = Signal.new()
	end

	local current = v50.current

	React.useEffect(function() -- line: 235
		-- upvalues: current (copy), p5 (copy)
		current:fire()

		local u69 = nil

		if p5 then
			u69 = p5:connect(function() -- line: 244
				-- upvalues: current (copy)
				current:fire()
			end)
		end

		return function() -- line: 249
			-- upvalues: u69 (ref)
			if u69 then
				u69:disconnect()
			end
		end
	end, {
		p5,
		current
	})

	return v49, current, (React.useCallback(function() -- line: 256
		-- upvalues: current (copy)
		current:fire()
	end, { current }))
end

return useGameSortImpressionsParams
