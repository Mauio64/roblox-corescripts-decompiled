local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppPage = require(Parent.RobloxAppEnums).AppPage
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local RoactAnalytics = require(Parent.RoactServiceTags).RoactAnalytics
local Signal = require(Parent.AppCommonLib).Signal

require(Parent.DiscoveryTypes)

local GameSortLoadSource = require(Parent.DiscoveryAvailability).GameSortLoadSource
local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning
local LoggingProtocol = require(Parent.LoggingProtocol)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local SendGameImpressions = require(script.Parent.SendGameImpressions)
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagLuaAppAddSubIdToHomeEvents = require(Parent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppFixSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppFixSearchImpressions

local function getGameSetTypeId(p1, b1: boolean) -- line: 28
	if p1 ~= nil then
		if b1 then
			return p1.topicId
		end

		return p1.gameSetTypeId
	end

	return nil
end
local function getGameSetTargetId(p2, b2: boolean) -- line: 40
	if not b2 and p2 ~= nil then
		return p2.gameSetTargetId
	end

	return nil
end
local function getAppliedFilters(p3, b3: boolean) -- line: 50
	if not b3 and p3 then
		return p3.appliedFilters
	end

	return nil
end
local function useGameSortImpressionsParams(p4, b4: boolean, n1: number, s1: string, b5: boolean?, s2: string?, s3: string?, s4: string, p5, n2: number?, n3: number?, t1: {[any]: any}?, p6) -- line: 66
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), AppPage (copy), GameSortLoadSource (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), React (copy), DiscoveryEventErrorLogger (copy), reportWarning (copy), LoggingProtocol (copy), SendGameImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), FFlagLuaAppFixSearchImpressions (copy), Signal (copy)
	local v39 = useRoactService(AppEventIngestService)
	local v40 = useRoactService(RoactAnalytics)
	local v41 = if s1 ~= AppPage.Home or (not p4 or not p4.topicId) then nil else GameSortLoadSource.getSortLoadSource(p4.topicId)
	local v42 = if not FFlagLuaAppAddSubIdToHomeEvents or not p4 then nil else p4.sortSubId
	local v43 = if not p4 then nil else p4.analyticsData
	local v44 = React.useCallback(function(p7) -- line: 94
		-- upvalues: t1 (copy), DiscoveryEventErrorLogger (copy), s1 (copy), s4 (copy), AppPage (copy), p6 (copy), reportWarning (copy), LoggingProtocol (copy), n1 (copy), p4 (copy), SendGameImpressions (copy), v39 (copy), v40 (copy), n2 (copy), n3 (copy), b5 (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), s2 (copy), b4 (copy), s3 (copy), v41 (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), v42 (copy), v43 (copy)
		if t1 == nil or #t1 == 0 then
			DiscoveryEventErrorLogger.reportError("useGameSortImpressionsParams_MissingEntries", "useGameSortImpressionsParams: entries is nil or empty for game sort impressions", {
				pageContext = s1,
				gameSortId = s4
			})

			return
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

			SendGameImpressions.sendFromSearch(v39, v40, p7, t1, s1, t2, n2, n3, b5, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else s2)

			return
		end

		local v49 = p4
		local v50 = b4
		local v51 = if v49 == nil then nil else if not v50 then v49.gameSetTypeId else v49.topicId
		local v52 = p4
		local v53 = if b4 or v52 == nil then nil else v52.gameSetTargetId
		local v54 = p4
		local v55 = if b4 or not v54 then nil else v54.appliedFilters

		SendGameImpressions.sendFromTopicContents(v39, v40, p7, t1, s1, v51, n1, n3, v53, s3, n2, b5, s2, v55, v41, nil, if not FFlagLuaAppAddSubIdToHomeEvents then nil else v42, v43)
	end, {
		v39,
		v40,
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
		v41,
		if not FFlagLuaAppAddSubIdToHomeEvents then nil else v42,
		v43,
		if not FFlagLuaAppFixSearchImpressions then nil else p6,
		if not FFlagLuaAppFixSearchImpressions then nil else s4
	})
	local v45 = React.useRef(nil)

	if v45.current == nil then
		v45.current = Signal.new()
	end

	local current = v45.current

	React.useEffect(function() -- line: 190
		-- upvalues: current (copy), p5 (copy)
		current:fire()

		local u56 = nil

		if p5 then
			u56 = p5:connect(function() -- line: 199
				-- upvalues: current (copy)
				current:fire()
			end)
		end

		return function() -- line: 204
			-- upvalues: u56 (ref)
			if u56 then
				u56:disconnect()
			end
		end
	end, {
		p5,
		current
	})

	return v44, current, (React.useCallback(function() -- line: 211
		-- upvalues: current (copy)
		current:fire()
	end, { current }))
end

return useGameSortImpressionsParams
