local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Cryo = require(parent.Cryo)
local GameCollections = require(parent.GameCollections)
local SendGameImpressions = GameCollections.SendGameImpressions
require(parent.UnifiedLogging)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParsers = SduiCoreSystem.SduiParsers
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(parent.DiscoveryTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiFixSearchTelemetry = SharedFlags.FFlagSduiFixSearchTelemetry
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSponsoredGamePreviewVideo = SharedFlags2.FFlagLuaAppSponsoredGamePreviewVideo
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSduiPassSortSubId = SharedFlags3.FFlagLuaAppSduiPassSortSubId

local v = {}

local function sendLegacyGameImpressionsForSdui(list, p, p2, p3, data, p4: number?, p5, callback, p6: number?, name: string?)
	local v2 = FFlagSduiFixSearchTelemetry and 0 or nil
	local v3 = {}

	for k, v4 in p or v do
		local join = Cryo.Dictionary.join
		local v5 = {
			isSponsored = SduiParsers.safeParseBoolean(v4.adFlag or false, p5, p3),
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
				p5,
				p3
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

	if (not FFlagSduiFixSearchTelemetry and #v3 or v2) > 0 and #list > 0 then
		local itemComponentType = v3[list[1]] and v3[list[1]].itemComponentType or "unknown"

		local v4 = p2[list[1]]
		local v5

		if v4 then
			local componentType = SduiBuilder.getComponentType(v4, p5)
			local v6 = componentType == "Tile" or componentType == "GameTile"
			local v7 = v4.props and (v4.props.imageAspectRatio or 0) > 1
			v5 = v6 and v7
		end

		local v6

		if FFlagLuaAppSduiPassSortSubId then
			v6 = findAnalyticsFieldInAncestors("sortSubId", p3)
		end

		if callback then
			callback(list, v3, data.itemsPerRow, p4, v5)
		elseif p5.appPage == AppPage.SearchPage then
			local v7 = {
				searchUuid = findAnalyticsFieldInAncestors("searchUuid", p3),
				emphasisFlag = 0,
				seeAllFlag = 0,
				sortPos = data.collectionPosition,
				gameSetTypeId = tostring(data.collectionId)
			}

			SendGameImpressions.sendFromSearch(
				p5.dependencies.eventIngest,
				p5.dependencies.appAnalytics,
				list,
				v3,
				p5.appPage,
				v7,
				p6,
				p4,
				v5 or false,
				itemComponentType
			)
		elseif p5.appPage == AppPage.ExperienceDetail or p5.appPage == AppPage.GameDetail then
			local refId = data.refId
			SendGameImpressions.sendFromGameDetails(
				p5.dependencies.eventIngest,
				p5.dependencies.appAnalytics,
				list,
				v3,
				(tostring(refId))
			)
		else
			local sendFromTopicContents = SendGameImpressions.sendFromTopicContents
			local eventIngest = p5.dependencies.eventIngest
			local appAnalytics = p5.dependencies.appAnalytics

			local appPage = p5.appPage
			local collectionId = tostring(data.collectionId)
			local collectionPosition = data.collectionPosition

			local function fn(p7: string)
				local v7

				if p3 then
					v7 = SduiParseHelpers.stringifyValue(p3.analyticsData)
				end

				p5.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.FailedToLogGameImpressions,
					{
						componentType = itemComponentType,
						name = name,
						message = `Failed to log game impressions. reason: {p7}. analyticsContext: {v7}`
					},
					p5.appPage
				)
			end

			local v7

			if FFlagLuaAppSduiPassSortSubId and v6 then
				v7 = tostring(v6)
			end

			sendFromTopicContents(
				eventIngest,
				appAnalytics,
				list,
				v3,
				appPage,
				collectionId,
				collectionPosition,
				p4,
				nil,
				nil,
				p6,
				v5 or false,
				itemComponentType,
				nil,
				nil,
				fn,
				v7
			)
		end
	end
end

return sendLegacyGameImpressionsForSdui
