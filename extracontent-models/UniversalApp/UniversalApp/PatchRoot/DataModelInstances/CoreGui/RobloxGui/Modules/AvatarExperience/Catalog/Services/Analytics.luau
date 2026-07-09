local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local Dash = require(CorePackages.Packages.Dash)
local Modules = CoreGui.RobloxGui.Modules
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local avatarToCatalogButton = require(Modules.AvatarExperience.Catalog.Analytics.avatarToCatalogButton)
local catalogOpenedFromLandingPage = require(Modules.AvatarExperience.Catalog.Analytics.catalogOpenedFromLandingPage)
local catalogSearch = require(Modules.AvatarExperience.Catalog.Analytics.catalogSearch)
local clickCustomizeAvatarFromItemDetailPage = require(Modules.AvatarExperience.Catalog.Analytics.clickCustomizeAvatarFromItemDetailPage)
local clickNavigationTab = require(Modules.AvatarExperience.Catalog.Analytics.clickNavigationTab)
local clickCatalogItem = require(Modules.AvatarExperience.Catalog.Analytics.clickCatalogItem)
local closeItemDetailPage = require(Modules.AvatarExperience.Catalog.Analytics.closeItemDetailPage)
local expandItemDetailPage = require(Modules.AvatarExperience.Catalog.Analytics.expandItemDetailPage)
local moreMenuToCatalogButton = require(Modules.AvatarExperience.Catalog.Analytics.moreMenuToCatalogButton)
local purchaseAsset = require(Modules.AvatarExperience.Catalog.Analytics.purchaseAsset)
local purchaseBundle = require(Modules.AvatarExperience.Catalog.Analytics.purchaseBundle)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).WidgetConstants

require(Modules.AvatarExperience.Common.Enum.SortType)
require(Modules.AvatarExperience.Common.Enum.SortAggregation)
require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
require(Modules.AvatarExperience.Common.Types)

local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local UserInputService = game:GetService("UserInputService")
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local AnalyticsService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).AnalyticsService
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local Constants3 = AvatarExperienceAnalytics.Constants
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local Contexts = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Contexts
local Components = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums).Components
local FFlagProfilePlatformEnableStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local t1 = {
	[AvatarScreen.Catalog] = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE,
	[AvatarScreen.CatalogSearch] = ImpressionEnums.MarketplaceSurfaceType.SEARCH,
	[AvatarScreen.ItemDetails] = ImpressionEnums.MarketplaceSurfaceType.ITEM_DETAIL,
	[AvatarScreen.AvatarEditor] = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
	[AvatarScreen.MySharedAvatars] = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
	[AvatarScreen.ProfilePictureEditorEmotes] = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
	[Contexts.CommunityProfile] = ImpressionEnums.MarketplaceSurfaceType.COMMUNITY_PROFILE,
	[Contexts.PlayerProfile] = ImpressionEnums.MarketplaceSurfaceType.USER_PROFILE
}
local t2 = {
	[Components.CurrentlyWearing] = ImpressionEnums.RecommendationSurfaceType.CURRENTLY_WEARING
}
local _ = {
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
local t3 = {}
local u43 = nil

local function getCategoryNameById(p1) -- line: 115
	-- upvalues: CatalogUtils (copy)
	local v48 = nil

	if p1 then
		v48 = CatalogUtils.getCategoryNameById(p1)
	end

	return v48 or ""
end
local function getSubcategoryNameById(p2, p3) -- line: 123
	-- upvalues: CatalogUtils (copy)
	local v51 = nil

	if p2 and p3 then
		v51 = CatalogUtils.getSubcategoryNameById(p2, p3)
	end

	return v51 or ""
end
local function getAXCounterV2Metadata(t4: {[any]: any}?) -- line: 131
	-- upvalues: UserInputService (copy), isSpatial (copy), RunService (copy), HttpService (copy), Dash (copy)
	local Platform = UserInputService:GetPlatform()

	if isSpatial() then
		Platform = "VR"
	end

	local t5 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = Platform
	}

	if t4 and next(t4) ~= nil then
		t5 = Dash.assign({}, t5, t4)
	end

	return t5
end

function t3.get(_) -- line: 150
	-- upvalues: u43 (ref), AnalyticsService (copy), CatalogUtils (copy), clickCatalogItem (copy), Constants (copy), FFlagProfilePlatformEnableStore (copy), OrganicEventImpressionsSchema (copy), ImpressionEnums (copy), t1 (copy), t2 (copy), purchaseAsset (copy), reportAvatarEventCounterV1 (copy), Constants3 (copy), purchaseBundle (copy), Constants2 (copy), getAXCounterV2Metadata (copy), default (copy), clickNavigationTab (copy), catalogSearch (copy), clickCustomizeAvatarFromItemDetailPage (copy), closeItemDetailPage (copy), expandItemDetailPage (copy), avatarToCatalogButton (copy), moreMenuToCatalogButton (copy), catalogOpenedFromLandingPage (copy), FFlagAXFixPurchaseSurfaceLogging (copy), RbxAnalyticsService (copy), CatalogConstants (copy), WidgetConstants (copy)
	if u43 then
		return u43
	end

	local v56 = AnalyticsService
	local t9 = {
		clickCatalogItem = function(p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17) -- line: 160
			-- upvalues: CatalogUtils (copy), clickCatalogItem (copy), v56 (copy)
			local v71 = nil

			if p7 then
				v71 = CatalogUtils.getCategoryNameById(p7)
			end

			local v72 = v71 or ""
			local v73 = nil

			if p7 and p8 then
				v73 = CatalogUtils.getSubcategoryNameById(p7, p8)
			end

			local v74 = v73 or ""

			clickCatalogItem(v56.EventStream, p5, p6, v72, v74, p9, p10, p11, p12, p13, p14, p15, p16, p17)
		end,
		clickCatalogItemFromProfile = function(s1: string, s2: string, s3: string, s4: string, n1: number?, _: boolean?) -- line: 195
			-- upvalues: Constants (copy), FFlagProfilePlatformEnableStore (copy), OrganicEventImpressionsSchema (copy), ImpressionEnums (copy), t1 (copy), t2 (copy), v56 (copy)
			local t6 = {
				page = "playerProfile",
				feature = Constants.ProfileAnalyticsTag,
				itemID = s2,
				itemType = s3,
				subpage = not FFlagProfilePlatformEnableStore and "peekView" or s4
			}
			local enumMap = OrganicEventImpressionsSchema.defaultItem.enumMap
			local v83 = if not enumMap or not enumMap.contentType then nil else enumMap.contentType[s3]
			local t7 = {
				price = 0,
				itemId = s2,
				actionType = ImpressionEnums.ActionType.CLICK_ITEM_DETAIL,
				contentType = v83,
				surface = t1[s1],
				recommendationSurface = t2[s4],
				absPositions = n1
			}

			v56.EventStream:sendTelemetryEvent(s1, "marketplaceOrganicFELog", t7)
			v56.EventStream:sendTelemetryEvent(s1, "itemDetailReferral", t6)
		end,
		purchaseAsset = function(p18, p19, p20, p21, p22, p23) -- line: 232
			-- upvalues: purchaseAsset (copy), v56 (copy), reportAvatarEventCounterV1 (copy), Constants3 (copy)
			purchaseAsset(v56.EventStream, "purchaseAsset", p18, p19, p20, p21, p22, p23)
			reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.AXPurchaseAsset)
		end,
		purchaseBundle = function(p24, p25, p26, p27, p28) -- line: 246
			-- upvalues: purchaseBundle (copy), v56 (copy), reportAvatarEventCounterV1 (copy), Constants3 (copy)
			purchaseBundle(v56.EventStream, "purchaseBundle", p24, p25, p26, p27, p28)
			reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.AXPurchaseBundle)
		end,
		homepageWidgetItemClick = function(p29, p30) -- line: 259
			-- upvalues: ImpressionEnums (copy), v56 (copy)
			local t8 = {
				group = "HomePageAvatarWidgetClick",
				actionType = ImpressionEnums.ActionType.UI_BUTTON_CLICK,
				surface = ImpressionEnums.MarketplaceSurfaceType.HOMEPAGE,
				item_id = p29,
				item_type = p30,
				event_sender_api = ImpressionEnums.MarketplaceEventSenderAPI.SEND_ROBLOX_TELEMETRY_EVENT
			}

			v56.EventStream:sendTelemetryEvent("HomeTryOnScreen", "marketplaceOrganicFELog", t8)
		end,
		sendCounter = function(s5: string) -- line: 274
			-- upvalues: reportAvatarEventCounterV1 (copy)
			reportAvatarEventCounterV1(s5)
		end
	}

	function t9.sendAXCounter(s6: string, b2: boolean?, t10: {[any]: any}?) -- line: 280
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants2 (copy), t9 (copy)
		reportAvatarEventCounterV1(Constants2.Counter.PREFIX .. s6)

		if b2 then
			t9.sendAXCounterV2(s6, t10)
		end
	end
	function t9.sendAXCounterV2(s7: string, t11: {[any]: any}?) -- line: 290
		-- upvalues: Constants (copy), getAXCounterV2Metadata (copy), default (copy)
		local t12 = {
			description = "Counter to track various Avatar Experience events.",
			links = "https://roblox.atlassian.net/wiki/spaces/AMSD/pages/2800779286/Tech+Spec+-+Q3+Grafana+Dashboard+Improvements",
			eventName = Constants.Counter.PREFIX .. s7,
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = {
				2024,
				4,
				30
			}
		}
		local v106 = getAXCounterV2Metadata(t11)

		default:logRobloxTelemetryCounter(t12, 1, v106)
	end
	function t9.sendAXStat(s8: string, n2: number, t13: {[any]: any}?) -- line: 304
		-- upvalues: getAXCounterV2Metadata (copy), default (copy)
		local t14 = {
			description = "Stat to track various Avatar Experience events.",
			links = "https://roblox.atlassian.net/wiki/spaces/AMSD/pages/2800779286/Tech+Spec+-+Q3+Grafana+Dashboard+Improvements",
			eventName = "AXStat_" .. s8,
			backends = { "RobloxTelemetryStat" },
			lastUpdated = {
				2024,
				4,
				30
			}
		}
		local v111 = getAXCounterV2Metadata(t13)

		default:logRobloxTelemetryStat(t14, n2, v111)
	end
	function t9.clickNavigationTab(p31, p32) -- line: 316
		-- upvalues: CatalogUtils (copy), clickNavigationTab (copy), v56 (copy)
		local v114 = nil

		if p31 then
			v114 = CatalogUtils.getCategoryNameById(p31)
		end

		local v115 = v114 or ""
		local v116 = nil

		if p31 and p32 then
			v116 = CatalogUtils.getSubcategoryNameById(p31, p32)
		end

		local v117 = v116 or ""

		clickNavigationTab(v56.EventStream, "clickNavigationTab", v115, v117)
	end
	function t9.catalogSearch(p33, p34, p35, p36, p37, p38) -- line: 322
		-- upvalues: catalogSearch (copy), v56 (copy)
		catalogSearch(v56.EventStream, p33, p34, p38, p35, p36, p37)
	end
	function t9.clickCustomizeAvatarFromItemDetailPage() -- line: 326
		-- upvalues: clickCustomizeAvatarFromItemDetailPage (copy), v56 (copy)
		clickCustomizeAvatarFromItemDetailPage(v56.EventStream, "clickCustomizeAvatarFromItemDetailPage")
	end
	function t9.closeItemDetailPage(p39, p40) -- line: 330
		-- upvalues: closeItemDetailPage (copy), v56 (copy)
		closeItemDetailPage(v56.EventStream, "closeItemDetailPage", p39, p40)
	end
	function t9.expandItemDetailPage(p41, p42) -- line: 334
		-- upvalues: expandItemDetailPage (copy), v56 (copy)
		expandItemDetailPage(v56.EventStream, "expandItemDetailPage", p41, p42)
	end
	function t9.avatarToCatalogButton() -- line: 338
		-- upvalues: avatarToCatalogButton (copy), v56 (copy)
		avatarToCatalogButton(v56.EventStream, "avatarToCatalogButton")
	end
	function t9.moreMenuToCatalogButton() -- line: 342
		-- upvalues: moreMenuToCatalogButton (copy), v56 (copy)
		moreMenuToCatalogButton(v56.EventStream, "moreMenuToCatalogButton")
	end
	function t9.catalogOpenedFromLandingPage() -- line: 346
		-- upvalues: catalogOpenedFromLandingPage (copy), v56 (copy)
		catalogOpenedFromLandingPage(v56.EventStream, "catalogOpenedFromLandingPage")
	end
	function t9.clickPurchaseItemButton(p43, p44, p45, p46, p47, p48, p49, p50, p51, p52) -- line: 351
		-- upvalues: OrganicEventImpressionsSchema (copy), Constants (copy), ImpressionEnums (copy), FFlagAXFixPurchaseSurfaceLogging (copy), t1 (copy), v56 (copy), RbxAnalyticsService (copy)
		local enumMap = OrganicEventImpressionsSchema.defaultItem.enumMap
		local v139 = if not enumMap or not enumMap.contentType then nil else enumMap.contentType[p44]
		local AnalyticsTag = Constants.AnalyticsTag
		local s9 = nil
		local s10 = nil

		if p45 then
			AnalyticsTag = Constants.ProfileAnalyticsTag
			s9 = "playerProfile"
			s10 = "peekView"
		elseif p51 then
			AnalyticsTag = Constants.ContentFeedAnalyticsTag
			s9 = "contentFeed"
		end

		local t15 = {
			btn = "PriceButton",
			feature = AnalyticsTag,
			itemId = p43,
			actionType = ImpressionEnums.ActionType.PURCHASE_ATTEMPT,
			contentType = v139,
			requestId = p47,
			subpage = s10,
			page = s9,
			keyword = p48,
			surface = if not FFlagAXFixPurchaseSurfaceLogging then t1[p46] else p52 or t1[p46],
			sort = p50.sortEnumValue,
			filterSalesType = p50.filterSalesTypeEnumValue,
			filterCreators = p50.filterCreatorsTypeEnumValue,
			filterPrice = p50.filterPriceEnumValue,
			filterUnavailableItems = p50.filterUnavailableItemsEnumValue,
			filterCreatorsName = p50.filterCreatorsName,
			filterPriceMin = p50.filterPriceMin,
			filterPriceMax = p50.filterPriceMax
		}
		local t16 = {
			btn = "PriceButton",
			feature = AnalyticsTag,
			itemID = p43,
			itemType = p44,
			subpage = s10,
			page = s9,
			fromScreen = p46
		}

		v56.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "marketplaceOrganicFELog", t15)
		v56.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", t16)

		if p49 then
			local t17 = {
				btn = "PriceButton",
				feature = AnalyticsTag,
				itemID = p43,
				itemType = p44,
				subpage = s10,
				page = s9,
				fromScreen = p46,
				refineSessionId = RbxAnalyticsService:GetSessionId()
			}

			v56.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClickHasAccessoryAdjustment", t17)
		end
	end
	function t9.shownEnableTwoStepAuthOnPurchase() -- line: 439
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseShownEnableTwoStepAuth)
	end
	function t9.shownTwoStepAuthOnPurchase() -- line: 445
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseShownTwoStepAuth)
	end
	function t9.failedShowTwoStepAuthOnPurchase() -- line: 451
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseFailedShowTwoStepAuth)
	end
	function t9.completedTwoStepAuthOnPurchase() -- line: 457
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseCompletedTwoStepAuth)
	end
	function t9.invalidatedTwoStepAuthOnPurchase() -- line: 463
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseInvalidatedTwoStepAuth)
	end
	function t9.abandonedTwoStepAuthOnPurchase() -- line: 469
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseAbandonedTwoStepAuth)
	end
	function t9.loadFailedTwoStepAuthOnPurchase() -- line: 475
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants3 (copy)
		reportAvatarEventCounterV1(Constants3.AVATAR_EVENT_COUNTER_NAME.CatalogPurchaseLoadFailedTwoStepAuth)
	end
	function t9.clickCustomizeItemButton(p53, p54) -- line: 482
		-- upvalues: Constants (copy), v56 (copy)
		local t18 = {
			btn = "Customize",
			cstm = "Shop",
			feature = Constants.AnalyticsTag,
			itemID = p53,
			itemType = p54
		}

		v56.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", t18)
	end
	function t9.clickFavoriteItemButton(p55, p56, p57) -- line: 497
		-- upvalues: Constants (copy), v56 (copy)
		local t19 = {
			btn = "Favorite",
			cstm = "Shop",
			feature = Constants.AnalyticsTag,
			itemID = p55,
			itemType = p56,
			checked = p57
		}

		v56.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", t19)
	end
	function t9.clickShareItemButton(p58, p59) -- line: 513
		-- upvalues: Constants (copy), v56 (copy)
		local t20 = {
			btn = "Share",
			cstm = "Shop",
			feature = Constants.AnalyticsTag,
			itemID = p58,
			itemType = p59
		}

		v56.EventStream:sendTelemetryEvent("itemDetailPageBottomButtonClick", "buttonClick", t20)
	end
	function t9.applySortAndFilters(t21: {[any]: any}) -- line: 527
		-- upvalues: Constants (copy), v56 (copy)
		local t22 = {
			btn = "Apply",
			feature = Constants.AnalyticsTag,
			minPrice = t21.minPrice,
			maxPrice = t21.maxPrice,
			sortType = t21.sortType,
			sortAggregation = t21.sortAggregation,
			salesTypeFilter = t21.salesTypeFilter,
			creatorFilter = t21.creatorFilter,
			includeOffSale = t21.includeOffSale
		}

		v56.EventStream:sendTelemetryEvent("SortAndFilters", "buttonClick", t22)
	end
	function t9.applyPriceFilter(p60, p61) -- line: 546
		-- upvalues: Constants (copy), v56 (copy)
		local t23 = {
			btn = "Apply",
			feature = Constants.AnalyticsTag,
			PriceLowerBound = p60,
			PriceUpperBound = p61
		}

		v56.EventStream:sendTelemetryEvent("PriceFilter", "buttonClick", t23)
	end
	function t9.navigateToProfile(p62) -- line: 559
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants (copy), v56 (copy)
		reportAvatarEventCounterV1(p62 .. "LuaProfile")

		local t24 = {
			btn = "creator",
			subpage = "peekView",
			page = "playerProfile",
			feature = Constants.ProfileAnalyticsTag
		}

		v56.EventStream:sendTelemetryEvent(p62, "buttonClick", t24)
	end
	function t9.selectTopic(s11: string, n3: number, n4: number?, n5: number?, s12: string?, t25: {[any]: any}?, t26: {[any]: any}?) -- line: 573
		-- upvalues: CatalogConstants (copy), CatalogUtils (copy), v56 (copy)
		local Catalog = CatalogConstants.AnalyticsContext.Catalog
		local v171 = nil

		if n4 then
			v171 = CatalogUtils.getCategoryNameById(n4)
		end

		local v172 = v171 or ""
		local v173 = nil

		if n4 and n5 then
			v173 = CatalogUtils.getSubcategoryNameById(n4, n5)
		end

		local v174 = v173 or ""
		local t27 = {
			topic = s11,
			allTopics = if not t25 then nil else table.concat(t25, ","),
			previousSelectedTopics = if not t26 then nil else table.concat(t26, ","),
			rank = n3,
			category = v172,
			subcategory = v174,
			query = s12
		}

		v56.EventStream:sendTelemetryEvent(Catalog, "selectCatalogTopic", t27)
	end
	function t9.openItemDetails(s13: string, s14: string, n6: number, s15: string) -- line: 601
		-- upvalues: CatalogConstants (copy), v56 (copy)
		local AvatarShop = CatalogConstants.AnalyticsContext.AvatarShop
		local t28 = {
			assetId = s13,
			assetType = s14,
			price = n6,
			entryPoint = s15
		}

		v56.EventStream:sendTelemetryEvent(AvatarShop, "openItemDetails", t28)
	end
	function t9.openItemDetailsV2(s16: string, s17: string, n7: number, s18: string, p63, p64, s19: string?, s20: string?, p65) -- line: 614
		-- upvalues: CatalogConstants (copy), OrganicEventImpressionsSchema (copy), ImpressionEnums (copy), t1 (copy), v56 (copy)
		local AvatarShop = CatalogConstants.AnalyticsContext.AvatarShop
		local enumMap = OrganicEventImpressionsSchema.defaultItem.enumMap
		local v193 = if not enumMap or not enumMap.contentType then nil else enumMap.contentType[s17]
		local t29 = {
			itemId = s16,
			actionType = ImpressionEnums.ActionType.CLICK_ITEM_DETAIL,
			contentType = v193,
			price = n7,
			surface = t1[s18],
			requestId = p63,
			absPositions = p65.selectedItemIndex,
			keyword = p64,
			category = s19,
			subcategory = s20,
			sort = p65.sortEnumValue,
			filterSalesType = p65.filterSalesTypeEnumValue,
			filterCreators = p65.filterCreatorsTypeEnumValue,
			filterPrice = p65.filterPriceEnumValue,
			filterUnavailableItems = p65.filterUnavailableItemsEnumValue,
			filterCreatorsName = p65.filterCreatorsName,
			filterPriceMin = p65.filterPriceMin,
			filterPriceMax = p65.filterPriceMax
		}

		v56.EventStream:sendTelemetryEvent(AvatarShop, "marketplaceOrganicFELog", t29)
	end
	function t9.resizeOutfitScreen(s21: string) -- line: 653
		-- upvalues: CatalogConstants (copy), v56 (copy)
		local AvatarShop = CatalogConstants.AnalyticsContext.AvatarShop
		local t30 = {
			stateChange = s21
		}

		v56.EventStream:sendTelemetryEvent(AvatarShop, "openOutfitScreen", t30)
	end
	function t9.avatarShopBuyItem(s22: string, s23: string, n8: number, s24: string, s25: string?, p66, s26: string?, s27: string?, p67, n9: number?) -- line: 663
		-- upvalues: CatalogConstants (copy), OrganicEventImpressionsSchema (copy), v56 (copy), ImpressionEnums (copy), FFlagAXFixPurchaseSurfaceLogging (copy), t1 (copy)
		local AvatarShop = CatalogConstants.AnalyticsContext.AvatarShop
		local enumMap = OrganicEventImpressionsSchema.defaultItem.enumMap
		local v210 = if not enumMap or not enumMap.contentType then nil else enumMap.contentType[s23]

		v56.EventStream:sendEventImmediately(AvatarShop, "marketplaceOrganicFELog", {
			itemId = s22,
			actionType = ImpressionEnums.ActionType.PURCHASE_SUCCESS,
			contentType = v210,
			price = n8,
			surface = if not FFlagAXFixPurchaseSurfaceLogging then t1[s24] else n9 or t1[s24],
			requestId = s25,
			absPositions = p67.selectedItemIndex,
			sort = p67.sortEnumValue,
			filterSalesType = p67.filterSalesTypeEnumValue,
			filterCreators = p67.filterCreatorsTypeEnumValue,
			filterPrice = p67.filterPriceEnumValue,
			filterUnavailableItems = p67.filterUnavailableItemsEnumValue,
			filterCreatorsName = p67.filterCreatorsName,
			filterPriceMin = p67.filterPriceMin,
			filterPriceMax = p67.filterPriceMax,
			keyword = p66,
			category = s26,
			subcategory = s27
		})
	end
	function t9.widgetInteraction(p68, p69, p70, p71, p72, p73, p74) -- line: 704
		-- upvalues: v56 (copy)
		local t31 = {
			request_id = p68,
			action_type = p69,
			item_position = p70,
			widget_position = p71,
			item_id = p72,
			item_type = p73,
			widget_id = p74
		}

		v56.EventStream:sendTelemetryEvent("catalog", "widgetApiFELog", t31)
	end
	function t9.widgetInteractionV2(p75, n10: number) -- line: 729
		-- upvalues: WidgetConstants (copy), v56 (copy)
		local v221 = n10 == WidgetConstants.ActionType.PURCHASE_SUCCESS
		local t32 = {
			Outfit = "1",
			Avatar = "2",
			Makeup = "3"
		}
		local t33 = {
			action_type = n10,
			request_id = p75.requestId,
			item_position = p75.itemPosition,
			widget_position = p75.widgetPosition,
			item_id = p75.itemId,
			item_type = p75.itemType,
			look_type = if not p75.lookType then nil else t32[p75.lookType],
			widget_id = p75.widgetId,
			widget_type = p75.widgetType,
			widget_abs_position = p75.widgetAbsPosition,
			widget_item_ids = if not p75.widgetItemIds then nil else table.concat(p75.widgetItemIds, ","),
			kwd = p75.query,
			organic_result_ids = if not p75.organicResultIds then nil else table.concat(p75.organicResultIds, ","),
			time_spent_sec = p75.timeSpentSec,
			asset_ids = if not p75.assetIds then nil else table.concat(p75.assetIds, ","),
			bundle_ids = if not p75.bundleIds then nil else table.concat(p75.bundleIds, ","),
			total_robux = p75.totalRobux,
			ui_treatment_type = p75.uiTreatmentType
		}

		if v221 then
			v56.EventStream:sendEventImmediately("catalog", "widgetApiFELog", t33)

			return
		end

		v56.EventStream:sendTelemetryEvent("catalog", "widgetApiFELog", t33)
	end

	u43 = t9

	return t9
end

return t3
