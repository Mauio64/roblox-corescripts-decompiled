local LocalizationService = game:GetService("LocalizationService")
local GameCollections = script:FindFirstAncestor("GameCollections")
local AppStorageService = game:GetService("AppStorageService")
local GameCollectionsParent = GameCollections.Parent
local ArgCheck = require(GameCollectionsParent.ArgCheck)
local LoggingProtocol = require(GameCollectionsParent.LoggingProtocol)
local Cryo = require(GameCollectionsParent.Cryo)
local getGameTileLayoutData = require(GameCollectionsParent.GameTile).getGameTileLayoutData
local getValidTileBadges = require(GameCollectionsParent.GameTile).getValidTileBadges
local getTileBadgeByPositionConfigFromEntry = require(GameCollectionsParent.GameTile).getTileBadgeByPositionConfigFromEntry
local ItemLayoutDataParsingUtils = require(GameCollectionsParent.GameTile).ItemLayoutDataParsingUtils
local calculateRowPositionFields = require(GameCollectionsParent.UnifiedLogging).calculateRowPositionFields
local DiscoveryEventErrorLogger = require(GameCollectionsParent.DiscoveryUtils).DiscoveryEventErrorLogger
local GameCollectionItemTypes = require(GameCollectionsParent.DiscoveryTypes).GameCollectionItemTypes
local gameImpressionsEvent = require(script.Parent.gameImpressionsEvent)
local reportGameImpressionCounts = require(script.Parent.reportGameImpressionCounts)
local FeedItemRowDataHitCounter = require(script.Parent.FeedItemRowDataHitCounter)
local FeedItemRowDataMissingCounter = require(script.Parent.FeedItemRowDataMissingCounter)
local FFlagLuaAppGameImpressionsMobileAdsId = require(GameCollectionsParent.SharedFlags).FFlagLuaAppGameImpressionsMobileAdsId
local FFlagEnableInGameExitModalNextUpUi = require(GameCollectionsParent.SharedFlags).FFlagEnableInGameExitModalNextUpUi
local FFlagTraversalHistoryDiscoveryTelemetry = require(GameCollectionsParent.SharedFlags).FFlagTraversalHistoryDiscoveryTelemetry
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagLuaAppAddSubIdToHomeEvents = require(GameCollectionsParent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppFixSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixSearchImpressions
local FFlagLuaAppGameImpressionsAddUnifiedFields = require(GameCollectionsParent.SharedFlags).FFlagLuaAppGameImpressionsAddUnifiedFields

local function addGameFields(t1: {[any]: any}, t2: {[any]: any}, p1, p2, p3, s1: string?, t3: {[any]: any}?, p4, s2: string?) -- line: 59
	-- upvalues: FFlagLuaAppFixSearchImpressions (copy), GameCollectionItemTypes (copy), DiscoveryEventErrorLogger (copy), calculateRowPositionFields (copy), ArgCheck (copy), getGameTileLayoutData (copy), getTileBadgeByPositionConfigFromEntry (copy), getValidTileBadges (copy), Cryo (copy), ItemLayoutDataParsingUtils (copy), FFlagLuaAppGameImpressionsAddUnifiedFields (copy)
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local t9 = {}
	local t10 = {}
	local t11 = {}
	local t12 = {}
	local t13 = {}
	local t14 = {}
	local t15 = {}
	local t16 = {}
	local t17 = {}
	local t18 = {}
	local t19 = {}
	local t20 = {}
	local t21 = {}
	local v55 = false

	for _, v in ipairs(t1) do
		local v58 = t2[v]

		if v58 ~= nil then
			if FFlagLuaAppFixSearchImpressions and v58.gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.Blank then
				DiscoveryEventErrorLogger.reportError("InvalidGameImpressionCollectionItemType", "An impression for a blank tile was attempted to be logged, which should not happen.", {
					entryIndex = v,
					pageContext = s2,
					emphasisFlag = if not p4 then nil else p4.emphasisFlag,
					sortPos = if not p4 then nil else p4.sortPos,
					gameSortId = s1
				})
			else
				local v59 = v58.uiIndex or v
				local v60 = v58.topicContentsIndex or v

				table.insert(t4, v58.placeId or 0)
				table.insert(t5, v)
				table.insert(t7, v58.universeId or 0)
				table.insert(t6, v60)

				if v58.isSponsored then
					v55 = true
					table.insert(t11, 1)
					table.insert(t12, v58.adId or 0)
				else
					table.insert(t11, 0)
					table.insert(t12, 0)
				end

				table.insert(t19, v58.gameCollectionItemTypeOverride or GameCollectionItemTypes.GameCollectionItemType.GameTile)

				local v61 = calculateRowPositionFields(v59, p1, p3)

				if p1 and p1 > 0 then
					table.insert(t13, v61.rowInSort)

					if p3 then
						table.insert(t14, v61.rowOnPage)
						table.insert(t15, v61.positionInRow)
					end
				else
					ArgCheck.assert(p1 ~= 0)

					if p3 then
						table.insert(t14, p3)
						table.insert(t15, v59)
					end
				end

				local v62 = getGameTileLayoutData(v58, s1)
				local v63 = getTileBadgeByPositionConfigFromEntry(v58) or v62.tileBadgesByPosition
				local tileBadgeIds = nil

				if v58.tileBadgeIds then
					tileBadgeIds = v58.tileBadgeIds
				elseif v63 then
					local t22 = {}

					for v66, v67 in (getValidTileBadges(v63)) do
						local v68 = Cryo.List.map(v67, function(p5) -- line: 176
							return p5.analyticsId
						end)

						if #v68 > 0 then
							table.insert(t22, v66 .. "=" .. table.concat(v68, "+"))
						end
					end

					if #t22 > 0 then
						tileBadgeIds = table.concat(t22, "&")
					end
				end

				table.insert(t16, tileBadgeIds or "0")

				if p2 then
					if v58 and v58.thumbnailAssetId then
						table.insert(t8, v58.thumbnailAssetId)
					else
						table.insert(t8, ((if not v58 or not v58.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v62) else v58.primaryWideImageAssetId)) or (v58 and v58.primaryWideAssetId or nil) or "0")
					end

					if v58 and v58.thumbnailListId then
						table.insert(t9, v58.thumbnailListId)
					else
						table.insert(t9, ((if not v58 or not v58.primaryWideImageListId then v62 and (v62.primaryMediaAsset and v62.primaryMediaAsset.wideImageListId) else v58.primaryWideImageListId)) or (v58 and v58.primaryWideListId or "0"))
					end

					if v58 and v58.videoThumbnailAssetId then
						table.insert(t10, v58.videoThumbnailAssetId)
					else
						table.insert(t10, ((if not v58 or not v58.primaryWideVideoAssetId then v62 and (v62.primaryMediaAsset and v62.primaryMediaAsset.wideVideoAssetId) else v58.primaryWideVideoAssetId)) or "0")
					end

					local analytics = nil

					if v58 and v58.footer and v58.footer.analytics then
						analytics = v58.footer.analytics
					elseif v62 and v62.footer and v62.footer.analytics then
						analytics = v62.footer.analytics
					end

					if analytics and analytics.textLiteral then
						table.insert(t17, analytics.textLiteral)
					else
						table.insert(t17, "0")
					end

					if analytics and analytics.locKey then
						table.insert(t18, analytics.locKey)
					else
						table.insert(t18, "0")
					end
				end

				local analyticsData = v58.analyticsData

				if analyticsData then
					for v71 in analyticsData do
						t21[v71] = true
					end
				end

				table.insert(t20, analyticsData or {})
			end
		end
	end

	local v72 = #t4

	ArgCheck.assert(v72 == #t5)
	ArgCheck.assert(v72 == #t6)
	ArgCheck.assert(v72 == #t7)
	ArgCheck.assert(v72 == #t11)
	ArgCheck.assert(v72 == #t12)

	if #t13 > 0 then
		ArgCheck.assert(v72 == #t13)
	end

	if #t14 > 0 then
		ArgCheck.assert(v72 == #t14)
	end

	if #t15 > 0 then
		ArgCheck.assert(v72 == #t15)
	end

	local t23 = {
		rootPlaceIds = table.concat(t4, ","),
		absPositions = table.concat(t5, ","),
		topicDataPositions = table.concat(t6, ","),
		universeIds = table.concat(t7, ",")
	}

	if v55 then
		t23.adFlags = table.concat(t11, ",")
		t23.adIds = table.concat(t12, ",")
	end

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		t23.hasSponsoredContent = v55
	end

	if #t13 > 0 then
		t23.rows = table.concat(t13, ",")
	end

	if #t14 > 0 then
		t23.rowsOnPage = table.concat(t14, ",")
	end

	if #t15 > 0 then
		t23.positionsInRows = table.concat(t15, ",")
	end

	if p2 and #t8 > 0 then
		t23.thumbnailAssetIds = table.concat(t8, ",")
	end

	if p2 and #t9 > 0 then
		t23.thumbnailListIds = table.concat(t9, ",")
	end

	if p2 and #t10 > 0 then
		t23.videoThumbnailAssetIds = table.concat(t10, ",")
	end

	if #t16 > 0 then
		t23.tileBadgeContexts = table.concat(t16, ",")
	end

	if t17 and #t17 > 0 then
		t23.footerTextLiterals = table.concat(t17, ",")
	end

	if t18 and #t18 > 0 then
		t23.footerLocalizationKeys = table.concat(t18, ",")
	end

	if #t19 > 0 then
		t23.tileTypes = table.concat(t19, ",")
	end

	local t24 = {}

	if next(t21) then
		for v75 in t21 do
			local t25 = {}

			for _, v78 in t20 do
				table.insert(t25, v78[v75] or "0")
			end

			t24[`{ v75 }_arr`] = table.concat(t25, ",")
		end
	end

	local v79 = Cryo.Dictionary.join(t24, t3 or {})

	if next(v79) then
		t23.analyticsData = v79
	end

	return t23, v72
end
local function addMobileAdvertisingIdToEventParams(p6) -- line: 350
	-- upvalues: AppStorageService (copy)
	local Item = AppStorageService:GetItem("MobileAdvertisingId")

	if Item and Item ~= "" then
		p6.mobileAdvertisingId = Item
	end
end

return {
	sendFromTopicContents = function(p7, p8, t26: {[any]: any}, p9, s3: string, s4: string, n1: number, n2: number?, n3: number?, s5: string?, n4: number?, b1: boolean?, s6: string?, s7: string?, s8: string?, p10: ((...any) -> ...any)?, s9: string?, t27: {[any]: any}?) -- line: 357
		-- upvalues: LoggingProtocol (copy), FeedItemRowDataHitCounter (copy), FeedItemRowDataMissingCounter (copy), addGameFields (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p7 or not p8 then
			if p10 then
				p10(`Missing analytics service eventIngest: { p7 } appAnalytics: { p8 }`)
			end

			return
		end

		if not t26 or #t26 == 0 then
			if p10 then
				p10(`Missing impressionsToSend or impressionsToSend == 0 { t26 }`)
			end

			return
		end

		if not p9 or #p9 == 0 then
			if p10 then
				p10(`Missing topicContentsEntries or topicContentsEntries == 0 { p9 }`)
			end

			return
		end

		if n2 then
			LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataHitCounter)
		else
			LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataMissingCounter)
		end

		local v100, v101 = addGameFields(t26, p9, n4, b1, n2, s4, t27)
		local v102 = Cryo.Dictionary.join(v100, {
			sortPos = n1,
			gameSetTypeId = s4,
			gameSetTargetId = n3,
			pageId = s5,
			componentType = s6,
			locale = LocalizationService.RobloxLocaleId,
			appliedFilters = s7,
			loadSource = s8,
			sortSubId = if not FFlagLuaAppAddSubIdToHomeEvents then nil else s9
		})

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v102.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p7, s3, v102)
		reportGameImpressionCounts(p8, s3, v101)
	end,
	sendFromSearch = function(p11, p12, t28: {[any]: any}, p13, s10: string, p14, p15, p16, b2: boolean?, s11: string?) -- line: 435
		-- upvalues: addGameFields (copy), FFlagLuaAppFixSearchImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p11 or not p12 then
			return
		end

		if not t28 or #t28 == 0 then
			return
		end

		if not p13 or #p13 == 0 then
			return
		end

		local v114, v115 = addGameFields(t28, p13, p15, b2, p16, nil, nil, if not FFlagLuaAppFixSearchImpressions then nil else p14, if not FFlagLuaAppFixSearchImpressions then nil else s10)
		local v116

		if FFlagLuaAppAddComponentTypeToSearchImpressions then
			v116 = Cryo.Dictionary.join(v114, p14, {
				locale = LocalizationService.RobloxLocaleId,
				componentType = s11
			})
		else
			v114.locale = LocalizationService.RobloxLocaleId
			v116 = Cryo.Dictionary.join(v114, p14)
		end

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v116.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p11, s10, v116)
		reportGameImpressionCounts(p12, s10, v115)
	end,
	sendFromGameDetails = function(p17, p18, t29: {[any]: any}, p19, p20) -- line: 488
		-- upvalues: addGameFields (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		local v123, v124 = addGameFields(t29, p19)

		v123.locale = LocalizationService.RobloxLocaleId
		v123.refId = p20

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v123.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p17, "recommended", v123)
		reportGameImpressionCounts(p18, "recommended", v124)
	end,
	sendFromSeeAll = function(p21, p22, t30: {[any]: any}, p23, s12: string, s13: string, n5: number?, s14: string?, s15: string?, b3: boolean?) -- line: 508
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p21 or not p22 then
			return
		end

		if not t30 or #t30 == 0 then
			return
		end

		if not p23 or #p23 == 0 then
			return
		end

		local v136, v137 = addGameFields(t30, p23, nil, b3)
		local v138 = Cryo.Dictionary.join(v136, {
			seeAllFlag = 1,
			gameSetTypeId = s13,
			gameSetTargetId = n5,
			pageId = s14,
			locale = LocalizationService.RobloxLocaleId,
			appliedFilters = s15
		})

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v138.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p21, s12, v138)
		reportGameImpressionCounts(p22, s12, v137, 1)
	end,
	sendFromInGameExitModal = if not FFlagEnableInGameExitModalNextUpUi then nil else if not FFlagEnableInGameExitModalNextUpUi then nil else function(p24, p25, s16: string, t31: {[any]: any}, t32: {[any]: any}) -- line: 556
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p24 or not p25 then
			return
		end

		if not t31 or #t31 == 0 then
			return
		end

		if not t32 or #t32 == 0 then
			return
		end

		local v145, v146 = addGameFields(t31, t32)
		local v147 = Cryo.Dictionary.join(v145, {
			gameSetTypeId = s16,
			locale = LocalizationService.RobloxLocaleId
		})

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v147.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p24, "InGameExitPage", v147)
		reportGameImpressionCounts(p25, "InGameExitPage", v146)
	end,
	sendFromTraversalHistoryPage = if not FFlagTraversalHistoryDiscoveryTelemetry then nil else function(p26, p27, t33: {[any]: any}, t34: {[any]: any}, n6: number, n7: number) -- line: 592
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p26 or not p27 then
			return
		end

		local v155, v156 = addGameFields(t33, t34, n6, false, n7)
		local v157 = Cryo.Dictionary.join(v155, {
			locale = LocalizationService.RobloxLocaleId
		})

		gameImpressionsEvent(p26, "InExpHistoryPage", v157)
		reportGameImpressionCounts(p27, "InExpHistoryPage", v156)
	end
}
