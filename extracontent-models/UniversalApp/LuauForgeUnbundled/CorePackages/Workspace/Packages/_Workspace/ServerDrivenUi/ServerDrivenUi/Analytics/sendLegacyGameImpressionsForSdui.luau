local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local sendGameImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").SendGameImpressions
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UnifiedLogging")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParsers = SduiCoreSystem.SduiParsers
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryTypes")
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiFixSearchTelemetry
local fFlagLuaAppSponsoredGamePreviewVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSponsoredGamePreviewVideo
local fFlagLuaAppSduiPassSortSubId = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiPassSortSubId

local v5 = {}

local function sendLegacyGameImpressionsForSdui(list, p2, p3, p4, data, p5, p6, callback, p7, p8)
	local v6 = fFlagSduiFixSearchTelemetry and 0 or nil
	local v7 = {}

	for k, v8 in p2 or v5 do
		local join = Cryo.Dictionary.join
		local v9 = {
			isSponsored = sduiParsers.safeParseBoolean(v8.adFlag or false, p6, p4),
			gameCollectionItemTypeOverride = 0,
			sponsoredGamePreviewVideoEligible = 0
		}

		local v10 = if fFlagSduiFixSearchTelemetry then v8.tileType else nil
		v9.gameCollectionItemTypeOverride = v10

		local v11 = if fFlagLuaAppSponsoredGamePreviewVideo then sduiParsers.safeParseBoolean(
			v8.sponsoredGamePreviewVideoEligible or false,
			p6,
			p4
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

	if (not fFlagSduiFixSearchTelemetry and #v7 or v6) > 0 and #list > 0 then
		local itemComponentType = v7[list[1]] and v7[list[1]].itemComponentType or "unknown"

		local v8 = p3[list[1]]
		local v9

		if v8 then
			local componentType = sduiBuilder.getComponentType(v8, p6)
			local v10 = componentType == "Tile" or componentType == "GameTile"
			local v11 = v8.props and (v8.props.imageAspectRatio or 0) > 1
			v9 = v10 and v11
		end

		local v10

		if fFlagLuaAppSduiPassSortSubId then
			v10 = findAnalyticsFieldInAncestors("sortSubId", p4)
		end

		if callback then
			callback(list, v7, data.itemsPerRow, p5, v9)
		elseif p6.appPage == appPage.SearchPage then
			local v11 = {
				searchUuid = findAnalyticsFieldInAncestors("searchUuid", p4),
				emphasisFlag = 0,
				seeAllFlag = 0,
				sortPos = data.collectionPosition,
				gameSetTypeId = tostring(data.collectionId)
			}

			sendGameImpressions.sendFromSearch(
				p6.dependencies.eventIngest,
				p6.dependencies.appAnalytics,
				list,
				v7,
				p6.appPage,
				v11,
				p7,
				p5,
				v9 or false,
				itemComponentType
			)
		elseif p6.appPage == appPage.ExperienceDetail or p6.appPage == appPage.GameDetail then
			local refId = data.refId
			sendGameImpressions.sendFromGameDetails(
				p6.dependencies.eventIngest,
				p6.dependencies.appAnalytics,
				list,
				v7,
				(tostring(refId))
			)
		else
			local sendFromTopicContents = sendGameImpressions.sendFromTopicContents
			local eventIngest = p6.dependencies.eventIngest
			local appAnalytics = p6.dependencies.appAnalytics

			local appPage2 = p6.appPage
			local collectionId = tostring(data.collectionId)
			local collectionPosition = data.collectionPosition

			local function fn(p9)
				local v16 = if p4 then sduiParseHelpers.stringifyValue(p4.analyticsData) else nil

				p6.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.FailedToLogGameImpressions,
					{
						componentType = itemComponentType,
						name = p8,
						message = `Failed to log game impressions. reason: {p9}. analyticsContext: {v16}`
					},
					p6.appPage
				)
			end
			local v16 = if fFlagLuaAppSduiPassSortSubId and v10 then tostring(v10) else nil
			sendFromTopicContents(
				eventIngest,
				appAnalytics,
				list,
				v7,
				appPage2,
				collectionId,
				collectionPosition,
				p5,
				nil,
				nil,
				p7,
				v9 or false,
				itemComponentType,
				nil,
				nil,
				fn,
				v16
			)
		end
	end
end

return sendLegacyGameImpressionsForSdui
