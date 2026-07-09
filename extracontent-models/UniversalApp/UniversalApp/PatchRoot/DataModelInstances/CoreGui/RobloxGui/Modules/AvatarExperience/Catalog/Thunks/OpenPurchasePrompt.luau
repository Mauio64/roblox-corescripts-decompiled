local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local PurchaseProduct = require(Modules.AvatarExperience.Catalog.Thunks.PurchaseProduct)
local HandlePurchaseSuccess = require(Modules.AvatarExperience.Catalog.Thunks.HandlePurchaseSuccess)
local Promise = require(CorePackages.Packages.Promise)
local CartIdService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Lib.CartIdService
local RobuxUpsellTriggerContext = require(Modules.LuaApp.Components.RobuxUpsell.Enum.RobuxUpsellTriggerContext)
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local v19 = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local Cryo = require(CorePackages.Packages.Cryo)
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local OpenCentralOverlayForUnifiedPurchasePrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getIsUserEligibleForUnifiedPurchaseFlow = PurchasePromptLite.getIsUserEligibleForUnifiedPurchaseFlow
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local FFlagAddTypesToWidgetItems = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAddTypesToWidgetItems
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local FFlagAXEnableUnifiedProductPurchaseForMarketplace = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableUnifiedProductPurchaseForMarketplace
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = SharedFlags.FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions
local FFlagPurchaseModalTimedOptionExtension = SharedFlags.FFlagPurchaseModalTimedOptionExtension
local FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration
local FFlagFixUnifiedPurchaseResalePurchases = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagFixUnifiedPurchaseResalePurchases
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents

require(Modules.AvatarExperience.Common.Types)

local FFlagAXLaunchUnifiedPurchaseFlowMarketplaceAssetBundles = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXLaunchUnifiedPurchaseFlowMarketplaceAssetBundles
local FFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors

local function buildUnifiedPurchaseProductInfo(p1, s1: string?, n1: number?, p2, s2: string, n2: number?) -- line: 108
	local t1 = {}
	local discountInformation = p1.discountInformation

	if n2 and (n2 ~= 0 and p1.timedOptions) then
		for _, v65 in p1.timedOptions do
			if n2 == v65.days then
				discountInformation = v65.discountInformation

				break
			end
		end
	end

	if discountInformation then
		local v66 = discountInformation.discounts[1]

		t1.Type = v66.discountCampaign
		t1.AmountInRobux = v66.robuxDiscountAmount
		t1.Percent = v66.robuxDiscountPercentage
	end

	return {
		AssetType = p1.assetType,
		CollectibleItemId = p1.collectibleItemId,
		CollectibleProductId = s1,
		Description = p1.description,
		PriceInRobux = n1,
		BasePriceInRobux = if not discountInformation then nil else discountInformation.originalPrice,
		PriceDiscountDetails = { t1 },
		ImageUrl = p1.imageUrl,
		Name = p1.name,
		ProductId = p2,
		AssetTypeId = p1.assetType,
		ProductType = s2,
		TargetId = p1.id,
		AssetId = p1.id,
		items = p1.items,
		product = {
			id = p2,
			isForSale = p1.isPurchasable
		}
	}
end

local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local t2 = {
	toastMessage = "IAPExperience.RobuxUpsell.Title.InsufficientRobux",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

return function(p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, b1: boolean?) -- line: 185
	-- upvalues: ItemData (copy), AccessoryAdjustmentUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreen (copy), FFlagAXFixPurchaseSurfaceLogging (copy), Constants (copy), CatalogUtils (copy), FFlagAXEnableUnifiedProductPurchaseForMarketplace (copy), FFlagFixUnifiedPurchaseResalePurchases (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), NavigateWithLock (copy), SetCurrentToastMessage (copy), t2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), RobuxUpsellTriggerContext (copy), PurchaseProduct (copy), HandlePurchaseSuccess (copy), Cryo (copy), UnifiedEventLogEnums (copy), FFlagAddTypesToWidgetItems (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy), CloseCentralOverlay (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration (copy), Promise (copy), buildUnifiedPurchaseProductInfo (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), v19 (copy), FFlagPurchaseModalTimedOptionExtension (copy), FFlagSkipCompletionModalForMarketplace (copy), FFlagAXLaunchUnifiedPurchaseFlowMarketplaceAssetBundles (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy)
	return function(p17) -- line: 205
		-- upvalues: p9 (copy), p10 (copy), p8 (copy), ItemData (copy), AccessoryAdjustmentUtils (copy), p6 (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreen (copy), p7 (copy), p14 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), p5 (copy), Constants (copy), CatalogUtils (copy), p15 (copy), FFlagAXEnableUnifiedProductPurchaseForMarketplace (copy), FFlagFixUnifiedPurchaseResalePurchases (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), p4 (copy), p13 (copy), NavigateWithLock (copy), p11 (copy), SetCurrentToastMessage (copy), p12 (copy), t2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), RobuxUpsellTriggerContext (copy), PurchaseProduct (copy), p3 (copy), HandlePurchaseSuccess (copy), Cryo (copy), UnifiedEventLogEnums (copy), FFlagAddTypesToWidgetItems (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy), CloseCentralOverlay (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration (copy), Promise (copy), buildUnifiedPurchaseProductInfo (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), p16 (copy), v19 (copy), b1 (copy), FFlagPurchaseModalTimedOptionExtension (copy), FFlagSkipCompletionModalForMarketplace (copy), FFlagAXLaunchUnifiedPurchaseFlowMarketplaceAssetBundles (copy), getIsUserEligibleForUnifiedPurchaseFlow (copy)
		local v83 = p17:getState()
		local v84 = p9
		local v85 = p10
		local name = p8.opaque.name
		local v87 = ItemData(v83.AvatarExperience.Common, v84, v85)

		if not v87 then
			return
		end

		local TryOnItems = v83.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local v89 = AccessoryAdjustmentUtils.checkTryOnHasAdjustments(TryOnItems, (tostring(v84)))

		if p6 then
			local RequestId = v83.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
			local v91 = nil
			local v92 = if not FFlagUseNavigationSelectors then v83.Navigation and v83.Navigation.currentRoute else Selectors.selectCurrentRoactNavigationRoute(v83)

			if v92 and v92.name == AvatarScreen.CatalogSearch then
				v91 = v92.params and (v92.params.searchParams and v92.params.searchParams.searchKeyword)
			end

			p6.clickPurchaseItemButton(v84, v85, p7, name, RequestId, v91, v89, v83.AvatarExperience.AnalyticsMetadata, p14, if not FFlagAXFixPurchaseSurfaceLogging or not p5 then nil else p5.getParam(Constants.NavigationParams.fromSurface))
		end

		local resellerUserAssetIds = v87.resellerUserAssetIds
		local v94 = resellerUserAssetIds and resellerUserAssetIds[1]
		local v95 = v83.AvatarExperience.Catalog.UserAssets[v94]
		local v96 = v83.UserRobux[v83.LocalUserId]
		local u97 = v87.lowestPrice or v87.priceInRobux
		local v98 = CatalogUtils.IsResellable(v87)
		local expectedSellerId = v87.expectedSellerId
		local u100 = v87.creator and v87.creator.name
		local collectibleItemId = v87.collectibleItemId

		if p15 and v87.timedOptions then
			for _, v103 in v87.timedOptions do
				if v103.days == p15 then
					u97 = v103.price

					break
				end
			end
		end

		local userAssetId = nil

		if v98 and v95 then
			userAssetId = v95.userAssetId
			expectedSellerId = v95.userId
			u100 = v95.userName
		end

		local collectibleInstanceId = nil
		local collectibleProductId = nil

		if collectibleItemId then
			local CollectiblesItemInfo = v83.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
			local CollectiblesResellersInstances = v83.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances
			local CollectiblesResellableInstances = v83.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
			local v110 = CatalogUtils.findCheapestCollectiblePurchaseInfoV2(collectibleItemId, v98, CollectiblesItemInfo, CollectiblesResellersInstances, CollectiblesResellableInstances)

			if v110.price and not p15 then
				u97 = v110.price
			end

			if v110.collectibleInstanceId then
				collectibleInstanceId = v110.collectibleInstanceId
				expectedSellerId = v110.expectedSellerId
				u100 = v110.sellerName
			end

			if FFlagAXEnableUnifiedProductPurchaseForMarketplace then
				collectibleProductId = CollectiblesItemInfo[collectibleItemId].collectibleProductId

				if FFlagFixUnifiedPurchaseResalePurchases and collectibleInstanceId ~= nil then
					local v111 = CollectiblesResellersInstances[collectibleItemId]
					local v112 = v111 and (v111.Instances and v111.Instances[collectibleInstanceId])

					if v112 and v112.collectibleProductId then
						collectibleProductId = v112 and v112.collectibleProductId
					end
				end
			end
		end

		local function v113() -- line: 318
			-- upvalues: FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), u97 (ref), v96 (copy), p5 (copy), AvatarScreen (copy), v84 (copy), v85 (copy), expectedSellerId (ref), u100 (ref), userAssetId (ref), collectibleInstanceId (ref), p4 (copy), p7 (copy), p8 (copy), p13 (copy), p14 (copy), p15 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), Constants (copy), p17 (copy), NavigateWithLock (copy), p11 (copy), SetCurrentToastMessage (copy), p12 (copy), t2 (copy), CatalogUtils (copy), getRbxthumbWithTypeSizeAndOptions (copy), v87 (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy), RobuxUpsellTriggerContext (copy), PurchaseProduct (copy), p3 (copy), p6 (copy)
			if FFlagAddPerformanceMetricsToUnifiedPurchaseModal then
				local v115 = getTTIEventName(ProductPurchaseSurface.Catalog)

				TimeToInteractiveTracker.trackStart(v115)
				TimeToInteractiveTracker.updateMetadata(v115, {
					category = "legacy_purchase_modal",
					page = ProductPurchaseSurface.Catalog
				})
			end

			if u97 and v96 >= u97 then
				p17:dispatch(NavigateWithLock(function() -- line: 328
					-- upvalues: p5 (copy), AvatarScreen (copy), v84 (copy), v85 (copy), u97 (ref), expectedSellerId (ref), u100 (ref), userAssetId (ref), collectibleInstanceId (ref), p4 (copy), p7 (copy), p8 (copy), p13 (copy), p14 (copy), p15 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), Constants (copy)
					p5.navigate(AvatarScreen.PurchaseCatalogItem, {
						itemId = v84,
						itemType = v85,
						priceInRobux = u97,
						sellerId = expectedSellerId,
						sellerName = u100,
						userAssetId = userAssetId,
						collectibleInstanceId = collectibleInstanceId,
						onOverlayClosed = p4,
						fromProfile = p7,
						fromAvatarRoute = p8,
						widgetInfo = p13,
						fromContentFeed = p14,
						timedOptionDays = p15,
						fromSurface = if not FFlagAXFixPurchaseSurfaceLogging or not p5 then nil else p5.getParam(Constants.NavigationParams.fromSurface)
					})
				end))

				return
			end

			if p11 then
				p17:dispatch(SetCurrentToastMessage(if not p12 then t2 else p12))

				return
			end

			local _ = AvatarScreen.InsufficientRobuxPrompt
			local t3 = {
				onOverlayClosed = p4
			}
			local v118 = CatalogUtils.GetRbxThumbType(v85)
			local v119 = getRbxthumbWithTypeSizeAndOptions(v84, v118, 150)
			local name2 = v87.name

			local function v121(p18) -- line: 370
				-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), p17 (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
				local v133 = parseEconomicRestrictionsFailureReason(p18)
				local v134 = parseEconomicRestrictionsExpirationTimeInMinutes(p18)

				default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
					surface = EconomicRestrictionsSurface.AvatarExperience,
					failureReason = v133
				})

				return p17:dispatch(OpenCentralOverlayForEconomicRestrictionPrompt(v133, v134))
			end

			local RobuxUpsellPrompt = AvatarScreen.RobuxUpsellPrompt

			t3.triggerContext = RobuxUpsellTriggerContext.UACatalog
			t3.priceInRobux = u97
			t3.userRobux = v96
			t3.itemProductId = v84
			t3.itemName = name2
			t3.itemIcon = v119

			function t3.purchaseItem() -- line: 389
				-- upvalues: p5 (copy), v87 (copy), CatalogUtils (copy), v85 (copy), p17 (copy), PurchaseProduct (copy), p3 (copy), u97 (ref), expectedSellerId (ref), v84 (copy), userAssetId (ref), p6 (copy), p7 (copy), collectibleInstanceId (ref), p13 (copy), p14 (copy), v121 (copy), p15 (copy)
				local v135 = if not p5 then nil else p5.state.routeName
				local v136 = v87 and (v87.product and v87.product.id)
				local v137 = CatalogUtils.GetItemSubType(v85, v87)
				local collectibleItemId2 = v87.collectibleItemId
				local v139 = v87.creator and v87.creator.type

				return p17:dispatch(PurchaseProduct(p3, v136, u97, expectedSellerId, v84, v85, v137, false, userAssetId, p6, p5, p7, false, v135, collectibleItemId2, collectibleInstanceId, v139, p13, p14, v121, p15))
			end

			p17:dispatch(NavigateWithLock(function() -- line: 422
				-- upvalues: p5 (copy), RobuxUpsellPrompt (ref), t3 (copy)
				p5.navigate(RobuxUpsellPrompt, t3)
			end))
		end

		if FFlagAXEnableUnifiedProductPurchaseForMarketplace then
			local function v114() -- line: 429
				-- upvalues: v85 (copy), CatalogUtils (copy), v87 (copy), Constants (copy), p17 (copy), HandlePurchaseSuccess (copy), p3 (copy), p9 (copy), p10 (copy), collectibleItemId (ref), p6 (copy), p7 (copy), p14 (copy), p8 (copy), name (copy), p13 (copy), u97 (ref), p5 (copy), Cryo (copy), UnifiedEventLogEnums (copy), FFlagAddTypesToWidgetItems (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy), CloseCentralOverlay (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration (copy), Promise (copy), buildUnifiedPurchaseProductInfo (copy), collectibleProductId (ref), v84 (copy), p15 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), p16 (copy), collectibleInstanceId (ref), v19 (copy), ProductPurchaseSurface (copy), b1 (copy), v96 (copy), FFlagPurchaseModalTimedOptionExtension (copy), FFlagSkipCompletionModalForMarketplace (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy)
				local function showWearAfterPurchase() -- line: 431
					-- upvalues: v85 (copy), CatalogUtils (copy), v87 (copy), Constants (copy)
					local v140 = v85
					local v141 = CatalogUtils.GetItemSubType(v85, v87)

					return v140 == Constants.ItemType.Asset and v141 ~= Constants.AssetTypeIdStrings.EmoteAnimation
				end

				local v124 = FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and v87.expirationTime ~= nil or FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration
				local v125 = p17
				local v126 = OpenCentralOverlayForUnifiedPurchasePrompt
				local t5 = {
					subtitleView = if not FFlagPurchasePromptSubtitleForTimedOptions then nil else p16,
					productPayload = {
						equipIfPurchased = false,
						isRobloxPurchase = true,
						id = v84,
						kind = v85,
						collectibleItemId = v87.collectibleItemId,
						collectibleItemInstanceId = collectibleInstanceId,
						collectibleProductId = collectibleProductId,
						expectedPrice = u97,
						timedOptionDays = if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then nil else p15
					},
					purchaseCallbacks = {
						onFlowComplete = function() -- line: 500
							-- upvalues: p17 (copy), CloseCentralOverlay (copy)
							p17:dispatch(CloseCentralOverlay())
						end,
						onPurchaseSuccess = function(p19, p20) -- line: 440
							-- upvalues: CatalogUtils (copy), v85 (copy), v87 (copy), p17 (copy), HandlePurchaseSuccess (copy), p3 (copy), p9 (copy), p10 (copy), collectibleItemId (ref), p6 (copy), p7 (copy), p14 (copy), p8 (copy), name (copy), p13 (copy), u97 (ref), p5 (copy)
							local v144 = CatalogUtils.GetItemSubType(v85, v87)

							p17:dispatch(HandlePurchaseSuccess(p19, p20, p3, p9, p10, collectibleItemId, p6, p7, p14, p8, name, p13, u97, v144, p5))
						end,
						onBuyItemButtonMounted = function(p21) -- line: 462
							-- upvalues: p13 (copy), Cryo (copy), p9 (copy), p10 (copy), Constants (copy), UnifiedEventLogEnums (copy), FFlagAddTypesToWidgetItems (copy), v87 (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), u97 (ref), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy)
							if p21 then
								local t4 = {
									current = p21
								}
								local v147 = p13 or {}
								local v148 = Cryo.Dictionary.join(v147, {
									itemId = p9,
									itemType = if p10 ~= Constants.ItemType.Asset then if p10 ~= Constants.ItemType.Bundle then nil else UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
									assetType = if not FFlagAddTypesToWidgetItems or not v147.widgetType then v87.assetType else nil,
									widgetAssetType = if not FFlagAddTypesToWidgetItems or not v147.widgetType then nil else v87.assetType,
									bundleType = if not FFlagAddTypesToWidgetItems or not v147.widgetType then v87.bundleType else nil,
									widgetBundleType = if not FFlagAddTypesToWidgetItems or not v147.widgetType then nil else v87.bundleType,
									action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
									cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
									widgetItemPrice = if not v147.widgetType then nil else u97,
									organicItemPrice = if not v147.widgetType then u97 else nil
								})

								addUnifiedEventLogging(t4, v148, {
									sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
								})
							end
						end,
						fetchProductInfo = if not FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration then nil else function() -- line: 506
							-- upvalues: Promise (copy), buildUnifiedPurchaseProductInfo (copy), v87 (copy), collectibleProductId (ref), u97 (ref), v84 (copy), v85 (copy), p15 (copy)
							return Promise.resolve((buildUnifiedPurchaseProductInfo(v87, collectibleProductId, u97, v84, v85, p15)))
						end
					}
				}
				local v128 = v85
				local v129 = CatalogUtils.GetItemSubType(v85, v87)

				t5.postPurchaseActions = v128 == Constants.ItemType.Asset and v129 ~= Constants.AssetTypeIdStrings.EmoteAnimation and {{
					isActionSelected = true,
					label = v19:Format("Feature.Catalog.Label.WearAfterPurchase"),
					actionKey = Constants.WearAfterPurchasePostPurchaseActionKey
				}}
				t5.purchaseAnalyticsMetadata = {
					surface = ProductPurchaseSurface.Catalog
				}
				t5.purchaseOptions = if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and (not FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration and b1 == nil) then nil else {
					shouldSkipOwnershipCheck = v124,
					providedRobuxBalance = if not FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration then nil else v96,
					completionMessage = if not FFlagPurchaseModalTimedOptionExtension or v87.expirationTime == nil then nil else v19:Format("Feature.Durables.PurchaseModal.SuccessMessage", {
						itemName = v87.name,
						number = tostring(p15)
					}),
					skipPurchaseSuccessModal = not not FFlagSkipCompletionModalForMarketplace or nil,
					shouldFetchCartPricing = b1
				}
				v125:dispatch(v126(t5, not not FFlagAddPerformanceMetricsToUnifiedPurchaseModal or nil))
			end

			if FFlagAXLaunchUnifiedPurchaseFlowMarketplaceAssetBundles then
				v114()

				return
			end

			getIsUserEligibleForUnifiedPurchaseFlow(p3):andThen(function(p22) -- line: 580
				-- upvalues: v114 (copy), v113 (copy)
				if p22 then
					v114()

					return
				end

				v113()
			end):catch(function(_) -- line: 587
				-- upvalues: v113 (copy)
				v113()
			end)

			return
		end

		v113()
	end
end
