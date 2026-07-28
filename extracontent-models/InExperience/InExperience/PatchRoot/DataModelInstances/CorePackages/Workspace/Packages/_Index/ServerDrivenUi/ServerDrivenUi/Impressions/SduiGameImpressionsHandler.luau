local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local Cryo = require(Parent.Cryo)
local SendGameImpressions = require(Parent.GameCollections).SendGameImpressions
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local SduiParsers = SduiCoreSystem.SduiParsers
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(Parent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagSduiChartsSupport = require(Parent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiGameImpressionsDynamicFields = require(Parent.SharedFlags).FFlagSduiGameImpressionsDynamicFields
local FFlagSduiSearchResultsPageEnabled = require(Parent.SharedFlags).FFlagSduiSearchResultsPageEnabled
local t1 = {}
local u15 = nil

if FFlagSduiGameImpressionsDynamicFields then
	function u15(p1) -- line: 28
		if not p1 or type(p1) ~= "table" then
			return nil
		end

		local t2 = {}

		for v19, v20 in p1 do
			if type(v19) == "string" and (type(v20) == "string" or type(v20) == "number" or type(v20) == "boolean") then
				t2[v19] = tostring(v20)
			end
		end

		if not next(t2) then
			return nil
		end

		return t2
	end
end

local function SduiGameImpressionsHandler(p2, t3: {[any]: any}, t4: {[any]: any}, p3, n1: number?) -- line: 52
	-- upvalues: SduiErrors (copy), t1 (copy), Cryo (copy), FFlagSduiGameImpressionsDynamicFields (copy), u15 (ref), SduiParsers (copy), AppPage (copy), FFlagSduiSearchResultsPageEnabled (copy), SendGameImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiChartsSupport (copy), SduiParseHelpers (copy)
	if not p3 then
		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
			name = "SduiGameImpressionsHandler",
			message = "Missing collectionAnalyticsData"
		}, p2.appPage)

		return
	end

	local t5 = {}

	for _, v28 in t4 or t1 do
		table.insert(t5, (Cryo.Dictionary.join(v28, {
			analyticsData = if not FFlagSduiGameImpressionsDynamicFields then nil else u15(v28) or Cryo.None,
			isSponsored = SduiParsers.safeParseBoolean(v28.adFlag or false, p2, t1)
		})))
	end

	if #t3 == 0 or #t5 == 0 then
		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
			name = "SduiGameImpressionsHandler",
			message = `No entries to log: impressionIndexes={ #t3 }, gameImpressionEntries={ #t5 }`
		}, p2.appPage)

		return
	end

	local v29 = t5[t3[1]]
	local v30 = not v29 and "unknown" or v29.itemComponentType

	if p2.appPage == AppPage.SearchPage then
		local t6 = {
			searchUuid = p3.searchUuid,
			emphasisFlag = not FFlagSduiSearchResultsPageEnabled and 0 or (not p3.hasEmphasizedTile and 0 or 1),
			seeAllFlag = not FFlagSduiSearchResultsPageEnabled and 0 or (p3.seeAllFlag or 0),
			sortPos = p3.collectionPosition,
			gameSetTypeId = tostring(p3.collectionId)
		}

		SendGameImpressions.sendFromSearch(p2.dependencies.eventIngest, p2.dependencies.appAnalytics, t3, t5, p2.appPage, t6, p3.itemsPerRow, n1, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else p3.isWideTiles or false, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else v30)

		return
	end

	if FFlagSduiExperienceDetailsSupport and (p2.appPage == AppPage.ExperienceDetail or p2.appPage == AppPage.GameDetail) then
		local refId = p3.refId

		SendGameImpressions.sendFromGameDetails(p2.dependencies.eventIngest, p2.dependencies.appAnalytics, t3, t5, (tostring(refId)))

		return
	end

	if FFlagSduiChartsSupport and p3.seeAllFlag then
		SendGameImpressions.sendFromSeeAll(p2.dependencies.eventIngest, p2.dependencies.appAnalytics, t3, t5, p2.appPage, tostring(p3.collectionId), p3.gameSetTargetId, nil, p3.appliedFilters, p3.isWideTiles or false)

		return
	end

	SendGameImpressions.sendFromTopicContents(p2.dependencies.eventIngest, p2.dependencies.appAnalytics, t3, t5, p2.appPage, tostring(p3.collectionId), p3.collectionPosition, n1, if not FFlagSduiChartsSupport then nil else p3.gameSetTargetId, nil, p3.itemsPerRow, p3.isWideTiles or false, v30, if not FFlagSduiChartsSupport then nil else p3.appliedFilters, nil, function(s1: string) -- line: 154
		-- upvalues: SduiParseHelpers (copy), p3 (copy), p2 (copy), SduiErrors (copy), v30 (copy)
		local v34 = SduiParseHelpers.stringifyValue(p3)

		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
			name = "SduiGameImpressionsHandler",
			componentType = v30,
			message = `Failed to log game impressions. reason: { s1 }. analyticsContext: { v34 }`
		}, p2.appPage)
	end, nil, if not FFlagSduiGameImpressionsDynamicFields then nil else u15(p3))
end

return SduiGameImpressionsHandler
