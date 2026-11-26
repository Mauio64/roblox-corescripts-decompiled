local LocalizationService = game:GetService("LocalizationService")

local AppStorageService = game:GetService("AppStorageService")
local IXPService = game:GetService("IXPService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/ArgCheck")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/LoggingProtocol")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")
local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").getGameTileLayoutData
local getValidTileBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").getValidTileBadges
local getTileBadgeByPositionConfigFromEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").getTileBadgeByPositionConfigFromEntry
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile")
local itemLayoutDataParsingUtils = GameTile.ItemLayoutDataParsingUtils
local calculateRowPositionFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UnifiedLogging").calculateRowPositionFields
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryUtils").DiscoveryEventErrorLogger

local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/ExperimentLayers").AppUserLayers
local gameImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/gameImpressionsEvent")
local reportGameImpressionCounts = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/reportGameImpressionCounts")
local FeedItemRowDataHitCounter = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/FeedItemRowDataHitCounter")
local FeedItemRowDataMissingCounter = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/FeedItemRowDataMissingCounter")
local fFlagLuaAppGameImpressionsMobileAdsId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppGameImpressionsMobileAdsId
local fFlagTraversalHistoryDiscoveryTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagTraversalHistoryDiscoveryTelemetry

local fFlagLuaAppGameImpressionsAddUnifiedFields = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppGameImpressionsAddUnifiedFields
local fFlagSduiFixSearchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagSduiFixSearchTelemetry
local fFlagLuaAppSponsoredGamePreviewVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppSponsoredGamePreviewVideo
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppHomeMomentVideoFallback
local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local function logSponsoredGamePreviewVideoExposureIfEligible(list, list2, p2)
	for i, item in ipairs(list) do
		local v5 = list2[item]

		if v5 and v5.isSponsored and v5.sponsoredGamePreviewVideoEligible == true then
			if p2 == appPage.Home then
				IXPService:LogUserLayerExposure(appUserLayers.SponsoredGamePreviewVideo)
			else
				discoveryEventErrorLogger.reportError(
					"SponsoredGamePreviewVideoEligibleImpressionOutsideHome",
					"A sponsored GPV-eligible tile was impressed outside Home; exposure was suppressed",
					{ pageContext = p2, entryIndex = item }
				)
			end

			break
		end
	end
end

local function addGameFields(list, p2, p3, p4, p5, gameSortId, options, p6, p7)
	local v5 = fFlagLuaAppDiscoveryMomentVideoTelemetry and {} or nil
	local placeIds = {}
	local v6 = {}

	local universeIds = {}
	local topicContentsIndexes = {}

	local v7 = {}
	local v8 = {}

	local gameCollectionItemTypeOverrides = {}
	local rowInSorts = {}
	local v9 = {}
	local v10 = {}
	local v11 = {}
	local v12 = {}

	local set = {}
	local v13 = {}
	local v14 = {}
	local v15 = {}

	local v16 = {}
	local v17 = {}
	local flag = false

	for i, item in ipairs(list) do
		local v18 = p2[item]

		if v18 == nil then
			continue
		end

		if v18.gameCollectionItemTypeOverride == gameCollectionItemTypes.GameCollectionItemType.Blank then
			local reportError = discoveryEventErrorLogger.reportError

			local v22 = if p6 then p6.emphasisFlag else nil
			local v23 = if p6 then p6.sortPos else nil
			reportError(
				"InvalidGameImpressionCollectionItemType",
				"An impression for a blank tile was attempted to be logged, which should not happen.",
				{
					entryIndex = item,
					pageContext = p7,
					emphasisFlag = v22,
					sortPos = v23,
					gameSortId = gameSortId
				}
			)
		else
			local uiIndex = v18.uiIndex or item
			local topicContentsIndex = v18.topicContentsIndex or item

			table.insert(placeIds, v18.placeId or 0)
			table.insert(v6, item)
			table.insert(universeIds, v18.universeId or 0)
			table.insert(topicContentsIndexes, topicContentsIndex)

			if v18.isSponsored then
				table.insert(v7, 1)
				table.insert(v8, v18.adId or 0)
				flag = true
			else
				table.insert(v7, 0)
				table.insert(v8, 0)
			end

			table.insert(
				gameCollectionItemTypeOverrides,
				v18.gameCollectionItemTypeOverride or gameCollectionItemTypes.GameCollectionItemType.GameTile
			)

			local v19 = calculateRowPositionFields(uiIndex, p3, p5)

			if p3 and p3 > 0 then
				table.insert(rowInSorts, v19.rowInSort)

				if p5 then
					table.insert(v9, v19.rowOnPage)
					table.insert(v10, v19.positionInRow)
				end
			else
				ArgCheck.assert(p3 ~= 0)

				if p5 then
					table.insert(v9, p5)
					table.insert(v10, uiIndex)
				end
			end

			local gameTileLayoutData = getGameTileLayoutData(v18, gameSortId)

			local v20 = getTileBadgeByPositionConfigFromEntry(v18)
				or gameTileLayoutData.tileBadgesByPosition

			local v21 = nil

			if v18.tileBadgeIds then
				v21 = v18.tileBadgeIds
			elseif v20 then
				local validTileBadges = getValidTileBadges(v20)
				local v22 = {}

				for k, validTileBadge in validTileBadges do
					local mapped = Cryo.List.map(validTileBadge, function(p8)
						return p8.analyticsId
					end)

					if #mapped > 0 then
						table.insert(v22, k .. "=" .. table.concat(mapped, "+"))
					end
				end

				if #v22 > 0 then
					v21 = table.concat(v22, "&")
				end
			end

			table.insert(v11, v21 or "0")

			if p4 then
				if v18 and v18.thumbnailAssetId then
					table.insert(v12, v18.thumbnailAssetId)
				else
					local v22

					if v18 and v18.primaryWideImageAssetId then
						v22 = v18.primaryWideImageAssetId
					else
						v22 = itemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
					end

					if not v22 then
						v22 = if v18 then v18.primaryWideAssetId or nil else nil
					end

					table.insert(v12, v22 or "0")
				end

				if v18 and v18.thumbnailListId then
					table.insert(v14, v18.thumbnailListId)
				else
					local v22 = if v18 and v18.primaryWideImageListId then v18.primaryWideImageListId else gameTileLayoutData and gameTileLayoutData.primaryMediaAsset and gameTileLayoutData.primaryMediaAsset.wideImageListId

					table.insert(v14, v22 or v18 and v18.primaryWideListId or "0")
				end

				if v18 and v18.videoThumbnailAssetId then
					table.insert(v15, v18.videoThumbnailAssetId)

					if fFlagLuaAppDiscoveryMomentVideoTelemetry then
						table.insert(v5, "0")
					end
				else
					local v22

					if fFlagLuaAppHomeMomentVideoFallback then
						local layoutDataVideo = GameTile.getLayoutDataVideo(
							gameTileLayoutData,
							v18 and v18.primaryWideVideoAssetId
						)
						v22 = layoutDataVideo and layoutDataVideo.assetId

						if fFlagLuaAppDiscoveryMomentVideoTelemetry then
							table.insert(v5, layoutDataVideo and layoutDataVideo.isMoment and "1" or "0")
						end
					elseif v18 and v18.primaryWideVideoAssetId then
						v22 = v18.primaryWideVideoAssetId
					else
						v22 = gameTileLayoutData
							and gameTileLayoutData.primaryMediaAsset
							and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
					end

					table.insert(v15, v22 or "0")
				end

				local analytics = nil

				if v18 and v18.footer and v18.footer.analytics then
					analytics = v18.footer.analytics
				elseif
					gameTileLayoutData
					and gameTileLayoutData.footer
					and gameTileLayoutData.footer.analytics
				then
					analytics = gameTileLayoutData.footer.analytics
				end

				if analytics and analytics.textLiteral then
					table.insert(v16, analytics.textLiteral)
				else
					table.insert(v16, "0")
				end

				if analytics and analytics.locKey then
					table.insert(v17, analytics.locKey)
				else
					table.insert(v17, "0")
				end
			end

			local analyticsData = v18.analyticsData

			if analyticsData then
				for k in analyticsData do
					set[k] = true
				end
			end

			table.insert(v13, analyticsData or {})
		end
	end

	local count = #placeIds
	ArgCheck.assert(count == #v6)
	ArgCheck.assert(count == #topicContentsIndexes)
	ArgCheck.assert(count == #universeIds)
	ArgCheck.assert(count == #v7)
	ArgCheck.assert(count == #v8)

	if #rowInSorts > 0 then
		ArgCheck.assert(count == #rowInSorts)
	end

	if #v9 > 0 then
		ArgCheck.assert(count == #v9)
	end

	if #v10 > 0 then
		ArgCheck.assert(count == #v10)
	end

	local v18 = {
		rootPlaceIds = table.concat(placeIds, ","),
		absPositions = table.concat(v6, ","),
		topicDataPositions = table.concat(topicContentsIndexes, ","),
		universeIds = table.concat(universeIds, ",")
	}

	if flag then
		v18.adFlags = table.concat(v7, ",")
		v18.adIds = table.concat(v8, ",")
	end

	if fFlagLuaAppGameImpressionsAddUnifiedFields then
		v18.hasSponsoredContent = flag
	end

	if #rowInSorts > 0 then
		v18.rows = table.concat(rowInSorts, ",")
	end

	if #v9 > 0 then
		v18.rowsOnPage = table.concat(v9, ",")
	end

	if #v10 > 0 then
		v18.positionsInRows = table.concat(v10, ",")
	end

	if p4 and #v12 > 0 then
		v18.thumbnailAssetIds = table.concat(v12, ",")
	end

	if p4 and #v14 > 0 then
		v18.thumbnailListIds = table.concat(v14, ",")
	end

	if p4 and #v15 > 0 then
		v18.videoThumbnailAssetIds = table.concat(v15, ",")
	end

	if fFlagLuaAppDiscoveryMomentVideoTelemetry and #v5 > 0 and not set.videoIsMoment then
		v18.videoIsMoment_arr = table.concat(v5, ",")
	end

	if #v11 > 0 then
		v18.tileBadgeContexts = table.concat(v11, ",")
	end

	if v16 and #v16 > 0 then
		v18.footerTextLiterals = table.concat(v16, ",")
	end

	if v17 and #v17 > 0 then
		v18.footerLocalizationKeys = table.concat(v17, ",")
	end

	if #gameCollectionItemTypeOverrides > 0 then
		v18.tileTypes = table.concat(gameCollectionItemTypeOverrides, ",")
	end

	local values = {}

	if next(set) then
		for k in set do
			local v19 = {}

			for k2, v20 in v13 do
				table.insert(v19, v20[k] or "0")
			end

			values[`{k}_arr`] = table.concat(v19, ",")
		end
	end

	local joined = Cryo.Dictionary.join(values, options or {})

	if next(joined) then
		v18.analyticsData = joined
	end

	return v18, count
end

local function addMobileAdvertisingIdToEventParams(p2)
	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		p2.mobileAdvertisingId = item
	end
end

local function hasNoEntries(list): boolean
	if fFlagSduiFixSearchTelemetry then
		return not list or next(list) == nil
	end

	return not list or #list == 0
end

return {
	sendFromTopicContents = function(p2, p3, list, list2, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, callback, p15, p16)
		if p2 and p3 then
			if list and #list ~= 0 then
				local v5

				if fFlagSduiFixSearchTelemetry then
					v5 = not list2 or next(list2) == nil
				else
					v5 = not list2 or #list2 == 0
				end

				if v5 then
					if callback then
						callback(`Missing topicContentsEntries or topicContentsEntries == 0 {list2}`)
					end
				else
					if fFlagLuaAppSponsoredGamePreviewVideo then
						logSponsoredGamePreviewVideoExposureIfEligible(list, list2, p4)
					end

					if p7 then
						LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataHitCounter)
					else
						LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataMissingCounter)
					end

					local v6, v7 = addGameFields(list, list2, p10, p11, p7, p5, p16)

					local joined = Cryo.Dictionary.join(v6, {
						sortPos = p6,
						gameSetTypeId = p5,
						gameSetTargetId = p8,
						pageId = p9,
						componentType = p12,
						locale = LocalizationService.RobloxLocaleId,
						appliedFilters = p13,
						loadSource = p14,
						sortSubId = p15
					})

					if fFlagLuaAppGameImpressionsMobileAdsId then
						local item = AppStorageService:GetItem("MobileAdvertisingId")

						if item and item ~= "" then
							joined.mobileAdvertisingId = item
						end
					end

					gameImpressionsEvent(p2, p4, joined)
					reportGameImpressionCounts(p3, p4, v7)
				end
			elseif callback then
				callback(`Missing impressionsToSend or impressionsToSend == 0 {list}`)
			end
		elseif callback then
			callback(`Missing analytics service eventIngest: {p2} appAnalytics: {p3}`)
		end
	end,
	sendFromSearch = function(p2, p3, list, list2, p4, p5, p6, p7, p8, p9)
		if not (p2 and p3) or (not list or #list == 0) then
			return
		end

		local v5

		if fFlagSduiFixSearchTelemetry then
			v5 = not list2 or next(list2) == nil
		else
			v5 = not list2 or #list2 == 0
		end

		if v5 then
			return
		end

		local v6, v7 = addGameFields(list, list2, p6, p8, p7, nil, nil, p5, p4)

		local joined = Cryo.Dictionary.join(v6, p5, {
			locale = LocalizationService.RobloxLocaleId,
			componentType = p9
		})

		if fFlagLuaAppGameImpressionsMobileAdsId then
			local item = AppStorageService:GetItem("MobileAdvertisingId")

			if item and item ~= "" then
				joined.mobileAdvertisingId = item
			end
		end

		gameImpressionsEvent(p2, p4, joined)
		reportGameImpressionCounts(p3, p4, v7)
	end,
	sendFromGameDetails = function(p2, p3, p4, p5, refId)
		local v5, v6 = addGameFields(p4, p5)
		v5.locale = LocalizationService.RobloxLocaleId
		v5.refId = refId

		if fFlagLuaAppGameImpressionsMobileAdsId then
			local item = AppStorageService:GetItem("MobileAdvertisingId")

			if item and item ~= "" then
				v5.mobileAdvertisingId = item
			end
		end

		gameImpressionsEvent(p2, "recommended", v5)
		reportGameImpressionCounts(p3, "recommended", v6)
	end,
	sendFromSeeAll = function(p2, p3, list, list2, p4, p5, p6, p7, p8, p9)
		if not (p2 and p3) or (not list or #list == 0) then
			return
		end

		local v5

		if fFlagSduiFixSearchTelemetry then
			v5 = not list2 or next(list2) == nil
		else
			v5 = not list2 or #list2 == 0
		end

		if v5 then
			return
		end

		if fFlagLuaAppSponsoredGamePreviewVideo then
			logSponsoredGamePreviewVideoExposureIfEligible(list, list2, p4)
		end

		local v6, v7 = addGameFields(list, list2, nil, p9)

		local joined = Cryo.Dictionary.join(v6, {
			gameSetTypeId = p5,
			gameSetTargetId = p6,
			pageId = p7,
			locale = LocalizationService.RobloxLocaleId,
			seeAllFlag = 1,
			appliedFilters = p8
		})

		if fFlagLuaAppGameImpressionsMobileAdsId then
			local item = AppStorageService:GetItem("MobileAdvertisingId")

			if item and item ~= "" then
				joined.mobileAdvertisingId = item
			end
		end

		gameImpressionsEvent(p2, p4, joined)
		reportGameImpressionCounts(p3, p4, v7, 1)
	end,
	sendFromTraversalHistoryPage = fFlagTraversalHistoryDiscoveryTelemetry and function(p2, p3, p4, p5, p6, p7)
		if not (p2 and p3) then
			return
		end

		local v5, v6 = addGameFields(p4, p5, p6, false, p7)
		gameImpressionsEvent(
			p2,
			"InExpHistoryPage",
			(Cryo.Dictionary.join(v5, { locale = LocalizationService.RobloxLocaleId }))
		)
		reportGameImpressionCounts(p3, "InExpHistoryPage", v6)
	end or nil
}
