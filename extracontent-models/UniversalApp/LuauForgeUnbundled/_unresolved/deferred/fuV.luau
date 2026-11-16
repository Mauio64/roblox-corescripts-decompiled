local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local tutils = require(CorePackages.Packages.tutils)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local getItemPurchaseActionType = AvatarExperienceCommon.Utils.getItemPurchaseActionType
local itemPurchaseActionTypeEnum = AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum
local module2 = require("@luauforge/bundled/dRQ")
local module3 = require("@luauforge/deferred/fuW")
local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local getMarketplaceUnifiedAssetType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType
local getMarketplaceUnifiedBundleType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType
local getUnifiedLoggingSurfaceForRoute = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurfaceForRoute

local mapMarketplaceSurfaceToUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.mapMarketplaceSurfaceToUnifiedLoggingSurface
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local buildDiscoveryPurchaseAttempt = AvatarExperienceAnalytics.buildDiscoveryPurchaseAttempt
local v5 = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog

local module5 = require("@luauforge/deferred/fvk")
local module6 = require("@luauforge/bundled/fvl")
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization.new(LocalizationService.RobloxLocaleId)
local module7 = require("@luauforge/bundled/dMx")
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging
local Cryo = require(CorePackages.Packages.Cryo)
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants

local module8 = require("@luauforge/deferred/fvm")
local productPurchaseSurface = require("@luauforge/deferred/fvp").Enums.ProductPurchaseSurface

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = SharedFlags.FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local fFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions
local fFlagPurchaseModalTimedOptionExtension = SharedFlags.FFlagPurchaseModalTimedOptionExtension

local fFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration

local fFlagFixUnifiedPurchaseResalePurchases = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagFixUnifiedPurchaseResalePurchases

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

if not fFlagAXUnifiedEventStrictPayloads then
	v5 = sendUnifiedEventLog
end

local fFlagAXDiscoveryItemPurchaseAttribution = SharedFlags.FFlagAXDiscoveryItemPurchaseAttribution
require("@luauforge/bundled/dMc")
local fFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagEnableMarketplacePurchaseDeepLinkAttribution = SharedFlags.FFlagEnableMarketplacePurchaseDeepLinkAttribution
local fFlagBlackbirdUpsellGateResalePurchaseType = SharedFlags.FFlagBlackbirdUpsellGateResalePurchaseType

local function buildUnifiedPurchaseProductInfo(data, collectibleProductId, p2, productId, productType, p3)
	local v6 = {}

	local discountInformation = data.discountInformation

	if p3 and p3 ~= 0 and data.timedOptions then
		for k, timedOption in data.timedOptions do
			if timedOption.days == p3 then
				discountInformation = timedOption.discountInformation
				break
			end
		end
	end

	if discountInformation then
		local discount = discountInformation.discounts[1]
		v6.Type = discount.discountCampaign
		v6.AmountInRobux = discount.robuxDiscountAmount
		v6.Percent = discount.robuxDiscountPercentage
	end

	local unifiedPurchaseProductInfo = {
		AssetType = data.assetType,
		CollectibleItemId = data.collectibleItemId,
		CollectibleProductId = collectibleProductId,
		Description = data.description,
		PriceInRobux = p2,
		BasePriceInRobux = 0,
		PriceDiscountDetails = 0,
		ImageUrl = 0,
		Name = 0,
		ProductId = 0,
		AssetTypeId = 0,
		ProductType = 0,
		TargetId = 0,
		AssetId = 0,
		items = 0,
		product = 0
	}

	local v7 = if discountInformation then discountInformation.originalPrice else nil
	unifiedPurchaseProductInfo.BasePriceInRobux = v7
	unifiedPurchaseProductInfo.PriceDiscountDetails = { v6 }

	unifiedPurchaseProductInfo.ImageUrl = data.imageUrl
	unifiedPurchaseProductInfo.Name = data.name
	unifiedPurchaseProductInfo.ProductId = productId
	unifiedPurchaseProductInfo.AssetTypeId = data.assetType
	unifiedPurchaseProductInfo.ProductType = productType
	unifiedPurchaseProductInfo.TargetId = data.id
	unifiedPurchaseProductInfo.AssetId = data.id
	unifiedPurchaseProductInfo.items = data.items
	unifiedPurchaseProductInfo.product = {
		id = productId,
		isForSale = data.isPurchasable
	}
	return unifiedPurchaseProductInfo
end

return function(p2, p3, p4, p5, p6, p7, itemId, p8, p9, p10, options, p11, p12, p13, shouldFetchCartPricing)
	return function(object)
		local state = object:getState()

		local v6 = itemId
		local v7 = p8
		local name = p7.opaque.name

		local v8 = itemData(state.AvatarExperience.Common, v6, v7)

		if not v8 then
			return
		end

		local tryOnItems = state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

		local v9 = module5.checkTryOnHasAdjustments(tryOnItems, (tostring(v6)))

		if p5 then
			local requestId = state.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
			local searchKeyword = nil
			local v10

			if fFlagSignalsNavP3gAvatarExperience then
				v10 = getLegacyNavigationStore(false).getCurrentRoute(false)
			elseif fFlagUseNavigationSelectors then
				v10 = selectors.selectCurrentRoactNavigationRoute(state)
			else
				v10 = state.Navigation and state.Navigation.currentRoute
			end

			if v10 and v10.name == avatarScreen.CatalogSearch then
				searchKeyword = v10.params
					and v10.params.searchParams
					and v10.params.searchParams.searchKeyword
			end

			local clickPurchaseItemButton = p5.clickPurchaseItemButton

			local analyticsMetadata = state.AvatarExperience.AnalyticsMetadata

			local v13 = if fFlagAXFixPurchaseSurfaceLogging and p4 then p4.getParam(module7.NavigationParams.fromSurface) else nil
			clickPurchaseItemButton(
				v6,
				v7,
				p6,
				name,
				requestId,
				searchKeyword,
				v9,
				analyticsMetadata,
				p11,
				v13
			)
		end

		local v10 = state.UserRobux[state.LocalUserId]

		local v11 = v8.lowestPrice or v8.priceInRobux

		local isResellable = module2.IsResellable(v8)
		local collectibleItemId = v8.collectibleItemId

		if p12 and v8.timedOptions then
			for k, timedOption in v8.timedOptions do
				if timedOption.days == p12 then
					v11 = timedOption.price
					break
				end
			end
		end

		local collectibleInstanceId = nil

		local v12 = false
		local collectibleProductId

		if collectibleItemId then
			local collectiblesItemInfo = state.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
			local collectiblesResellersInstances = state.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances
			local collectiblesResellableInstances = state.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
			local cheapestCollectiblePurchaseInfoV2 = module2.findCheapestCollectiblePurchaseInfoV2(
				collectibleItemId,
				isResellable,
				collectiblesItemInfo,
				collectiblesResellersInstances,
				collectiblesResellableInstances
			)

			if cheapestCollectiblePurchaseInfoV2.price and not p12 then
				v11 = cheapestCollectiblePurchaseInfoV2.price
			end

			if cheapestCollectiblePurchaseInfoV2.collectibleInstanceId then
				collectibleInstanceId = cheapestCollectiblePurchaseInfoV2.collectibleInstanceId
			end

			local v13 = collectiblesItemInfo[collectibleItemId]
			collectibleProductId = v13.collectibleProductId

			if fFlagBlackbirdUpsellGateResalePurchaseType then
				local collectiblesResellableInstance = collectiblesResellableInstances[collectibleItemId]

				local itemPurchaseActionType = getItemPurchaseActionType(
					v8,
					v13,
					not collectiblesResellableInstance and 0 or tutils.fieldCount(collectiblesResellableInstance),
					isResellable
				)

				if itemPurchaseActionType == itemPurchaseActionTypeEnum.PurchaseFromResale then
					v12 = true
				elseif itemPurchaseActionType == itemPurchaseActionTypeEnum.QuantityLimitExceeded then
					v12 = isResellable and v8.hasResellers == true
				else
					v12 = false
				end
			end

			if fFlagFixUnifiedPurchaseResalePurchases and collectibleInstanceId ~= nil then
				local collectiblesResellersInstance = collectiblesResellersInstances[collectibleItemId]

				local v14 = collectiblesResellersInstance
					and collectiblesResellersInstance.Instances
					and collectiblesResellersInstance.Instances[collectibleInstanceId]

				if v14 and v14.collectibleProductId then
					collectibleProductId = v14 and v14.collectibleProductId
				end
			end
		else
			collectibleProductId = nil
		end

		local function showWearAfterPurchase(): boolean
			local itemSubType = module2.GetItemSubType(v7, v8)

			return v7 == module7.ItemType.Asset and itemSubType ~= module7.AssetTypeIdStrings.EmoteAnimation
		end

		local function onPurchaseSuccess(p14, p15)
			object:dispatch(module3(
				p14,
				p15,
				p2,
				itemId,
				p8,
				collectibleItemId,
				p5,
				p6,
				p11,
				p7,
				name,
				options,
				v11,
				module2.GetItemSubType(v7, v8),
				p4
			))
		end

		local v13

		if fFlagAXDiscoveryItemPurchaseAttribution then
			local v17 = if p4 then p4.getParam(module7.NavigationParams.fromSurface) else nil
			local v15 = {
				surface = mapMarketplaceSurfaceToUnifiedLoggingSurface(v17),
				itemId = itemId,
				itemType = 0,
				itemPrice = 0,
				assetType = 0,
				bundleType = 0,
				hasWidgetAttribution = 0
			}
			local v18

			if p8 == module7.ItemType.Asset then
				v18 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
			elseif p8 == module7.ItemType.Bundle then
				v18 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
			end

			v15.itemType = v18

			v15.itemPrice = v11

			local v19 = if fFlagAXUnifiedEventStrictPayloads then getMarketplaceUnifiedAssetType(v8.assetType) else v8.assetType
			v15.assetType = v19

			local v20 = if fFlagAXUnifiedEventStrictPayloads then getMarketplaceUnifiedBundleType(v8.bundleType) else v8.bundleType
			v15.bundleType = v20

			v15.hasWidgetAttribution = options ~= nil and options.widgetType ~= nil
			v13 = buildDiscoveryPurchaseAttempt(v15)
		else
			v13 = nil
		end

		local function onBuyItemButtonMounted(p14)
			if p14 then
				local v15 = options or {}

				local join = Cryo.Dictionary.join
				local v17 = if fFlagAXUnifiedEventStrictPayloads and itemId ~= nil then tostring(itemId) else itemId
				local v18

				if p8 == module7.ItemType.Asset then
					v18 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
				elseif p8 == module7.ItemType.Bundle then
					v18 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
				end

				local v19

				if not v15.widgetType then
					if fFlagAXUnifiedEventStrictPayloads then
						v19 = getMarketplaceUnifiedAssetType(v8.assetType)
					else
						v19 = v8.assetType
					end
				end

				local v20

				if v15.widgetType then
					if fFlagAXUnifiedEventStrictPayloads then
						v20 = getMarketplaceUnifiedAssetType(v8.assetType)
					else
						v20 = v8.assetType
					end
				end

				local v21

				if not v15.widgetType then
					if fFlagAXUnifiedEventStrictPayloads then
						v21 = getMarketplaceUnifiedBundleType(v8.bundleType)
					else
						v21 = v8.bundleType
					end
				end

				local v22

				if v15.widgetType then
					if fFlagAXUnifiedEventStrictPayloads then
						v22 = getMarketplaceUnifiedBundleType(v8.bundleType)
					else
						v22 = v8.bundleType
					end
				end

				local v16 = {
					itemId = v17,
					itemType = v18,
					assetType = v19,
					widgetAssetType = v20,
					bundleType = v21,
					widgetBundleType = v22,
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
					surface = 0,
					cartId = 0,
					widgetItemPrice = 0,
					organicItemPrice = 0
				}

				local v24 = if p4 then p4.getParam(module7.NavigationParams.fromSurface) else nil
				v16.surface = mapMarketplaceSurfaceToUnifiedLoggingSurface(v24)
					or getUnifiedLoggingSurfaceForRoute(p7)
				local v25 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v16.cartId = v25
				local v26 = if v15.widgetType then v11 else nil
				v16.widgetItemPrice = v26
				local v27 = if not v15.widgetType then v11 else nil
				v16.organicItemPrice = v27
				local v28 = join(v15, v16)

				local v30 = {
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME,
					skipTapDetection = 0
				}
				local v31 = if fFlagAXDiscoveryItemPurchaseAttribution then v13 ~= nil else nil
				v30.skipTapDetection = v31
				addUnifiedEventLogging({ current = p14 }, v28, v30)
			end
		end
		local fn = nil

		fn = fFlagAXDiscoveryItemPurchaseAttribution and v13 and function()
			local join = Cryo.Dictionary.join
			local v17 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
			v5(join(v13, { cartId = v17 }))
		end or fn

		local function onFlowComplete()
			object:dispatch(module6())
		end

		local v14 = fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
			and v8.expirationTime ~= nil
			and true
			or fFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration

		local function fn2()
			return Promise.resolve(buildUnifiedPurchaseProductInfo(
				v8,
				collectibleProductId,
				v11,
				v6,
				v7,
				p12
			))
		end

		local v16 = {
			subtitleView = if fFlagPurchasePromptSubtitleForTimedOptions then p13 else nil,
			productPayload = 0,
			purchaseCallbacks = 0,
			postPurchaseActions = 0,
			purchaseAnalyticsMetadata = 0,
			purchaseOptions = 0
		}

		local v18 = {
			id = v6,
			kind = v7,
			equipIfPurchased = false,
			isRobloxPurchase = true,
			collectibleItemId = v8.collectibleItemId,
			collectibleItemInstanceId = collectibleInstanceId,
			collectibleProductId = collectibleProductId,
			isPurchaseFromResale = 0,
			expectedPrice = 0,
			timedOptionDays = 0,
			deepLinkId = 0
		}

		if not fFlagBlackbirdUpsellGateResalePurchaseType then
			v12 = nil
		end

		v18.isPurchaseFromResale = v12
		v18.expectedPrice = v11
		v18.timedOptionDays = if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then p12 else nil

		local v20 = if fFlagEnableMarketplacePurchaseDeepLinkAttribution and p4 then p4.getParam(module7.NavigationParams.deepLinkId) else nil
		v18.deepLinkId = v20
		v16.productPayload = v18

		if not fFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration then
			fn2 = nil
		end

		v16.purchaseCallbacks = {
			onFlowComplete = onFlowComplete,
			onPurchaseSuccess = onPurchaseSuccess,
			onBuyItemButtonMounted = onBuyItemButtonMounted,
			onPurchaseAttempt = fn,
			fetchProductInfo = fn2
		}
		local itemSubType = module2.GetItemSubType(v7, v8)

		v16.postPurchaseActions = v7 == module7.ItemType.Asset
			and itemSubType ~= module7.AssetTypeIdStrings.EmoteAnimation
			and {
				{
					label = localization:Format("Feature.Catalog.Label.WearAfterPurchase"),
					actionKey = module7.WearAfterPurchasePostPurchaseActionKey,
					isActionSelected = true
				}
			}

		v16.purchaseAnalyticsMetadata = { surface = productPurchaseSurface.Catalog }
		local v23

		if
			fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
			or fFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration
			or shouldFetchCartPricing ~= nil
		then
			v23 = {
				shouldSkipOwnershipCheck = v14,
				providedRobuxBalance = 0,
				completionMessage = 0,
				skipPurchaseSuccessModal = 0,
				shouldFetchCartPricing = 0
			}

			if not fFlagUnifiedPurchaseOptimizeTTIMarketplaceIntegration then
				v10 = nil
			end

			v23.providedRobuxBalance = v10

			local v24 = if fFlagPurchaseModalTimedOptionExtension and v8.expirationTime ~= nil then localization:Format(
				"Feature.Durables.PurchaseModal.SuccessMessage",
				{ itemName = v8.name, number = tostring(p12) }
			) else nil
			v23.completionMessage = v24

			v23.skipPurchaseSuccessModal = fFlagSkipCompletionModalForMarketplace and true or nil
			v23.shouldFetchCartPricing = shouldFetchCartPricing
		end

		v16.purchaseOptions = v23
		object:dispatch(module8(v16, fFlagAddPerformanceMetricsToUnifiedPurchaseModal and true or nil))
	end
end
