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
local FFlagLuaAppTileBadgeAnalyticsFix = require(GameCollectionsParent.SharedFlags).FFlagLuaAppTileBadgeAnalyticsFix
local FFlagLuaAppAddComponentTypeToSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppAddComponentTypeToSearchImpressions
local FFlagLuaAppAddSubIdToHomeEvents = require(GameCollectionsParent.SharedFlags).FFlagLuaAppAddSubIdToHomeEvents
local FFlagLuaAppFixSearchImpressions = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixSearchImpressions
local FFlagLuaAppGameImpressionsAddUnifiedFields = require(GameCollectionsParent.SharedFlags).FFlagLuaAppGameImpressionsAddUnifiedFields

local function addGameFields(t1: {[any]: any}, t2: {[any]: any}, p1, p2, p3, s1: string?, t3: {[any]: any}?, p4, s2: string?) -- line: 60
	-- upvalues: FFlagLuaAppFixSearchImpressions (copy), GameCollectionItemTypes (copy), DiscoveryEventErrorLogger (copy), calculateRowPositionFields (copy), ArgCheck (copy), FFlagLuaAppTileBadgeAnalyticsFix (copy), getGameTileLayoutData (copy), getTileBadgeByPositionConfigFromEntry (copy), getValidTileBadges (copy), Cryo (copy), ItemLayoutDataParsingUtils (copy), FFlagLuaAppGameImpressionsAddUnifiedFields (copy)
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
	local v56 = false

	for _, v in ipairs(t1) do
		local v59 = t2[v]

		if v59 ~= nil then
			if FFlagLuaAppFixSearchImpressions and v59.gameCollectionItemTypeOverride == GameCollectionItemTypes.GameCollectionItemType.Blank then
				DiscoveryEventErrorLogger.reportError("InvalidGameImpressionCollectionItemType", "An impression for a blank tile was attempted to be logged, which should not happen.", {
					entryIndex = v,
					pageContext = s2,
					emphasisFlag = if not p4 then nil else p4.emphasisFlag,
					sortPos = if not p4 then nil else p4.sortPos,
					gameSortId = s1
				})
			else
				local v60 = v59.uiIndex or v
				local v61 = v59.topicContentsIndex or v

				table.insert(t4, v59.placeId or 0)
				table.insert(t5, v)
				table.insert(t7, v59.universeId or 0)
				table.insert(t6, v61)

				if v59.isSponsored then
					v56 = true
					table.insert(t11, 1)
					table.insert(t12, v59.adId or 0)
				else
					table.insert(t11, 0)
					table.insert(t12, 0)
				end

				table.insert(t19, v59.gameCollectionItemTypeOverride or GameCollectionItemTypes.GameCollectionItemType.GameTile)

				local v62 = calculateRowPositionFields(v60, p1, p3)

				if p1 and p1 > 0 then
					table.insert(t13, v62.rowInSort)

					if p3 then
						table.insert(t14, v62.rowOnPage)
						table.insert(t15, v62.positionInRow)
					end
				else
					ArgCheck.assert(p1 ~= 0)

					if p3 then
						table.insert(t14, p3)
						table.insert(t15, v60)
					end
				end

				local t22 = {}

				if FFlagLuaAppTileBadgeAnalyticsFix then
					t22 = getGameTileLayoutData(v59, s1)

					local v64 = getTileBadgeByPositionConfigFromEntry(v59) or t22.tileBadgesByPosition
					local tileBadgeIds = nil

					if v59.tileBadgeIds then
						tileBadgeIds = v59.tileBadgeIds
					elseif v64 then
						local t23 = {}

						for v67, v68 in (getValidTileBadges(v64)) do
							local v69 = Cryo.List.map(v68, function(p5) -- line: 179
								return p5.analyticsId
							end)

							if #v69 > 0 then
								table.insert(t23, v67 .. "=" .. table.concat(v69, "+"))
							end
						end

						if #t23 > 0 then
							tileBadgeIds = table.concat(t23, "&")
						end
					end

					table.insert(t16, tileBadgeIds or "0")
				end

				if p2 then
					if not FFlagLuaAppTileBadgeAnalyticsFix then
						t22 = getGameTileLayoutData(v59, s1)
					end

					if v59 and v59.thumbnailAssetId then
						table.insert(t8, v59.thumbnailAssetId)
					else
						table.insert(t8, ((if not v59 or not v59.primaryWideImageAssetId then ItemLayoutDataParsingUtils.getWideImageAssetId(t22) else v59.primaryWideImageAssetId)) or (v59 and v59.primaryWideAssetId or nil) or "0")
					end

					if v59 and v59.thumbnailListId then
						table.insert(t9, v59.thumbnailListId)
					else
						table.insert(t9, ((if not v59 or not v59.primaryWideImageListId then t22 and (t22.primaryMediaAsset and t22.primaryMediaAsset.wideImageListId) else v59.primaryWideImageListId)) or (v59 and v59.primaryWideListId or "0"))
					end

					if v59 and v59.videoThumbnailAssetId then
						table.insert(t10, v59.videoThumbnailAssetId)
					else
						table.insert(t10, ((if not v59 or not v59.primaryWideVideoAssetId then t22 and (t22.primaryMediaAsset and t22.primaryMediaAsset.wideVideoAssetId) else v59.primaryWideVideoAssetId)) or "0")
					end

					if not FFlagLuaAppTileBadgeAnalyticsFix then
						local tileBadgeIds = nil

						if v59 and v59.tileBadgeIds then
							tileBadgeIds = v59.tileBadgeIds
						elseif t22 and t22.tileBadgesByPosition then
							local t24 = {}

							for v72, v73 in (getValidTileBadges(t22.tileBadgesByPosition)) do
								local v74 = Cryo.List.map(v73, function(p6) -- line: 256
									return p6.analyticsId
								end)

								if #v74 > 0 then
									table.insert(t24, v72 .. "=" .. table.concat(v74, "+"))
								end
							end

							if #t24 > 0 then
								tileBadgeIds = table.concat(t24, "&")
							end
						end

						table.insert(t16, tileBadgeIds or "0")
					end

					local analytics = nil

					if v59 and v59.footer and v59.footer.analytics then
						analytics = v59.footer.analytics
					elseif t22 and t22.footer and t22.footer.analytics then
						analytics = t22.footer.analytics
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

				local analyticsData = v59.analyticsData

				if analyticsData then
					for v77 in analyticsData do
						t21[v77] = true
					end
				end

				table.insert(t20, analyticsData or {})
			end
		end
	end

	local v78 = #t4

	ArgCheck.assert(v78 == #t5)
	ArgCheck.assert(v78 == #t6)
	ArgCheck.assert(v78 == #t7)
	ArgCheck.assert(v78 == #t11)
	ArgCheck.assert(v78 == #t12)

	if #t13 > 0 then
		ArgCheck.assert(v78 == #t13)
	end

	if #t14 > 0 then
		ArgCheck.assert(v78 == #t14)
	end

	if #t15 > 0 then
		ArgCheck.assert(v78 == #t15)
	end

	local t25 = {
		rootPlaceIds = table.concat(t4, ","),
		absPositions = table.concat(t5, ","),
		topicDataPositions = table.concat(t6, ","),
		universeIds = table.concat(t7, ",")
	}

	if v56 then
		t25.adFlags = table.concat(t11, ",")
		t25.adIds = table.concat(t12, ",")
	end

	if FFlagLuaAppGameImpressionsAddUnifiedFields then
		t25.hasSponsoredContent = v56
	end

	if #t13 > 0 then
		t25.rows = table.concat(t13, ",")
	end

	if #t14 > 0 then
		t25.rowsOnPage = table.concat(t14, ",")
	end

	if #t15 > 0 then
		t25.positionsInRows = table.concat(t15, ",")
	end

	if p2 and #t8 > 0 then
		t25.thumbnailAssetIds = table.concat(t8, ",")
	end

	if p2 and #t9 > 0 then
		t25.thumbnailListIds = table.concat(t9, ",")
	end

	if p2 and #t10 > 0 then
		t25.videoThumbnailAssetIds = table.concat(t10, ",")
	end

	if FFlagLuaAppTileBadgeAnalyticsFix and #t16 > 0 or not FFlagLuaAppTileBadgeAnalyticsFix and p2 and #t16 > 0 then
		t25.tileBadgeContexts = table.concat(t16, ",")
	end

	if t17 and #t17 > 0 then
		t25.footerTextLiterals = table.concat(t17, ",")
	end

	if t18 and #t18 > 0 then
		t25.footerLocalizationKeys = table.concat(t18, ",")
	end

	if #t19 > 0 then
		t25.tileTypes = table.concat(t19, ",")
	end

	local t26 = {}

	if next(t21) then
		for v81 in t21 do
			local t27 = {}

			for _, v84 in t20 do
				table.insert(t27, v84[v81] or "0")
			end

			t26[`{ v81 }_arr`] = table.concat(t27, ",")
		end
	end

	local v85 = Cryo.Dictionary.join(t26, t3 or {})

	if next(v85) then
		t25.analyticsData = v85
	end

	return t25, v78
end
local function addMobileAdvertisingIdToEventParams(p7) -- line: 397
	-- upvalues: AppStorageService (copy)
	local Item = AppStorageService:GetItem("MobileAdvertisingId")

	if Item and Item ~= "" then
		p7.mobileAdvertisingId = Item
	end
end

return {
	sendFromTopicContents = function(p8, p9, t28: {[any]: any}, p10, s3: string, s4: string, n1: number, n2: number?, n3: number?, s5: string?, n4: number?, b1: boolean?, s6: string?, s7: string?, s8: string?, p11: ((...any) -> ...any)?, s9: string?, t29: {[any]: any}?) -- line: 404
		-- upvalues: LoggingProtocol (copy), FeedItemRowDataHitCounter (copy), FeedItemRowDataMissingCounter (copy), addGameFields (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppAddSubIdToHomeEvents (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p8 or not p9 then
			if p11 then
				p11(`Missing analytics service eventIngest: { p8 } appAnalytics: { p9 }`)
			end

			return
		end

		if not t28 or #t28 == 0 then
			if p11 then
				p11(`Missing impressionsToSend or impressionsToSend == 0 { t28 }`)
			end

			return
		end

		if not p10 or #p10 == 0 then
			if p11 then
				p11(`Missing topicContentsEntries or topicContentsEntries == 0 { p10 }`)
			end

			return
		end

		if n2 then
			LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataHitCounter)
		else
			LoggingProtocol.default:logRobloxTelemetryCounter(FeedItemRowDataMissingCounter)
		end

		local v106, v107 = addGameFields(t28, p10, n4, b1, n2, s4, t29)
		local v108 = Cryo.Dictionary.join(v106, {
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
				v108.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p8, s3, v108)
		reportGameImpressionCounts(p9, s3, v107)
	end,
	sendFromSearch = function(p12, p13, t30: {[any]: any}, p14, s10: string, p15, p16, p17, b2: boolean?, s11: string?) -- line: 482
		-- upvalues: addGameFields (copy), FFlagLuaAppFixSearchImpressions (copy), FFlagLuaAppAddComponentTypeToSearchImpressions (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p12 or not p13 then
			return
		end

		if not t30 or #t30 == 0 then
			return
		end

		if not p14 or #p14 == 0 then
			return
		end

		local v120, v121 = addGameFields(t30, p14, p16, b2, p17, nil, nil, if not FFlagLuaAppFixSearchImpressions then nil else p15, if not FFlagLuaAppFixSearchImpressions then nil else s10)
		local v122

		if FFlagLuaAppAddComponentTypeToSearchImpressions then
			v122 = Cryo.Dictionary.join(v120, p15, {
				locale = LocalizationService.RobloxLocaleId,
				componentType = s11
			})
		else
			v120.locale = LocalizationService.RobloxLocaleId
			v122 = Cryo.Dictionary.join(v120, p15)
		end

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v122.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p12, s10, v122)
		reportGameImpressionCounts(p13, s10, v121)
	end,
	sendFromGameDetails = function(p18, p19, t31: {[any]: any}, p20, p21) -- line: 535
		-- upvalues: addGameFields (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		local v129, v130 = addGameFields(t31, p20)

		v129.locale = LocalizationService.RobloxLocaleId
		v129.refId = p21

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v129.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p18, "recommended", v129)
		reportGameImpressionCounts(p19, "recommended", v130)
	end,
	sendFromSeeAll = function(p22, p23, t32: {[any]: any}, p24, s12: string, s13: string, n5: number?, s14: string?, s15: string?, b3: boolean?) -- line: 555
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p22 or not p23 then
			return
		end

		if not t32 or #t32 == 0 then
			return
		end

		if not p24 or #p24 == 0 then
			return
		end

		local v142, v143 = addGameFields(t32, p24, nil, b3)
		local v144 = Cryo.Dictionary.join(v142, {
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
				v144.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p22, s12, v144)
		reportGameImpressionCounts(p23, s12, v143, 1)
	end,
	sendFromInGameExitModal = if not FFlagEnableInGameExitModalNextUpUi then nil else if not FFlagEnableInGameExitModalNextUpUi then nil else function(p25, p26, s16: string, t33: {[any]: any}, t34: {[any]: any}) -- line: 603
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), FFlagLuaAppGameImpressionsMobileAdsId (copy), AppStorageService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p25 or not p26 then
			return
		end

		if not t33 or #t33 == 0 then
			return
		end

		if not t34 or #t34 == 0 then
			return
		end

		local v151, v152 = addGameFields(t33, t34)
		local v153 = Cryo.Dictionary.join(v151, {
			gameSetTypeId = s16,
			locale = LocalizationService.RobloxLocaleId
		})

		if FFlagLuaAppGameImpressionsMobileAdsId then
			local Item = AppStorageService:GetItem("MobileAdvertisingId")

			if Item and Item ~= "" then
				v153.mobileAdvertisingId = Item
			end
		end

		gameImpressionsEvent(p25, "InGameExitPage", v153)
		reportGameImpressionCounts(p26, "InGameExitPage", v152)
	end,
	sendFromTraversalHistoryPage = if not FFlagTraversalHistoryDiscoveryTelemetry then nil else function(p27, p28, t35: {[any]: any}, t36: {[any]: any}, n6: number, n7: number) -- line: 639
		-- upvalues: addGameFields (copy), Cryo (copy), LocalizationService (copy), gameImpressionsEvent (copy), reportGameImpressionCounts (copy)
		if not p27 or not p28 then
			return
		end

		local v161, v162 = addGameFields(t35, t36, n6, false, n7)
		local v163 = Cryo.Dictionary.join(v161, {
			locale = LocalizationService.RobloxLocaleId
		})

		gameImpressionsEvent(p27, "InExpHistoryPage", v163)
		reportGameImpressionCounts(p28, "InExpHistoryPage", v162)
	end
}
