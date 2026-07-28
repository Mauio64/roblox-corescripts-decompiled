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
local FFlagTraversalHistoryDiscoveryTelemetry = require(GameCollectionsParent.SharedFlags).FFlagTraversalHistoryDiscoveryTelemetry
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagLuaAppAddSubIdToHomeEvents = require(GameCollectionsParent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppFixSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixSearchImpressions
local FFlagLuaAppGameImpressionsAddUnifiedFields = require(GameCollectionsParent.SharedFlags).FFlagLuaAppGameImpressionsAddUnifiedFields

local function addGameFields(t1: {[any]: any}, t2: {[any]: any}, p1, p2, p3, s1: string?, t3: {[any]: any}?, p4, s2: string?) -- line: 58
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
	local v54 = false

	for _, v in ipairs(t1) do
		local v57 = t2[v]

		if v57 ~= nil then
			if FFlagLuaAppFixSearchImpressions and v57.gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.Blank then
				DiscoveryEventErrorLogger.reportError("InvalidGameImpressionCollectionItemType", "An impression for a blank tile was attempted to be logged, which should not happen.", {
					entryIndex = v,
					pageContext = s2,
					emphasisFlag = if not p4 then nil else p4.emphasisFlag,
					sortPos = if not p4 then nil else p4.sortPos,
					gameSortId = s1
				})
			else
				local v58 = v57.uiIndex or v
				local v59 = v57.topicContentsIndex or v

				table.insert(t4, v57.placeId or 0)
				table.insert(t5, v)
				table.insert(t7, v57.universeId or 0)
				table.insert(t6, v59)

				if v57.isSponsored then
					v54 = true
					table.insert(t11, 1)
					table.insert(t12, v57.adId or 0)
				else
					table.insert(t11, 0)
					table.insert(t12, 0)
				end

				table.insert(t19, v57.gameCollectionItemTypeOverride or GameCollectionItemTypes.GameCollectionItemType.GameTile)

				local v60 = calculateRowPositionFields(v58, p1, p3)

				if p1 and p1 > 0 then
					table.insert(t13, v60.rowInSort)

					if p3 then
						table.insert(t14, v60.rowOnPage)
						table.insert(t15, v60.positionInRow)
					end
				else
					ArgCheck.assert(p1 ~= 0)

					if p3 then
						table.insert(t14, p3)
						table.insert(t15, v58)
					end
				end

				local v61 = getGameTileLayoutData(v57, s1)
				local v62 = getTileBadgeByPositionConfigFromEntry(v57) or v61.tileBadgesByPosition
				local tileBadgeIds = nil

				if v57.tileBadgeIds then
					tileBadgeIds = v57.tileBadgeIds
				elseif v62 then
					local t22 = {}

					for v65, v66 in (getValidTileBadges(v62)) do
						local v67 = Cryo.List.map(v66, function(p5) -- line: 175
							return p5.analyticsId
						end)

						if #v67 > 0 then
							table.insert(t22, v65 .. "=" .. table.concat(v67, "+"))
						end
					end

					if #t22 > 0 then
						tileBadgeIds = table.concat(t22, "&")
					end
				end

				table.insert(t16, tileBadgeIds or "0")

				if p2 then
					if v57 and v57.thumbnailAssetId then
						table.insert(t8, v57.thumbnailAssetId)
					else
						table.insert(t8, ((if not v57 or not v57.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(v61) else v57.primaryWideImageAssetId)) or (v57 and v57.primaryWideAssetId or nil) or "0")
					end

					if v57 and v57.thumbnailListId then
						table.insert(t9, v57.thumbnailListId)
					else
						table.insert(t9, ((if not v57 or not v57.primaryWideImageListId then v61 and (v61.primaryMediaAsset and v61.primaryMediaAsset.wideImageListId) else v57.primaryWideImageListId)) or (v57 and v57.primaryWideListId or "0"))
					end

					if v57 and v57.videoThumbnailAssetId then
						table.insert(t10, v57.videoThumbnailAssetId)
					else
						table.insert(t10, ((if not v57 or not v57.primaryWideVideoAssetId then v61 and (v61.primaryMediaAsset and v61.primaryMediaAsset.wideVideoAssetId) else v57.primaryWideVideoAssetId)) or "0")
					end

					local analytics = nil

					if v57 and v57.footer and v57.footer.analytics then
						analytics = v57.footer.analytics
					elseif v61 and v61.footer and v61.footer.analytics then
						analytics = v61.footer.analytics
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

				local analyticsData = v57.analyticsData

				if analyticsData then
					for v70 in analyticsData do
						t21[v70] = true
					end
				end

				table.insert(t20, analyticsData or {})
			end
		end
	end

	local v71 = #t4

	ArgCheck.assert(v71 == #t5)
	ArgCheck.assert(v71 == #t6)
	ArgCheck.assert(v71 == #t7)
	ArgCheck.assert(v71 == #t11)
	ArgCheck.assert(v71 == #t12)

	if #t13 > 0 then
		ArgCheck.assert(v71 == #t13)
	end

	if #t14 > 0 then
		ArgCheck.assert(v71 == #t14)
	end

	if #t15 > 0 then
		ArgCheck.assert(v71 == #t15)
	end

	local t23 = {
		rootPlaceIds = table.concat(t4, ","),
		absPositions = table.concat(t5, ","),
		topicDataPositions = table.concat(t6, ","),
		universeIds = table.concat(t7, ",")
	}

	if v54 then
		t23.adFlags = table.concat(t11, ",")
		t23.adIds = table.concat(t12, ",")
	end

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		t23.hasSponsoredContent = v54
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
		for v74 in t21 do
			local t25 = {}

			for _, v77 in t20 do
				table.insert(t25, v77[v74] or "0")
			end

			t24[`{ v74 }_arr`] = table.concat(t25, ",")
		end
	end

	local v78 = Cryo.Dictionary.join(t24, t3 or {})

	if next(v78) then
		t23.analyticsData = v78
	end

	return t23, v71
end
local function addMobileAdvertisingIdToEventParams(p6) -- line: 349
	-- upvalues: AppStorageService (copy)
	local Item = AppStorageService:GetItem("MobileAdvertisingId")

	if Item and Item ~= "" then
		p6.mobileAdvertisingId = Item
	end
end

return {
	sendFromTopicContents = function(p7, p8, t26: {[any]: any}, p9, s3: string, s4: string, n1: number, n2: number?, n3: number?, s5: string?, n4: number?, b1: boolean?, s6: string?, s7: string?, s8: string?, p10: ((...any) -> ...any)?, s9: string?, t27: {[any]: any}?) -- line: 356
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

		local v99, v100 = addGameFields(t26, p9, n4, b1, n2, s4, t27)
		local v101 = Cryo.Dictionary.join(v99, {
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
				v101.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p7, s3, v101)
		reportGameImpressionCounts(p8, s3, v100)
	end,
	sendFromSearch = function(p11, p12, t28: {[any]: any}, p13, s10: string, p14, p15, p16, b2: boolean?, s11: string?) -- line: 434
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

		local v113, v114 = addGameFields(t28, p13, p15, b2, p16, nil, nil, if not FFlagLuaAppFixSearchImpressions then nil else p14, if not FFlagLuaAppFixSearchImpressions then nil else s10)
		local v115

		if FFlagLuaAppAddComponentTypeToSearchImpressions then
			v115 = Cryo.Dictionary.join(v113, p14, {
				locale = LocalizationService.RobloxLocaleId,
				componentType = s11
			})
		else
			v113.locale = LocalizationService.RobloxLocaleId
			v115 = Cryo.Dictionary.join(v113, p14)
		end

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v115.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p11, s10, v115)
		reportGameImpressionCounts(p12, s10, v114)
	end,
	sendFromGameDetails = function(p17, p18, t29: {[any]: any}, p19, p20) -- line: 487
		-- upvalues: addGameFields (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		local v122, v123 = addGameFields(t29, p19)

		v122.locale = LocalizationService.RobloxLocaleId
		v122.refId = p20

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v122.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p17, "recommended", v122)
		reportGameImpressionCounts(p18, "recommended", v123)
	end,
	sendFromSeeAll = function(p21, p22, t30: {[any]: any}, p23, s12: string, s13: string, n5: number?, s14: string?, s15: string?, b3: boolean?) -- line: 507
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

		local v135, v136 = addGameFields(t30, p23, nil, b3)
		local v137 = Cryo.Dictionary.join(v135, {
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
				v137.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p21, s12, v137)
		reportGameImpressionCounts(p22, s12, v136, 1)
	end,
	sendFromTraversalHistoryPage = if not FFlagTraversalHistoryDiscoveryTelemetry then nil else function(p24, p25, t31: {[any]: any}, t32: {[any]: any}, n6: number, n7: number) -- line: 555
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p24 or not p25 then
			return
		end

		local v145, v146 = addGameFields(t31, t32, n6, false, n7)
		local v147 = Cryo.Dictionary.join(v145, {
			locale = LocalizationService.RobloxLocaleId
		})

		gameImpressionsEvent(p24, "InExpHistoryPage", v147)
		reportGameImpressionCounts(p25, "InExpHistoryPage", v146)
	end
}
