local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local Cryo = require(parent.Cryo)
local GameCollections = require(parent.GameCollections)
local SendGameImpressions = GameCollections.SendGameImpressions
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local SduiParsers = SduiCoreSystem.SduiParsers
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSearchResultsPageEnabled = SharedFlags.FFlagSduiSearchResultsPageEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiFixSearchTelemetry = SharedFlags2.FFlagSduiFixSearchTelemetry
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSponsoredGamePreviewVideo = SharedFlags3.FFlagLuaAppSponsoredGamePreviewVideo
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiPassSortSubId = SharedFlags4.FFlagLuaAppSduiPassSortSubId
local SharedFlags5 = require(parent.SharedFlags)

local v = {}
local fn = not SharedFlags5.FFlagSduiForwardAnalyticsDataToGameClick and function(items)
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

	return if next(result) then result else nil
end or require(ServerDrivenUi.Analytics.filterAndStringifyAnalyticsData)

local function SduiGameImpressionsHandler(p, list, p2, data, p3: number?)
	if not data then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.FailedToLogGameImpressions,
			{ name = "SduiGameImpressionsHandler", message = "Missing collectionAnalyticsData" },
			p.appPage
		)
		return
	end

	local v2 = FFlagSduiFixSearchTelemetry and 0 or nil
	local v3 = {}

	for k, v4 in p2 or v do
		local join = Cryo.Dictionary.join
		local v5 = {
			analyticsData = fn(v4) or Cryo.None,
			isSponsored = SduiParsers.safeParseBoolean(v4.adFlag or false, p, v),
			gameCollectionItemTypeOverride = 0,
			sponsoredGamePreviewVideoEligible = 0
		}
		local gameCollectionItemTypeOverride

		if FFlagSduiFixSearchTelemetry then
			gameCollectionItemTypeOverride = v4.tileType
		end

		v5.gameCollectionItemTypeOverride = gameCollectionItemTypeOverride
		local sponsoredGamePreviewVideoEligible

		if FFlagLuaAppSponsoredGamePreviewVideo then
			sponsoredGamePreviewVideoEligible = SduiParsers.safeParseBoolean(
				v4.sponsoredGamePreviewVideoEligible or false,
				p,
				v
			)
		end

		v5.sponsoredGamePreviewVideoEligible = sponsoredGamePreviewVideoEligible
		local v6 = join(v4, v5)

		if FFlagSduiFixSearchTelemetry then
			v3[k] = v6
			v2 += 1
		else
			table.insert(v3, v6)
		end
	end

	if #list ~= 0 then
		local v4

		if FFlagSduiFixSearchTelemetry then
			v4 = v2 == 0
		else
			v4 = #v3 == 0
		end

		if not v4 then
			local v5 = v3[list[1]]
			local componentType = not v5 and "unknown" or v5.itemComponentType

			if p.appPage == AppPage.SearchPage then
				local v6 = {
					searchUuid = data.searchUuid,
					emphasisFlag = FFlagSduiSearchResultsPageEnabled and data.hasEmphasizedTile and 1 or 0,
					seeAllFlag = FFlagSduiSearchResultsPageEnabled and tonumber(data.seeAllFlag) or 0,
					sortPos = data.collectionPosition,
					gameSetTypeId = tostring(data.collectionId)
				}

				SendGameImpressions.sendFromSearch(
					p.dependencies.eventIngest,
					p.dependencies.appAnalytics,
					list,
					v3,
					p.appPage,
					v6,
					data.itemsPerRow,
					p3,
					data.isWideTiles or false,
					componentType
				)
				return
			elseif p.appPage == AppPage.ExperienceDetail or p.appPage == AppPage.GameDetail then
				local refId = data.refId
				SendGameImpressions.sendFromGameDetails(
					p.dependencies.eventIngest,
					p.dependencies.appAnalytics,
					list,
					v3,
					(tostring(refId))
				)
				return
			else
				if data.seeAllFlag then
					SendGameImpressions.sendFromSeeAll(
						p.dependencies.eventIngest,
						p.dependencies.appAnalytics,
						list,
						v3,
						p.appPage,
						tostring(data.collectionId),
						data.gameSetTargetId,
						nil,
						data.appliedFilters,
						data.isWideTiles or false
					)
					return
				end

				local sendFromTopicContents = SendGameImpressions.sendFromTopicContents
				local eventIngest = p.dependencies.eventIngest
				local appAnalytics = p.dependencies.appAnalytics

				local appPage = p.appPage
				local collectionId = tostring(data.collectionId)
				local collectionPosition = data.collectionPosition

				local gameSetTargetId = data.gameSetTargetId

				local itemsPerRow = data.itemsPerRow
				local isWideTiles = data.isWideTiles or false

				local appliedFilters = data.appliedFilters

				local function fn2(p4: string)
					local stringifyValue = SduiParseHelpers.stringifyValue(data)

					p.dependencies.logger.reportError(
						SduiErrors.SduiErrorType.FailedToLogGameImpressions,
						{
							componentType = componentType,
							name = "SduiGameImpressionsHandler",
							message = `Failed to log game impressions. reason: {p4}. analyticsContext: {stringifyValue}`
						},
						p.appPage
					)
				end

				local v6

				if FFlagLuaAppSduiPassSortSubId and data.sortSubId then
					v6 = tostring(data.sortSubId)
				end

				sendFromTopicContents(
					eventIngest,
					appAnalytics,
					list,
					v3,
					appPage,
					collectionId,
					collectionPosition,
					p3,
					gameSetTargetId,
					nil,
					itemsPerRow,
					isWideTiles,
					componentType,
					appliedFilters,
					nil,
					fn2,
					v6,
					fn(data)
				)

				return
			end
		end
	end

	p.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogGameImpressions, {
		name = "SduiGameImpressionsHandler",
		message = `No entries to log: impressionIndexes={#list}, gameImpressionEntries={not FFlagSduiFixSearchTelemetry and #v3 or v2}`
	}, p.appPage)
end

return SduiGameImpressionsHandler
