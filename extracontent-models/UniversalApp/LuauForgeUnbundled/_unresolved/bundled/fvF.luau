local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local Dash = require(CorePackages.Packages.Dash)

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fvG")
local module2 = require("@luauforge/bundled/fvH")
local module3 = require("@luauforge/bundled/fvI")

local module4 = require("@luauforge/bundled/fvJ")
local module5 = require("@luauforge/bundled/fvK")
local module6 = require("@luauforge/bundled/fvN")
local module7 = require("@luauforge/bundled/fvO")
local module8 = require("@luauforge/bundled/fvP")
local module9 = require("@luauforge/bundled/fvQ")
local module10 = require("@luauforge/bundled/fvR")
local module11 = require("@luauforge/bundled/fvS")
local module12 = require("@luauforge/bundled/fvT")
local module13 = require("@luauforge/bundled/dME")
local module14 = require("@luauforge/bundled/dMx")
local widgetConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").WidgetConstants
require("@luauforge/bundled/dMq")
require("@luauforge/bundled/dMr")
require("@luauforge/bundled/dMp")
require("@luauforge/bundled/dMc")

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local UserInputService = game:GetService("UserInputService")

local module15 = require("@luauforge/bundled/dRQ")

local analyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AnalyticsService
local module16 = require("@luauforge/bundled/dMx")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local constants = AvatarExperienceAnalytics.Constants
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local contexts = require("@luauforge/bundled/dYV").Analytics.Enums.Contexts
local components = require("@luauforge/bundled/eef").Components

local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformEnableStore
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging

local fFlagAXFixUnifiedPurchaseFieldLanding = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixUnifiedPurchaseFieldLanding

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local fFlagAXRecommendedItemsUnifiedSelectParity = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRecommendedItemsUnifiedSelectParity

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads
local aliasSortAndFiltersToLegacyKeys = AvatarExperienceAnalytics.Utils.aliasSortAndFiltersToLegacyKeys
local isSpatial = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isSpatial

local v5 = {
	[avatarScreen.Catalog] = impressionEnums.MarketplaceSurfaceType.HOMEPAGE,
	[avatarScreen.CatalogSearch] = impressionEnums.MarketplaceSurfaceType.SEARCH,
	[avatarScreen.ItemDetails] = impressionEnums.MarketplaceSurfaceType.ITEM_DETAIL,
	[avatarScreen.AvatarEditor] = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
	[avatarScreen.MySharedAvatars] = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
	[avatarScreen.ProfilePictureEditorEmotes] = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
	[contexts.CommunityProfile] = impressionEnums.MarketplaceSurfaceType.COMMUNITY_PROFILE,
	[contexts.PlayerProfile] = impressionEnums.MarketplaceSurfaceType.USER_PROFILE
}

local CURRENTLY_WEARINGsByCurrentlyWearing = {
	[components.CurrentlyWearing] = impressionEnums.RecommendationSurfaceType.CURRENTLY_WEARING
}

local v6 = {
	ITEM_DETAIL_REFERRAL = "itemDetailReferral",
	PURCHASE_ASSET = "purchaseAsset",
	PURCHASE_BUNDLE = "purchaseBundle",
	TRY_ON_AVATAR_ITEM = "tryOnAvatarItem",
	BUTTON_CLICK = "buttonClick",
	CATALOG_IMPRESSIONS = "catalogImpressions",
	SELECT_CATALOG_TOPIC = "selectCatalogTopic",
	DESELECT_CATALOG_TOPIC = "deselectCatalogTopic",
	CLEAR_ALL_TOPICS = "clearAllTopics",
	CHARACTER_BUNDLE_SWAP_ACTION = "characterBundleSwapAction",
	OPEN_ITEM_DETAILS = "openItemDetails",
	OPEN_OUTFIT_SCREEN = "openOutfitScreen",
	AVATAR_SHOP_EQUIP = "avatarShopEquip",
	AVATAR_SHOP_UNEQUIP = "avatarShopUnequip",
	AVATAR_SHOP_BUY_ITEM = "avatarShopBuyItem",
	AVATAR_SHOP_BUY_OUTFIT = "avatarShopBuyOutfit",
	AVATAR_SHOP_LEAVE = "avatarShopLeave",
	WIDGET_API_FE_LOG = "widgetApiFELog",
	LEGACY_WIDGET_API_FE_LOG = "legacyWidgetApiFELog",
	MARKETPLACE_ORGANIC_FE_LOG = "marketplaceOrganicFELog",
	CONFIRM_DELETE_AVATAR = "confirmDeleteAvatar",
	CONFIRM_SHARE_COMMUNITY_AVATAR = "confirmShareCommunityAvatar"
}

local v8 = nil

local function getCategoryNameById(p2)
	return (if p2 then module15.getCategoryNameById(p2) else nil) or ""
end

local function getSubcategoryNameById(p2, p3)
	return (if p2 and p3 then module15.getSubcategoryNameById(p2, p3) else nil) or ""
end

local function getAXCounterV2Metadata(items)
	local platform = UserInputService:GetPlatform()
	local v9 = isSpatial() and "VR" or platform

	local v10 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = v9
	}

	if items and next(items) ~= nil then
		v10 = Dash.assign({}, v10, items)
	end

	return v10
end

return {
	get = function(p2)
		if v8 then
			return v8
		end

		local v9 = analyticsService

		local v10 = {}

		function v10.clickCatalogItem(p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15)
			local v12 = (if p5 then module15.getCategoryNameById(p5) else nil) or ""

			local v13 = if p5 and p6 then module15.getSubcategoryNameById(p5, p6) else nil

			module6(v9.EventStream, p3, p4, v12, v13 or "", p7, p8, p9, p10, p11, p12, p13, p14, p15)
		end

		function v10.clickCatalogItemFromProfile(p3, p4, p5, p6, p7, p8)
			local v11 = {
				feature = module14.ProfileAnalyticsTag,
				itemID = p4,
				itemType = p5,
				subpage = not fFlagProfilePlatformEnableStore and "peekView" or p6,
				page = "playerProfile"
			}

			local enumMap = organicEventImpressionsSchema.defaultItem.enumMap
			local v12 = if enumMap and enumMap.contentType then enumMap.contentType[p5] else nil

			local v13 = {
				itemId = p4,
				actionType = impressionEnums.ActionType.CLICK_ITEM_DETAIL,
				contentType = v12,
				price = 0,
				surface = v5[p3],
				recommendationSurface = CURRENTLY_WEARINGsByCurrentlyWearing[p6],
				absPositions = p7
			}

			v9.EventStream:sendTelemetryEvent(p3, "marketplaceOrganicFELog", v13)

			v9.EventStream:sendTelemetryEvent(p3, "itemDetailReferral", v11)

			if fFlagAXRecommendedItemsUnifiedSelectParity then
				local v15 = if fFlagAXUnifiedEventStrictPayloads then AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog else AvatarExperienceAnalytics.sendUnifiedEventLog
				module12(v15, p3, p4, p5, p7)
			end
		end

		function v10.purchaseAsset(p3, p4, p5, p6, p7, p8)
			module10(v9.EventStream, "purchaseAsset", p3, p4, p5, p6, p7, p8)

			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXPurchaseAsset)
		end

		function v10.purchaseBundle(p3, p4, p5, p6, p7)
			module11(v9.EventStream, "purchaseBundle", p3, p4, p5, p6, p7)

			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXPurchaseBundle)
		end

		function v10.homepageWidgetItemClick(item_id, item_type)
			local v11 = {
				actionType = impressionEnums.ActionType.UI_BUTTON_CLICK,
				group = "HomePageAvatarWidgetClick",
				surface = impressionEnums.MarketplaceSurfaceType.HOMEPAGE
			}

			v11.item_id = item_id
			v11.item_type = item_type

			v11.event_sender_api = impressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
			v9.EventStream:sendTelemetryEvent("HomeTryOnScreen", "marketplaceOrganicFELog", v11)
		end

		function v10.sendCounter(p3)
			reportAvatarEventCounterV1(p3)
		end

		function v10.sendAXCounter(p3, p4, p5)
			reportAvatarEventCounterV1(module16.Counter.PREFIX .. p3)

			if p4 then
				v10.sendAXCounterV2(p3, p5)
			end
		end

		function v10.sendAXCounterV2(p3, p4)
			default:logRobloxTelemetryCounter({
				eventName = module14.Counter.PREFIX .. p3,
				backends = { "RobloxTelemetryCounter" },
				lastUpdated = { 2024, 4, 30 },
				description = "Counter to track various Avatar Experience events.",
				links = "https://roblox.atlassian.net/wiki/spaces/AMSD/pages/2800779286/Tech+Spec+-+Q3+Grafana+Dashboard+Improvements"
			}, 1, getAXCounterV2Metadata(p4))
		end

		function v10.sendAXStat(p3, p4, p5)
			default:logRobloxTelemetryStat({
				eventName = "AXStat_" .. p3,
				backends = { "RobloxTelemetryStat" },
				lastUpdated = { 2024, 4, 30 },
				description = "Stat to track various Avatar Experience events.",
				links = "https://roblox.atlassian.net/wiki/spaces/AMSD/pages/2800779286/Tech+Spec+-+Q3+Grafana+Dashboard+Improvements"
			}, p4, getAXCounterV2Metadata(p5))
		end

		function v10.clickNavigationTab(p3, p4)
			local v12 = (if p3 then module15.getCategoryNameById(p3) else nil) or ""

			local v13 = if p3 and p4 then module15.getSubcategoryNameById(p3, p4) else nil

			module5(v9.EventStream, "clickNavigationTab", v12, v13 or "")
		end

		function v10.catalogSearch(p3, p4, p5, p6, p7, p8)
			module3(v9.EventStream, p3, p4, p8, p5, p6, p7)
		end

		function v10.clickCustomizeAvatarFromItemDetailPage()
			module4(v9.EventStream, "clickCustomizeAvatarFromItemDetailPage")
		end

		function v10.closeItemDetailPage(p3, p4)
			module7(v9.EventStream, "closeItemDetailPage", p3, p4)
		end

		function v10.expandItemDetailPage(p3, p4)
			module8(v9.EventStream, "expandItemDetailPage", p3, p4)
		end

		function v10.avatarToCatalogButton()
			module(v9.EventStream, "avatarToCatalogButton")
		end

		function v10.moreMenuToCatalogButton()
			module9(v9.EventStream, "moreMenuToCatalogButton")
		end

		function v10.catalogOpenedFromLandingPage()
			module2(v9.EventStream, "catalogOpenedFromLandingPage")
		end

		function v10.clickPurchaseItemButton(p3, p4, p5, p6, p7, p8, p9, data, p10, p11)
			local enumMap = organicEventImpressionsSchema.defaultItem.enumMap
			local v11 = if enumMap and enumMap.contentType then enumMap.contentType[p4] else nil

			local v12 = module14.AnalyticsTag
			local v13 = nil
			local v14 = nil

			if p5 then
				v12 = module14.ProfileAnalyticsTag
				v14 = "peekView"
				v13 = "playerProfile"
			elseif p10 then
				v12 = module14.ContentFeedAnalyticsTag
				v13 = "contentFeed"
			end

			if fFlagAXFixUnifiedPurchaseFieldLanding then
				data = aliasSortAndFiltersToLegacyKeys(data)
			end

			local v15 = {
				feature = v12,
				btn = "PriceButton",
				itemId = p3,
				actionType = impressionEnums.ActionType.PURCHASE_ATTEMPT,
				contentType = v11,
				requestId = p7,
				subpage = v14,
				page = v13,
				keyword = p8,
				surface = 0,
				sort = 0,
				filterSalesType = 0,
				filterCreators = 0,
				filterPrice = 0,
				filterUnavailableItems = 0,
				filterCreatorsName = 0,
				filterPriceMin = 0,
				filterPriceMax = 0
			}

			local v16 = if fFlagAXFixPurchaseSurfaceLogging then p11 or v5[p6] else v5[p6]
			v15.surface = v16

			v15.sort = data.sortEnumValue
			v15.filterSalesType = data.filterSalesTypeEnumValue
			v15.filterCreators = data.filterCreatorsTypeEnumValue
			v15.filterPrice = data.filterPriceEnumValue
			v15.filterUnavailableItems = data.filterUnavailableItemsEnumValue
			v15.filterCreatorsName = data.filterCreatorsName
			v15.filterPriceMin = data.filterPriceMin
			v15.filterPriceMax = data.filterPriceMax

			v9.EventStream:sendTelemetryEvent(
				"itemDetailPageBottomButtonClick",
				"marketplaceOrganicFELog",
				v15
			)
			v9.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", {
				feature = v12,
				btn = "PriceButton",
				itemID = p3,
				itemType = p4,
				subpage = v14,
				page = v13,
				fromScreen = p6
			})

			if p9 then
				local v17 = {
					feature = v12,
					btn = "PriceButton",
					itemID = p3,
					itemType = p4,
					subpage = v14,
					page = v13,
					fromScreen = p6,
					refineSessionId = RbxAnalyticsService:GetSessionId()
				}

				v9.EventStream:sendTelemetryEvent(
					"itemDetailPageBottomButtonClick",
					"buttonClickHasAccessoryAdjustment",
					v17
				)
			end
		end

		function v10.shownEnableTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseShownEnableTwoStepAuth)
		end

		function v10.shownTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseShownTwoStepAuth)
		end

		function v10.failedShowTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseFailedShowTwoStepAuth)
		end

		function v10.completedTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseCompletedTwoStepAuth)
		end

		function v10.invalidatedTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseInvalidatedTwoStepAuth)
		end

		function v10.abandonedTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseAbandonedTwoStepAuth)
		end

		function v10.loadFailedTwoStepAuthOnPurchase()
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseLoadFailedTwoStepAuth)
		end

		function v10.clickCustomizeItemButton(p3, p4)
			local v11 = {
				feature = module14.AnalyticsTag,
				itemID = p3,
				itemType = p4,
				btn = "Customize",
				cstm = "Shop"
			}

			v9.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", v11)
		end

		function v10.clickFavoriteItemButton(p3, p4, p5)
			local v11 = {
				feature = module14.AnalyticsTag,
				itemID = p3,
				itemType = p4,
				btn = "Favorite",
				cstm = "Shop",
				checked = p5
			}

			v9.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", v11)
		end

		function v10.clickShareItemButton(p3, p4)
			local v11 = {
				feature = module14.AnalyticsTag,
				itemID = p3,
				itemType = p4,
				btn = "Share",
				cstm = "Shop"
			}

			v9.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", v11)
		end

		function v10.applySortAndFilters(data)
			local v11 = {
				feature = module14.AnalyticsTag,
				btn = "Apply",
				minPrice = data.minPrice,
				maxPrice = data.maxPrice,
				sortType = data.sortType,
				sortAggregation = data.sortAggregation,
				salesTypeFilter = data.salesTypeFilter,
				creatorFilter = data.creatorFilter,
				includeOffSale = data.includeOffSale,
				specialFeaturesFilter = 0
			}

			local v12 = if fFlagAXCatalogSpecialFeaturesFilter then data.specialFeaturesFilter else nil
			v11.specialFeaturesFilter = v12

			v9.EventStream:sendTelemetryEvent("SortAndFilters", "buttonClick", v11)
		end

		function v10.applyPriceFilter(p3, p4)
			local v11 = {
				feature = module14.AnalyticsTag,
				btn = "Apply",
				PriceLowerBound = p3,
				PriceUpperBound = p4
			}

			v9.EventStream:sendTelemetryEvent("PriceFilter", "buttonClick", v11)
		end

		function v10.navigateToProfile(p3)
			reportAvatarEventCounterV1(p3 .. "LuaProfile")
			local v11 = {
				feature = module14.ProfileAnalyticsTag,
				btn = "creator",
				subpage = "peekView",
				page = "playerProfile"
			}

			v9.EventStream:sendTelemetryEvent(p3, "buttonClick", v11)
		end

		function v10.selectTopic(p3, rank, p4, p5, query, list, list2)
			local catalog = module13.AnalyticsContext.Catalog
			local v12 = (if p4 then module15.getCategoryNameById(p4) else nil) or ""

			local v14 = (if p4 and p5 then module15.getSubcategoryNameById(p4, p5) else nil) or ""

			local v16 = if list then table.concat(list, ",") else nil
			local v17 = if list2 then table.concat(list2, ",") else nil
			v9.EventStream:sendTelemetryEvent(catalog, "selectCatalogTopic", {
				topic = p3,
				allTopics = v16,
				previousSelectedTopics = v17,
				rank = rank,
				category = v12,
				subcategory = v14,
				query = query
			})
		end

		function v10.openItemDetails(p3, p4, p5, p6)
			local avatarShop = module13.AnalyticsContext.AvatarShop

			v9.EventStream:sendTelemetryEvent(avatarShop, "openItemDetails", {
				assetId = p3,
				assetType = p4,
				price = p5,
				entryPoint = p6
			})
		end

		function v10.openItemDetailsV2(p3, p4, p5, p6, p7, p8, p9, p10, data)
			local avatarShop = module13.AnalyticsContext.AvatarShop
			local enumMap = organicEventImpressionsSchema.defaultItem.enumMap
			local v11 = if enumMap and enumMap.contentType then enumMap.contentType[p4] else nil

			if fFlagAXFixUnifiedPurchaseFieldLanding then
				data = aliasSortAndFiltersToLegacyKeys(data)
			end

			local v12 = {
				itemId = p3,
				actionType = impressionEnums.ActionType.CLICK_ITEM_DETAIL,
				contentType = v11,
				price = p5,
				surface = v5[p6],
				requestId = p7,
				absPositions = data.selectedItemIndex,
				keyword = p8,
				category = p9,
				subcategory = p10,
				sort = data.sortEnumValue,
				filterSalesType = data.filterSalesTypeEnumValue,
				filterCreators = data.filterCreatorsTypeEnumValue,
				filterPrice = data.filterPriceEnumValue,
				filterUnavailableItems = data.filterUnavailableItemsEnumValue,
				filterCreatorsName = data.filterCreatorsName,
				filterPriceMin = data.filterPriceMin,
				filterPriceMax = data.filterPriceMax
			}

			v9.EventStream:sendTelemetryEvent(avatarShop, "marketplaceOrganicFELog", v12)
		end

		function v10.resizeOutfitScreen(p3)
			local avatarShop = module13.AnalyticsContext.AvatarShop

			v9.EventStream:sendTelemetryEvent(avatarShop, "openOutfitScreen", {
				stateChange = p3
			})
		end

		function v10.avatarShopBuyItem(p3, p4, p5, p6, requestId, keyword, category, subcategory, data, p7)
			local avatarShop = module13.AnalyticsContext.AvatarShop

			local enumMap = organicEventImpressionsSchema.defaultItem.enumMap
			local v11 = if enumMap and enumMap.contentType then enumMap.contentType[p4] else nil

			if fFlagAXFixUnifiedPurchaseFieldLanding then
				data = aliasSortAndFiltersToLegacyKeys(data)
			end

			local eventStream = v9.EventStream
			local v13 = {
				itemId = p3,
				actionType = impressionEnums.ActionType.PURCHASE_SUCCESS,
				contentType = v11,
				price = p5,
				surface = 0,
				requestId = 0,
				absPositions = 0,
				sort = 0,
				filterSalesType = 0,
				filterCreators = 0,
				filterPrice = 0,
				filterUnavailableItems = 0,
				filterCreatorsName = 0,
				filterPriceMin = 0,
				filterPriceMax = 0,
				keyword = 0,
				category = 0,
				subcategory = 0
			}

			local v14 = if fFlagAXFixPurchaseSurfaceLogging then p7 or v5[p6] else v5[p6]
			v13.surface = v14

			v13.requestId = requestId
			v13.absPositions = data.selectedItemIndex
			v13.sort = data.sortEnumValue
			v13.filterSalesType = data.filterSalesTypeEnumValue
			v13.filterCreators = data.filterCreatorsTypeEnumValue
			v13.filterPrice = data.filterPriceEnumValue
			v13.filterUnavailableItems = data.filterUnavailableItemsEnumValue
			v13.filterCreatorsName = data.filterCreatorsName
			v13.filterPriceMin = data.filterPriceMin
			v13.filterPriceMax = data.filterPriceMax
			v13.keyword = keyword
			v13.category = category
			v13.subcategory = subcategory
			eventStream:sendEventImmediately(avatarShop, "marketplaceOrganicFELog", v13)
		end

		function v10.widgetInteraction(p3, p4, p5, p6, p7, p8, p9)
			v9.EventStream:sendTelemetryEvent("catalog", "widgetApiFELog", {
				request_id = p3,
				action_type = p4,
				item_position = p5,
				widget_position = p6,
				item_id = p7,
				item_type = p8,
				widget_id = p9
			})
		end

		function v10.widgetInteractionV2(data, p3)
			local v11 = p3 == widgetConstants.ActionType.PURCHASE_SUCCESS

			local v13 = {
				action_type = p3,
				request_id = data.requestId,
				item_position = data.itemPosition,
				widget_position = data.widgetPosition,
				item_id = data.itemId,
				item_type = data.itemType,
				look_type = 0,
				widget_id = 0,
				widget_type = 0,
				widget_abs_position = 0,
				widget_item_ids = 0,
				kwd = 0,
				organic_result_ids = 0,
				time_spent_sec = 0,
				asset_ids = 0,
				bundle_ids = 0,
				total_robux = 0,
				ui_treatment_type = 0
			}
			local v14 = if data.lookType then ({
				Outfit = "1",
				Avatar = "2",
				Makeup = "3"
			})[data.lookType] else nil
			v13.look_type = v14
			v13.widget_id = data.widgetId
			v13.widget_type = data.widgetType
			v13.widget_abs_position = data.widgetAbsPosition
			local v15 = if data.widgetItemIds then table.concat(data.widgetItemIds, ",") else nil
			v13.widget_item_ids = v15

			v13.kwd = data.query
			local v16 = if data.organicResultIds then table.concat(data.organicResultIds, ",") else nil
			v13.organic_result_ids = v16

			v13.time_spent_sec = data.timeSpentSec
			local v17 = if data.assetIds then table.concat(data.assetIds, ",") else nil
			v13.asset_ids = v17
			local v18 = if data.bundleIds then table.concat(data.bundleIds, ",") else nil
			v13.bundle_ids = v18

			v13.total_robux = data.totalRobux
			v13.ui_treatment_type = data.uiTreatmentType

			if v11 then
				v9.EventStream:sendEventImmediately("catalog", "widgetApiFELog", v13)
			else
				v9.EventStream:sendTelemetryEvent("catalog", "widgetApiFELog", v13)
			end
		end

		v8 = v10
		return v10
	end
}
