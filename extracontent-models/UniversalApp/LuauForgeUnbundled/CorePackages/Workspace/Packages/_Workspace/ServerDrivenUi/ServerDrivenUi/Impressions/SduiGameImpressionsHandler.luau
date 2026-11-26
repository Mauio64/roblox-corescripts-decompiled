local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local sendGameImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").SendGameImpressions
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local sduiParsers = SduiCoreSystem.SduiParsers
local fFlagSduiSearchResultsPageEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiSearchResultsPageEnabled
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiFixSearchTelemetry
local fFlagLuaAppSponsoredGamePreviewVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSponsoredGamePreviewVideo
local fFlagLuaAppSduiPassSortSubId = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiPassSortSubId

local v5 = {}
local fn = not require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiForwardAnalyticsDataToGameClick and function(items)
	if not items or type(items) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in items do
		if type(k) ~= "string" then
			continue
		end

		if not (type(item) == "string" or type(item) == "number" or type(item) == "boolean") then
			continue
		end

		result[k] = tostring(item)
	end

	if next(result) then
		return result
	end

	return nil
end or require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/filterAndStringifyAnalyticsData")

local function SduiGameImpressionsHandler(p2, list, p3, data, p4)
	if not data then
		p2.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.FailedToLogGameImpressions,
			{
				name = "SduiGameImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	local v6 = fFlagSduiFixSearchTelemetry and 0 or nil
	local v7 = {}

	for k, v8 in p3 or v5 do
		local join = Cryo.Dictionary.join
		local v9 = {
			analyticsData = fn(v8) or Cryo.None,
			isSponsored = sduiParsers.safeParseBoolean(v8.adFlag or false, p2, v5),
			gameCollectionItemTypeOverride = 0,
			sponsoredGamePreviewVideoEligible = 0
		}
		local v10 = if fFlagSduiFixSearchTelemetry then v8.tileType else nil
		v9.gameCollectionItemTypeOverride = v10

		local v11 = if fFlagLuaAppSponsoredGamePreviewVideo then sduiParsers.safeParseBoolean(
			v8.sponsoredGamePreviewVideoEligible or false,
			p2,
			v5
		) else nil
		v9.sponsoredGamePreviewVideoEligible = v11
		local v12 = join(v8, v9)

		if fFlagSduiFixSearchTelemetry then
			v7[k] = v12
			v6 += 1
		else
			table.insert(v7, v12)
		end
	end

	if #list ~= 0 then
		local v8 = if fFlagSduiFixSearchTelemetry then v6 == 0 else #v7 == 0

		if not v8 then
			local v9 = v7[list[1]]
			local v10 = not v9 and "unknown" or v9.itemComponentType

			if p2.appPage == appPage.SearchPage then
				local v11 = {
					searchUuid = data.searchUuid,
					emphasisFlag = fFlagSduiSearchResultsPageEnabled and data.hasEmphasizedTile and 1 or 0,
					seeAllFlag = fFlagSduiSearchResultsPageEnabled and tonumber(data.seeAllFlag) or 0,
					sortPos = data.collectionPosition,
					gameSetTypeId = tostring(data.collectionId)
				}

				sendGameImpressions.sendFromSearch(
					p2.dependencies.eventIngest,
					p2.dependencies.appAnalytics,
					list,
					v7,
					p2.appPage,
					v11,
					data.itemsPerRow,
					p4,
					data.isWideTiles or false,
					v10
				)
				return
			elseif p2.appPage == appPage.ExperienceDetail or p2.appPage == appPage.GameDetail then
				local refId = data.refId
				sendGameImpressions.sendFromGameDetails(
					p2.dependencies.eventIngest,
					p2.dependencies.appAnalytics,
					list,
					v7,
					(tostring(refId))
				)
				return
			else
				if data.seeAllFlag then
					sendGameImpressions.sendFromSeeAll(
						p2.dependencies.eventIngest,
						p2.dependencies.appAnalytics,
						list,
						v7,
						p2.appPage,
						tostring(data.collectionId),
						data.gameSetTargetId,
						nil,
						data.appliedFilters,
						data.isWideTiles or false
					)
					return
				end

				local sendFromTopicContents = sendGameImpressions.sendFromTopicContents
				local eventIngest = p2.dependencies.eventIngest
				local appAnalytics = p2.dependencies.appAnalytics

				local appPage2 = p2.appPage
				local collectionId = tostring(data.collectionId)
				local collectionPosition = data.collectionPosition

				local gameSetTargetId = data.gameSetTargetId

				local itemsPerRow = data.itemsPerRow
				local isWideTiles = data.isWideTiles or false

				local appliedFilters = data.appliedFilters

				local function fn2(p5)
					local stringifyValue = sduiParseHelpers.stringifyValue(data)

					p2.dependencies.logger.reportError(
						sduiErrors.SduiErrorType.FailedToLogGameImpressions,
						{
							componentType = v10,
							name = "SduiGameImpressionsHandler",
							message = `Failed to log game impressions. reason: {p5}. analyticsContext: {stringifyValue}`
						},
						p2.appPage
					)
				end
				local v13 = if fFlagLuaAppSduiPassSortSubId and data.sortSubId then tostring(data.sortSubId) else nil
				sendFromTopicContents(
					eventIngest,
					appAnalytics,
					list,
					v7,
					appPage2,
					collectionId,
					collectionPosition,
					p4,
					gameSetTargetId,
					nil,
					itemsPerRow,
					isWideTiles,
					v10,
					appliedFilters,
					nil,
					fn2,
					v13,
					fn(data)
				)

				return
			end
		end
	end

	p2.dependencies.logger.reportError(sduiErrors.SduiErrorType.FailedToLogGameImpressions, {
		name = "SduiGameImpressionsHandler",
		message = `No entries to log: impressionIndexes={#list}, gameImpressionEntries={not fFlagSduiFixSearchTelemetry and #v7 or v6}`
	}, p2.appPage)
end

return SduiGameImpressionsHandler
