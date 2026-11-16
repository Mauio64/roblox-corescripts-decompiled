local LocalizationService = game:GetService("LocalizationService")
local GameCollections = script:FindFirstAncestor("GameCollections")
local AppStorageService = game:GetService("AppStorageService")
local IXPService = game:GetService("IXPService")
local parent = GameCollections.Parent
local ArgCheck = require(parent.ArgCheck)
local LoggingProtocol = require(parent.LoggingProtocol)
local Cryo = require(parent.Cryo)
local GameTile = require(parent.GameTile)
local getGameTileLayoutData = GameTile.getGameTileLayoutData
local GameTile2 = require(parent.GameTile)
local getValidTileBadges = GameTile2.getValidTileBadges
local GameTile3 = require(parent.GameTile)
local getTileBadgeByPositionConfigFromEntry = GameTile3.getTileBadgeByPositionConfigFromEntry
local GameTile4 = require(parent.GameTile)
local ItemLayoutDataParsingUtils = GameTile4.ItemLayoutDataParsingUtils
local UnifiedLogging = require(parent.UnifiedLogging)
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local gameImpressionsEvent = require(script.Parent.gameImpressionsEvent)
local reportGameImpressionCounts = require(script.Parent.reportGameImpressionCounts)
local FeedItemRowDataHitCounter = require(script.Parent.FeedItemRowDataHitCounter)
local FeedItemRowDataMissingCounter = require(script.Parent.FeedItemRowDataMissingCounter)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppGameImpressionsMobileAdsId = SharedFlags.FFlagLuaAppGameImpressionsMobileAdsId
local SharedFlags2 = require(parent.SharedFlags)
local FFlagTraversalHistoryDiscoveryTelemetry = SharedFlags2.FFlagTraversalHistoryDiscoveryTelemetry

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGameImpressionsAddUnifiedFields = SharedFlags3.FFlagLuaAppGameImpressionsAddUnifiedFields
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiFixSearchTelemetry = SharedFlags4.FFlagSduiFixSearchTelemetry
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSponsoredGamePreviewVideo = SharedFlags5.FFlagLuaAppSponsoredGamePreviewVideo
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags6.FFlagLuaAppHomeMomentVideoFallback
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags7.FFlagLuaAppDiscoveryMomentVideoTelemetry

local function logSponsoredGamePreviewVideoExposureIfEligible(list, list2, pageContext: string)
	for _, item in ipairs(list) do
		local v = list2[item]

		if v and v.isSponsored and v.sponsoredGamePreviewVideoEligible == true then
			if pageContext == AppPage.Home then
				IXPService:LogUserLayerExposure(AppUserLayers.SponsoredGamePreviewVideo)
			else
				DiscoveryEventErrorLogger.reportError(
					"SponsoredGamePreviewVideoEligibleImpressionOutsideHome",
					"A sponsored GPV-eligible tile was impressed outside Home; exposure was suppressed",
					{ pageContext = pageContext, entryIndex = item }
				)
			end

			break
		end
	end
end

local function addGameFields(list, p, p2, p3, p4, gameSortId: string?, options, p5, pageContext: string?)
	local v = FFlagLuaAppDiscoveryMomentVideoTelemetry and {} or nil
	local placeIds = {}
	local v2 = {}

	local universeIds = {}
	local topicContentsIndexes = {}

	local v3 = {}
	local v4 = {}

	local gameCollectionItemTypeOverrides = {}
	local rowInSorts = {}
	local v5 = {}
	local v6 = {}
	local v7 = {}
	local v8 = {}

	local set = {}
	local v9 = {}
	local v10 = {}
	local v11 = {}

	local v12 = {}
	local v13 = {}
	local flag = false

	for _, item in ipairs(list) do
		local v14 = p[item]

		if v14 == nil then
			continue
		end

		if v14.gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.Blank then
			local reportError = DiscoveryEventErrorLogger.reportError
			local emphasisFlag

			if p5 then
				emphasisFlag = p5.emphasisFlag
			end

			local sortPos

			if p5 then
				sortPos = p5.sortPos
			end

			reportError(
				"InvalidGameImpressionCollectionItemType",
				"An impression for a blank tile was attempted to be logged, which should not happen.",
				{
					entryIndex = item,
					pageContext = pageContext,
					emphasisFlag = emphasisFlag,
					sortPos = sortPos,
					gameSortId = gameSortId
				}
			)
		else
			local uiIndex = v14.uiIndex or item
			local topicContentsIndex = v14.topicContentsIndex or item

			table.insert(placeIds, v14.placeId or 0)
			table.insert(v2, item)
			table.insert(universeIds, v14.universeId or 0)
			table.insert(topicContentsIndexes, topicContentsIndex)

			if v14.isSponsored then
				table.insert(v3, 1)
				table.insert(v4, v14.adId or 0)
				flag = true
			else
				table.insert(v3, 0)
				table.insert(v4, 0)
			end

			table.insert(
				gameCollectionItemTypeOverrides,
				v14.gameCollectionItemTypeOverride or GameCollectionItemTypes.GameCollectionItemType.GameTile
			)

			local v15 = calculateRowPositionFields(uiIndex, p2, p4)

			if p2 and p2 > 0 then
				table.insert(rowInSorts, v15.rowInSort)

				if p4 then
					table.insert(v5, v15.rowOnPage)
					table.insert(v6, v15.positionInRow)
				end
			else
				ArgCheck.assert(p2 ~= 0)

				if p4 then
					table.insert(v5, p4)
					table.insert(v6, uiIndex)
				end
			end

			local gameTileLayoutData = getGameTileLayoutData(v14, gameSortId)

			local v16 = getTileBadgeByPositionConfigFromEntry(v14) or gameTileLayoutData.tileBadgesByPosition

			local v17 = nil

			if v14.tileBadgeIds then
				v17 = v14.tileBadgeIds
			elseif v16 then
				local validTileBadges = getValidTileBadges(v16)
				local v18 = {}

				for k, validTileBadge in validTileBadges do
					local mapped = Cryo.List.map(validTileBadge, function(p6)
						return p6.analyticsId
					end)

					if #mapped > 0 then
						table.insert(v18, k .. "=" .. table.concat(mapped, "+"))
					end
				end

				if #v18 > 0 then
					v17 = table.concat(v18, "&")
				end
			end

			table.insert(v7, v17 or "0")

			if p3 then
				if v14 and v14.thumbnailAssetId then
					table.insert(v8, v14.thumbnailAssetId)
				else
					local v18

					if v14 and v14.primaryWideImageAssetId then
						v18 = v14.primaryWideImageAssetId
					else
						v18 = ItemLayoutDataParsingUtils.getWideImageAssetId(gameTileLayoutData)
					end

					if not v18 then
						if v14 then
							v18 = v14.primaryWideAssetId or nil
						else
							v18 = nil
						end
					end

					table.insert(v8, v18 or "0")
				end

				if v14 and v14.thumbnailListId then
					table.insert(v10, v14.thumbnailListId)
				else
					local v18

					if v14 and v14.primaryWideImageListId then
						v18 = v14.primaryWideImageListId
					else
						v18 = gameTileLayoutData
							and gameTileLayoutData.primaryMediaAsset
							and gameTileLayoutData.primaryMediaAsset.wideImageListId
					end

					table.insert(v10, v18 or v14 and v14.primaryWideListId or "0")
				end

				if v14 and v14.videoThumbnailAssetId then
					table.insert(v11, v14.videoThumbnailAssetId)

					if FFlagLuaAppDiscoveryMomentVideoTelemetry then
						table.insert(v, "0")
					end
				else
					local v18

					if FFlagLuaAppHomeMomentVideoFallback then
						local layoutDataVideo = GameTile4.getLayoutDataVideo(
							gameTileLayoutData,
							v14 and v14.primaryWideVideoAssetId
						)
						v18 = layoutDataVideo and layoutDataVideo.assetId

						if FFlagLuaAppDiscoveryMomentVideoTelemetry then
							table.insert(v, layoutDataVideo and layoutDataVideo.isMoment and "1" or "0")
						end
					elseif v14 and v14.primaryWideVideoAssetId then
						v18 = v14.primaryWideVideoAssetId
					else
						v18 = gameTileLayoutData
							and gameTileLayoutData.primaryMediaAsset
							and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
					end

					table.insert(v11, v18 or "0")
				end

				local analytics = nil

				if v14 and v14.footer and v14.footer.analytics then
					analytics = v14.footer.analytics
				elseif gameTileLayoutData and gameTileLayoutData.footer and gameTileLayoutData.footer.analytics then
					analytics = gameTileLayoutData.footer.analytics
				end

				if analytics and analytics.textLiteral then
					table.insert(v12, analytics.textLiteral)
				else
					table.insert(v12, "0")
				end

				if analytics and analytics.locKey then
					table.insert(v13, analytics.locKey)
				else
					table.insert(v13, "0")
				end
			end

			local analyticsData = v14.analyticsData

			if analyticsData then
				for k in analyticsData do
					set[k] = true
				end
			end

			table.insert(v9, analyticsData or {})
		end
	end

	local count = #placeIds
	ArgCheck.assert(count == #v2)
	ArgCheck.assert(count == #topicContentsIndexes)
	ArgCheck.assert(count == #universeIds)
	ArgCheck.assert(count == #v3)
	ArgCheck.assert(count == #v4)

	if #rowInSorts > 0 then
		ArgCheck.assert(count == #rowInSorts)
	end

	if #v5 > 0 then
		ArgCheck.assert(count == #v5)
	end

	if #v6 > 0 then
		ArgCheck.assert(count == #v6)
	end

	local v14 = {
		rootPlaceIds = table.concat(placeIds, ","),
		absPositions = table.concat(v2, ","),
		topicDataPositions = table.concat(topicContentsIndexes, ","),
		universeIds = table.concat(universeIds, ",")
	}

	if flag then
		v14.adFlags = table.concat(v3, ",")
		v14.adIds = table.concat(v4, ",")
	end

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		v14.hasSponsoredContent = flag
	end

	if #rowInSorts > 0 then
		v14.rows = table.concat(rowInSorts, ",")
	end

	if #v5 > 0 then
		v14.rowsOnPage = table.concat(v5, ",")
	end

	if #v6 > 0 then
		v14.positionsInRows = table.concat(v6, ",")
	end

	if p3 and #v8 > 0 then
		v14.thumbnailAssetIds = table.concat(v8, ",")
	end

	if p3 and #v10 > 0 then
		v14.thumbnailListIds = table.concat(v10, ",")
	end

	if p3 and #v11 > 0 then
		v14.videoThumbnailAssetIds = table.concat(v11, ",")
	end

	if FFlagLuaAppDiscoveryMomentVideoTelemetry and #v > 0 and not set.videoIsMoment then
		v14.videoIsMoment_arr = table.concat(v, ",")
	end

	if #v7 > 0 then
		v14.tileBadgeContexts = table.concat(v7, ",")
	end

	if v12 and #v12 > 0 then
		v14.footerTextLiterals = table.concat(v12, ",")
	end

	if v13 and #v13 > 0 then
		v14.footerLocalizationKeys = table.concat(v13, ",")
	end

	if #gameCollectionItemTypeOverrides > 0 then
		v14.tileTypes = table.concat(gameCollectionItemTypeOverrides, ",")
	end

	local values = {}

	if next(set) then
		for k in set do
			local v15 = {}

			for _, v16 in v9 do
				table.insert(v15, v16[k] or "0")
			end

			values[`{k}_arr`] = table.concat(v15, ",")
		end
	end

	local joined = Cryo.Dictionary.join(values, options or {})

	if next(joined) then
		v14.analyticsData = joined
	end

	return v14, count
end

local function addMobileAdvertisingIdToEventParams(p) -- 4 equivalent calls inferred from this helper
	local item = AppStorageService:GetItem("MobileAdvertisingId")

	if item and item ~= "" then
		p.mobileAdvertisingId = item
	end
end

local function hasNoEntries(list): boolean -- 3 equivalent calls inferred from this helper
	if FFlagSduiFixSearchTelemetry then
		return not list or next(list) == nil
	end

	return not list or #list == 0
end

local SendGameImpressions = {}

function SendGameImpressions.sendFromTopicContents(p, p2, list, list2, pageContext: string, gameSetTypeId: string, sortPos: number, p3: number?, gameSetTargetId: number?, pageId: string?, p4: number?, flag: boolean?, componentType: string?, appliedFilters: string?, loadSource: string?, callback, sortSubId: string?, p5)
	if p and p2 then
		if list and #list ~= 0 then
			if hasNoEntries(list2) then -- inferred equivalent call
				if callback then
					callback(`Missing topicContentsEntries or topicContentsEntries == 0 {list2}`)
				end
			else
				if FFlagLuaAppSponsoredGamePreviewVideo then
					logSponsoredGamePreviewVideoExposureIfEligible(list, list2, pageContext)
				end

				if p3 then
					LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataHitCounter)
				else
					LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataMissingCounter)
				end

				local v, v2 = addGameFields(list, list2, p4, flag, p3, gameSetTypeId, p5)

				local joined = Cryo.Dictionary.join(v, {
					sortPos = sortPos,
					gameSetTypeId = gameSetTypeId,
					gameSetTargetId = gameSetTargetId,
					pageId = pageId,
					componentType = componentType,
					locale = LocalizationService.RobloxLocaleId,
					appliedFilters = appliedFilters,
					loadSource = loadSource,
					sortSubId = sortSubId
				})

				if FFlagLuaAppGameImpressionsMobileAdsId then
					addMobileAdvertisingIdToEventParams(joined) -- inferred equivalent call
				end

				gameImpressionsEvent(p, pageContext, joined)
				reportGameImpressionCounts(p2, pageContext, v2)
			end
		elseif callback then
			callback(`Missing impressionsToSend or impressionsToSend == 0 {list}`)
		end
	elseif callback then
		callback(`Missing analytics service eventIngest: {p} appAnalytics: {p2}`)
	end
end

function SendGameImpressions.sendFromSearch(p, p2, list, list2, pageContext: string, p3, p4, p5, flag: boolean?, componentType: string?)
	if not (p and p2) or (not list or #list == 0) then
		return
	end

	if hasNoEntries(list2) then -- inferred equivalent call
		return
	end

	local v, v2 = addGameFields(list, list2, p4, flag, p5, nil, nil, p3, pageContext)

	local joined = Cryo.Dictionary.join(v, p3, {
		locale = LocalizationService.RobloxLocaleId,
		componentType = componentType
	})

	if FFlagLuaAppGameImpressionsMobileAdsId then
		addMobileAdvertisingIdToEventParams(joined) -- inferred equivalent call
	end

	gameImpressionsEvent(p, pageContext, joined)
	reportGameImpressionCounts(p2, pageContext, v2)
end

function SendGameImpressions.sendFromGameDetails(p, p2, p3, p4, refId)
	local v, v2 = addGameFields(p3, p4)
	v.locale = LocalizationService.RobloxLocaleId
	v.refId = refId

	if FFlagLuaAppGameImpressionsMobileAdsId then
		addMobileAdvertisingIdToEventParams(v) -- inferred equivalent call
	end

	gameImpressionsEvent(p, "recommended", v)
	reportGameImpressionCounts(p2, "recommended", v2)
end

function SendGameImpressions.sendFromSeeAll(p, p2, list, list2, pageContext: string, gameSetTypeId: string, gameSetTargetId: number?, pageId: string?, appliedFilters: string?, flag: boolean?)
	if not (p and p2) or (not list or #list == 0) then
		return
	end

	if hasNoEntries(list2) then -- inferred equivalent call
		return
	end

	if FFlagLuaAppSponsoredGamePreviewVideo then
		logSponsoredGamePreviewVideoExposureIfEligible(list, list2, pageContext)
	end

	local v, v2 = addGameFields(list, list2, nil, flag)

	local joined = Cryo.Dictionary.join(v, {
		gameSetTypeId = gameSetTypeId,
		gameSetTargetId = gameSetTargetId,
		pageId = pageId,
		locale = LocalizationService.RobloxLocaleId,
		seeAllFlag = 1,
		appliedFilters = appliedFilters
	})

	if FFlagLuaAppGameImpressionsMobileAdsId then
		addMobileAdvertisingIdToEventParams(joined) -- inferred equivalent call
	end

	gameImpressionsEvent(p, pageContext, joined)
	reportGameImpressionCounts(p2, pageContext, v2, 1)
end

SendGameImpressions.sendFromTraversalHistoryPage = FFlagTraversalHistoryDiscoveryTelemetry
	and function(p, p2, p3, p4, p5: number, p6: number)
		if not (p and p2) then
			return
		end

		local v, v2 = addGameFields(p3, p4, p5, false, p6)
		gameImpressionsEvent(
			p,
			"InExpHistoryPage",
			(Cryo.Dictionary.join(v, { locale = LocalizationService.RobloxLocaleId }))
		)
		reportGameImpressionCounts(p2, "InExpHistoryPage", v2)
	end
	or nil
return SendGameImpressions
