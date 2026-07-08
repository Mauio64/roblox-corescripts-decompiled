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
local t1 = {}
local u14 = nil

if FFlagSduiGameImpressionsDynamicFields then
	function u14(p1) -- line: 27
		if not p1 or type(p1) ~= "table" then
			return nil
		end

		local t2 = {}

		for v18, v19 in p1 do
			if type(v18) == "string" and (type(v19) == "string" or type(v19) == "number" or type(v19) == "boolean") then
				t2[v18] = tostring(v19)
			end
		end

		if not next(t2) then
			return nil
		end

		return t2
	end
end

local function SduiGameImpressionsHandler(p2, t3: {[any]: any}, t4: {[any]: any}, p3, n1: number?) -- line: 51
	-- upvalues: SduiErrors (copy), t1 (copy), Cryo (copy), FFlagSduiGameImpressionsDynamicFields (copy), u14 (ref), SduiParsers (copy), AppPage (copy), SendGameImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiChartsSupport (copy), SduiParseHelpers (copy)
	if not p3 then
		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
			name = "SduiGameImpressionsHandler",
			message = "Missing collectionAnalyticsData"
		}, p2.appPage)

		return
	end

	local t5 = {}

	for _, v27 in t4 or t1 do
		table.insert(t5, (Cryo.Dictionary.join(v27, {
			analyticsData = if not FFlagSduiGameImpressionsDynamicFields then nil else u14(v27) or Cryo.None,
			isSponsored = SduiParsers.safeParseBoolean(v27.adFlag or false, p2, t1)
		})))
	end

	if #t3 == 0 or #t5 == 0 then
		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
			name = "SduiGameImpressionsHandler",
			message = `No entries to log: impressionIndexes={ #t3 }, gameImpressionEntries={ #t5 }`
		}, p2.appPage)

		return
	end

	local v28 = t5[t3[1]]
	local v29 = not v28 and "unknown" or v28.itemComponentType

	if p2.appPage == AppPage.SearchPage then
		local t6 = {
			emphasisFlag = 0,
			seeAllFlag = 0,
			searchUuid = p3.searchUuid,
			sortPos = p3.collectionPosition,
			gameSetTypeId = tostring(p3.collectionId)
		}

		SendGameImpressions.sendFromSearch(p2.dependencies.eventIngest, p2.dependencies.appAnalytics, t3, t5, p2.appPage, t6, p3.itemsPerRow, n1, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else p3.isWideTiles or false, if not FFlagLuaAppAddComponentTypeToSearchImpressions then nil else v29)

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

	SendGameImpressions.sendFromTopicContents(p2.dependencies.eventIngest, p2.dependencies.appAnalytics, t3, t5, p2.appPage, tostring(p3.collectionId), p3.collectionPosition, n1, if not FFlagSduiChartsSupport then nil else p3.gameSetTargetId, nil, p3.itemsPerRow, p3.isWideTiles or false, v29, if not FFlagSduiChartsSupport then nil else p3.appliedFilters, nil, function(s1: string) -- line: 151
		-- upvalues: SduiParseHelpers (copy), p3 (copy), p2 (copy), SduiErrors (copy), v29 (copy)
		local v33 = SduiParseHelpers.stringifyValue(p3)

		p2.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
			name = "SduiGameImpressionsHandler",
			componentType = v29,
			message = `Failed to log game impressions. reason: { s1 }. analyticsContext: { v33 }`
		}, p2.appPage)
	end, nil, if not FFlagSduiGameImpressionsDynamicFields then nil else u14(p3))
end

return SduiGameImpressionsHandler
