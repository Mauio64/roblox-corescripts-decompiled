local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module2 = require("@luauforge/bundled/eeH")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/dMx")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
require("@luauforge/bundled/dMa")

local module6 = require("@luauforge/bundled/eda")
local module7 = require("@luauforge/bundled/fvF")
local module8 = require("@luauforge/bundled/geT")
local cartIdService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Lib.CartIdService

local module9 = require("@luauforge/deferred/fvm")
local module10 = require("@luauforge/bundled/fvl")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventLog

local buildDiscoveryPurchaseAttempt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").buildDiscoveryPurchaseAttempt

local v5 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendPassthroughUnifiedEventLog
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local unifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.UnifiedEventLoggingUtils

local getMarketplaceUnifiedLookType = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.getMarketplaceUnifiedLookType

local mapMarketplaceSurfaceToUnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.mapMarketplaceSurfaceToUnifiedLoggingSurface

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants

local productPurchaseSurface = require("@luauforge/deferred/fvp").Enums.ProductPurchaseSurface

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

if not fFlagAXUnifiedEventStrictPayloads then
	v5 = sendUnifiedEventLog
end

local useAvatarSaveContext = require("@luauforge/bundled/gfT").Context.useAvatarSaveContext

local module11 = require("@luauforge/bundled/dOj")
local module12 = require("@luauforge/bundled/dNQ")
local module13 = require("@luauforge/deferred/gnV")
local module14 = require("@luauforge/deferred/gnW")

local module15 = require("@luauforge/deferred/gnY")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local defineFastFlag = game:DefineFastFlag("AXFixUnifiedPurchaseFlowSessionTag", false)

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents

local fFlagAXRenameBackToAddToAvatar = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRenameBackToAddToAvatar

local fFlagAXDiscoveryItemPurchaseAttribution = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXDiscoveryItemPurchaseAttribution

local fFlagSkipCompletionModalForMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSkipCompletionModalForMarketplace

local defineFastFlag2 = game:DefineFastFlag("HideLookDiscountPercentWithIneligibleItems", false)

local fFlagPurchasePromptFetchCartPricingForLooks = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks

local fFlagAXFixHomeAvatarsUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixHomeAvatarsUnifiedPurchase
local defineFastFlag3 = game:DefineFastFlag("AXFetchCartPricingForLooksExposure", false)
local fFlagMomentsAvatarLookTryOn = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsAvatarLookTryOn

local fFlagAXEnableUnifiedLoggingAvatarMoment = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableUnifiedLoggingAvatarMoment

local defineFastString = game:DefineFastString(
	"AXFetchCartPricingForLooksLayerName",
	"AvatarExperience.UA.MarketplaceView"
)

local useShouldFetchCartPricingForLookPurchasePrompt = AvatarExperienceCatalog.Hooks.useShouldFetchCartPricingForLookPurchasePrompt

local function getAvatarEditorCategoryIndexesByName(p2, p3)
	local v6 = module11()
	local v7 = nil
	local v8 = nil

	for k, v10 in v6 do
		if v10.Name ~= p2 then
			continue
		end

		if p3 and v10.Subcategories then
			for k2, subcategory in v10.Subcategories do
				if subcategory.Name == p3 then
					return k, k2
				end
			end

			return k, v7
		end

		v8 = k
		break
	end

	return v8, v7
end

local function isMomentsShopLook(p2): boolean
	return p2 ~= nil and p2.surface == unifiedLoggingSurface.SHOP_AVATAR_MOMENT
end

local function useLookUnifiedPurchaseFlow(state)
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = useAvatarRoute()
	local v9 = module2(module6)
	local v10 = module2(module7)
	local v11 = module2(module8)
	local v12 = useAvatarSaveContext()
	local v13

	if fFlagPurchasePromptFetchCartPricingForLooks then
		v13 = useSelector(function(p2)
			return p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
		end)
	else
		v13 = nil
	end

	local v14 = useShouldFetchCartPricingForLookPurchasePrompt()
	local v15 = fFlagPurchasePromptFetchCartPricingForLooks and state.isTryOnFromOutsideAX and true or v14

	local function fn()
		local purchaseInfoForLookId, v16, v17, v18 = module13.getPurchaseInfoForLookId(
			state.tryOnItems,
			state.lookDetailsObj,
			state.lookId
		)
		local joined

		if state.lookAnalyticsInfo then
			joined = Cryo.Dictionary.join(state.lookAnalyticsInfo, {
				totalRobux = state.totalPrice,
				assetIds = v18
			})
		end

		if joined and #v18 > 0 then
			v10.widgetInteractionV2(joined, widgetConstants.ActionType.PURCHASE_ATTEMPT)
		end

		if fFlagAXFixHomeAvatarsUnifiedPurchase then
			local surface = state.lookAnalyticsInfo and state.lookAnalyticsInfo.surface
				or v7.getParam(module4.NavigationParams.fromSurface)

			if fFlagAXDiscoveryItemPurchaseAttribution then
				surface = mapMarketplaceSurfaceToUnifiedLoggingSurface(surface)
			end

			local v19 = not (state.lookAnalyticsInfo == nil) and state.lookAnalyticsInfo.widgetType ~= nil

			if fFlagAXDiscoveryItemPurchaseAttribution then
				local v21 = {
					surface = surface,
					itemId = state.lookId,
					itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
					itemPrice = state.totalPrice,
					hasWidgetAttribution = v19,
					cartId = 0
				}

				local v22 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v21.cartId = v22
				local v23 = buildDiscoveryPurchaseAttempt(v21)

				if v23 then
					v5(v23)
				end
			elseif
				(surface == unifiedLoggingSurface.DISCOVERY_HOMEPAGE or surface == unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS)
				and not v19
				and state.lookId
			then
				local v21 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
					itemId = state.lookId,
					itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
					surface = surface,
					organicItemPrice = state.totalPrice,
					cartId = 0
				}

				local v22 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v21.cartId = v22
				sendUnifiedEventLog(v21)
			end
		end

		if fFlagAXEnableUnifiedLoggingAvatarMoment and state.lookId then
			local lookAnalyticsInfo = state.lookAnalyticsInfo
			local v19

			if lookAnalyticsInfo == nil then
				v19 = false
			else
				v19 = lookAnalyticsInfo.surface == unifiedLoggingSurface.SHOP_AVATAR_MOMENT
			end

			if v19 then
				local shopMetadata = state.lookAnalyticsInfo.shopMetadata
				local v20 = state.lookDetailsObj and state.lookDetailsObj[state.lookId]
				local v22 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
					itemId = state.lookId,
					itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
					surface = unifiedLoggingSurface.SHOP_AVATAR_MOMENT,
					organicItemPrice = state.totalPrice,
					organicLookType = 0,
					cartId = 0,
					elementMetadata = 0
				}
				local v23

				if v20 and v20.lookType then
					if fFlagAXUnifiedEventStrictPayloads then
						v23 = getMarketplaceUnifiedLookType(v20.lookType)
					else
						v23 = unifiedEventLoggingUtils.formatLookTypeAttribute(v20.lookType)
					end
				end

				v22.organicLookType = v23

				local v24 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v22.cartId = v24
				local v25 = if shopMetadata then HttpService:JSONEncode(shopMetadata) else nil
				v22.elementMetadata = v25
				sendUnifiedEventLog(v22)
			end
		end
	end

	local v18 = React.useCallback(fn, {
		state.tryOnItems,
		state.lookDetailsObj,
		state.lookId,
		state.lookAnalyticsInfo,
		state.totalPrice,
		v10,
		if fFlagAXFixHomeAvatarsUnifiedPurchase then v7 else nil
	})

	local ref = if fFlagMomentsAvatarLookTryOn then React.useRef(false) else nil

	local useCallback2 = React.useCallback
	local function fn2()
		v6(module10())

		if fFlagMomentsAvatarLookTryOn and ref then
			local current = ref.current
			ref.current = false

			if current and state.onPurchaseFlowCompleted then
				state.onPurchaseFlowCompleted()
			end
		end
	end
	local v20 = if fFlagMomentsAvatarLookTryOn then state.onPurchaseFlowCompleted else nil
	local v21 = useCallback2(fn2, { v6, v20 })

	local function fn3(p2)
		if fFlagAXMISEnableMultiShoppingUnifiedEvents and not state.lookAnalyticsInfo then
			state.lookAnalyticsInfo = {}
		end

		if p2 and state.lookAnalyticsInfo then
			local v22 = { current = p2 }
			local lookType

			if state.lookId and state.lookDetailsObj and state.lookDetailsObj[state.lookId] then
				lookType = state.lookDetailsObj[state.lookId].lookType
			end

			if defineFastFlag then
				local v23

				if fFlagAXFixHomeAvatarsUnifiedPurchase then
					local surface = state.lookAnalyticsInfo.surface
						or v7.getParam(module4.NavigationParams.fromSurface)

					if fFlagAXDiscoveryItemPurchaseAttribution then
						surface = mapMarketplaceSurfaceToUnifiedLoggingSurface(surface)
					end

					if state.lookId == nil or state.lookAnalyticsInfo.widgetType ~= nil then
						v23 = false
					else
						v23 = surface == unifiedLoggingSurface.DISCOVERY_HOMEPAGE
							or surface == unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
					end
				end

				if fFlagAXEnableUnifiedLoggingAvatarMoment and state.lookId ~= nil then
					local lookAnalyticsInfo2 = state.lookAnalyticsInfo
					v23 = lookAnalyticsInfo2 ~= nil
						and lookAnalyticsInfo2.surface == unifiedLoggingSurface.SHOP_AVATAR_MOMENT
						or v23
				end

				local join = Cryo.Dictionary.join
				local lookAnalyticsInfo2 = state.lookAnalyticsInfo
				local v24 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
					cartId = 0,
					itemId = 0,
					itemType = 0,
					organicLookType = 0,
					widgetLookType = 0,
					widgetItemPrice = 0,
					organicItemPrice = 0
				}
				local v25 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v24.cartId = v25

				local v26 = if fFlagAXUnifiedEventStrictPayloads then state.lookAnalyticsInfo.itemId or state.lookId else nil
				v24.itemId = v26

				v24.itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
				local v27

				if not (state.lookAnalyticsInfo.widgetType or not lookType) then
					if fFlagAXUnifiedEventStrictPayloads then
						v27 = getMarketplaceUnifiedLookType(lookType)
					else
						v27 = unifiedEventLoggingUtils.formatLookTypeAttribute(lookType)
					end
				end

				v24.organicLookType = v27
				local v28

				if state.lookAnalyticsInfo.widgetType and lookType then
					if fFlagAXUnifiedEventStrictPayloads then
						v28 = getMarketplaceUnifiedLookType(lookType)
					else
						v28 = unifiedEventLoggingUtils.formatLookTypeAttribute(lookType)
					end
				end

				v24.widgetLookType = v28

				local v29 = if state.lookAnalyticsInfo.widgetType then state.totalPrice else nil
				v24.widgetItemPrice = v29
				local v30 = if not state.lookAnalyticsInfo.widgetType then state.totalPrice else nil
				v24.organicItemPrice = v30
				addUnifiedEventLogging(v22, join(lookAnalyticsInfo2, v24), {
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME,
					skipTapDetection = v23
				})
			else
				local join = Cryo.Dictionary.join
				local lookAnalyticsInfo2 = state.lookAnalyticsInfo
				local v23 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
					cartId = 0,
					itemId = 0,
					itemType = 0,
					organicLookType = 0,
					widgetLookType = 0,
					widgetItemPrice = 0,
					organicItemPrice = 0,
					sessionTagName = 0
				}
				local v24 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v23.cartId = v24

				local v25 = if fFlagAXUnifiedEventStrictPayloads then state.lookAnalyticsInfo.itemId or state.lookId else nil
				v23.itemId = v25

				v23.itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
				local v26

				if not (state.lookAnalyticsInfo.widgetType or not lookType) then
					if fFlagAXUnifiedEventStrictPayloads then
						v26 = getMarketplaceUnifiedLookType(lookType)
					else
						v26 = unifiedEventLoggingUtils.formatLookTypeAttribute(lookType)
					end
				end

				v23.organicLookType = v26
				local v27

				if state.lookAnalyticsInfo.widgetType and lookType then
					if fFlagAXUnifiedEventStrictPayloads then
						v27 = getMarketplaceUnifiedLookType(lookType)
					else
						v27 = unifiedEventLoggingUtils.formatLookTypeAttribute(lookType)
					end
				end

				v23.widgetLookType = v27

				local v28 = if state.lookAnalyticsInfo.widgetType then state.totalPrice else nil
				v23.widgetItemPrice = v28
				local v29 = if not state.lookAnalyticsInfo.widgetType then state.totalPrice else nil
				v23.organicItemPrice = v29
				v23.sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
				addUnifiedEventLogging(
					v22,
					(join(lookAnalyticsInfo2, v23, {
						sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
					}))
				)
			end
		end
	end

	local v24 = React.useCallback(fn3, {
		state.totalPrice,
		state.lookAnalyticsInfo,
		state.lookDetailsObj,
		state.lookId,
		if fFlagAXFixHomeAvatarsUnifiedPurchase then v7 else nil
	})

	local v25 = React.useCallback(function(p2, p3)
		if fFlagMomentsAvatarLookTryOn and ref then
			ref.current = true
		end

		local ownedTryOnItems = module15.getOwnedTryOnItems(
			state.tryOnItems,
			state.lookDetailsObj,
			state.lookId
		)
		local isTryOnFromOutsideAX = state.isTryOnFromOutsideAX

		local purchaseInfoForLookId, v26, v27, v28 = module13.getPurchaseInfoForLookId(
			state.tryOnItems,
			state.lookDetailsObj,
			state.lookId
		)

		local v29 = if state.lookAnalyticsInfo then Cryo.Dictionary.join(state.lookAnalyticsInfo, {
			totalRobux = state.totalPrice,
			assetIds = v28
		}) else nil

		v6(module14(
			p2,
			p3,
			v9,
			state.lookId,
			state.totalPrice,
			state.tryOnItems,
			ownedTryOnItems,
			v12,
			isTryOnFromOutsideAX,
			v29,
			v7,
			v10,
			v11,
			v8
		))
	end, {
		v6,
		v9,
		state.lookId,
		state.lookAnalyticsInfo,
		state.totalPrice,
		state.tryOnItems,
		v12,
		v7,
		v10,
		v11,
		state.lookDetailsObj,
		v8,
		state.isTryOnFromOutsideAX
	})

	local useCallback4 = React.useCallback
	local function fn4()
		local v26 = {}
		local lookDiscounts

		if
			state.lookId
			and state.lookDetailsObj[state.lookId]
			and state.lookDetailsObj[state.lookId].lookDiscounts
		then
			lookDiscounts = state.lookDetailsObj[state.lookId].lookDiscounts
		end

		if lookDiscounts then
			local lookDiscount = lookDiscounts[1]
			v26.Type = lookDiscount.discountCampaign
			local v27 = if state.originalPrice then state.originalPrice - state.totalPrice else nil
			v26.AmountInRobux = v27

			v26.Percent = defineFastFlag2 and state.hasNonDiscountedItems and 0
				or lookDiscount.robuxDiscountPercentage
		end

		return Promise.resolve({
			PriceInRobux = state.totalPrice,
			IsForSale = true,
			Name = "Looks",
			BasePriceInRobux = state.originalPrice,
			PriceDiscountDetails = { v26 }
		})
	end

	local lookId3 = state.lookId
	local lookDetailsObj3 = state.lookDetailsObj
	local originalPrice = state.originalPrice
	local totalPrice3 = state.totalPrice
	local v27 = if defineFastFlag2 then state.hasNonDiscountedItems else nil
	local v28 = useCallback4(fn4, {
		lookId3,
		lookDetailsObj3,
		originalPrice,
		totalPrice3,
		v27
	})

	local function fn5()
		if not state.lookId then
			return
		end

		local v29

		if
			fFlagPurchasePromptFetchCartPricingForLooks
			and module13.getCartPricingRequestedItemsForLookId
		then
			v29 = module13.getCartPricingRequestedItemsForLookId(
				state.tryOnItems,
				state.lookDetailsObj,
				state.lookId
			)
		end

		local purchaseInfoForLookId, v30, v31, v32, v33 = module13.getPurchaseInfoForLookId(
			state.tryOnItems,
			state.lookDetailsObj,
			state.lookId
		)
		local v34

		if
			fFlagAXCatalogMakeupSupport
			and state.lookDetailsObj
			and state.lookDetailsObj[state.lookId]
			and state.lookDetailsObj[state.lookId].lookType
		then
			v34 = state.lookDetailsObj[state.lookId].lookType == module4.LookType.Makeup
		end

		if defineFastFlag3 then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
		end

		local v38 = {
			kind = "Look",
			id = state.lookId,
			expectedPrice = state.totalPrice,
			salesLocationId = 0,
			excludedAssetIds = v30,
			excludedBundleIds = v31,
			timedOptions = 0,
			cartPricingRequestedItems = 0,
			bulkPurchaseLineItems = 0
		}

		if not (v33 and #v33 > 0) then
			v33 = nil
		end

		v38.timedOptions = v33

		if not (fFlagPurchasePromptFetchCartPricingForLooks and v29 and #v29 > 0) then
			v29 = nil
		end

		v38.cartPricingRequestedItems = v29

		local v39 = if fFlagPurchasePromptFetchCartPricingForLooks then module13.getPurchaseLineItemsForLookId(
			state.tryOnItems,
			state.lookDetailsObj,
			state.lookId,
			v13
		) else nil
		v38.bulkPurchaseLineItems = v39
		local v37 = {
			productPayload = v38,
			purchaseCallbacks = {
				onFlowComplete = v21,
				onPurchaseAttempt = v18,
				onPurchaseSuccess = v25,
				onBuyItemButtonMounted = v24,
				fetchProductInfo = v28
			},
			postPurchaseActions = 0,
			purchaseAnalyticsMetadata = 0,
			purchaseOptions = 0
		}
		local v42

		if fFlagAXCatalogMakeupSupport and v34 then
			v42 = state.localized.wearAfterPurchaseMakeupLabel
		elseif fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			v42 = state.localized.wearAvatarAfterPurchaseLabel
		else
			v42 = state.localized.wearAfterPurchaseLabel
		end

		local v41 = {
			label = v42,
			actionKey = module4.WearAfterPurchasePostPurchaseActionKey,
			isActionSelected = true
		}
		local v44

		if fFlagAXCatalogMakeupSupport and v34 then
			v44 = state.localized.saveAsMakeupLookLabel
		elseif fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			if fFlagAXRenameBackToAddToAvatar then
				v44 = state.localized.addToMyAvatarsLabel
			else
				v44 = state.localized.saveAsCharacterLabel
			end
		else
			v44 = state.localized.addToMyAvatarsLabel
		end

		v37.postPurchaseActions = {
			v41,
			{
				label = v44,
				actionKey = module4.SaveAsCharacterPostPurchaseActionKey,
				isActionSelected = true
			}
		}

		v37.purchaseAnalyticsMetadata = { surface = productPurchaseSurface.Catalog }

		v37.purchaseOptions = {
			shouldSkipOwnershipCheck = true,
			skipPurchaseSuccessModal = fFlagSkipCompletionModalForMarketplace and true or nil,
			shouldFetchCartPricing = v15
		}
		v6(module9(v37, fFlagAddPerformanceMetricsToUnifiedPurchaseModal and true or nil))
	end

	local v31 = React.useCallback(fn5, {
		v6,
		state.lookId,
		state.totalPrice,
		state.tryOnItems,
		state.lookDetailsObj,
		v9,
		v12,
		v7,
		v10,
		v11,
		state.localized,
		v8,
		state.isTryOnFromOutsideAX,
		v21,
		v18,
		v25,
		v24,
		v28,
		v15,
		if fFlagPurchasePromptFetchCartPricingForLooks then v13 else nil
	})

	return {
		onPurchaseAttempt = v18,
		onFlowComplete = v21,
		onBuyItemButtonMounted = v24,
		onPurchaseSuccess = v25,
		openUnifiedPurchasePrompt = v31,
		onButtonPressWithUnifiedPurchaseFlow = React.useCallback(function()
			if state.userRobux < state.totalPrice then
				v10.sendAXCounter(module5.Counter.AvatarWidget.AvatarsWidgetBuyClickedInsufficientRobux)
			end

			if not Cryo.isEmpty(state.itemsToPurchase) or state.lookId == nil then
				v31()

				return
			end

			local characterKey = module12.CharacterKey
			local v32 = module11()
			local v34 = nil

			for k, v36 in v32 do
				if v36.Name == characterKey then
					v34 = k
					break
				end
			end

			local leaveCatalogToAvatarPrompt = avatarScreen.LeaveCatalogToAvatarPrompt
			local v36 = {
				onOverlayClosed = state.onOverlayClosed,
				categoryOverride = v34,
				subcategoryOverride = nil
			}

			v10.sendAXCounter(module5.Counter.AvatarWidget.AvatarsWidgetBuyClickedNoItemsToPurchase)

			v6(navigateWithLock(function()
				v7.navigate(leaveCatalogToAvatarPrompt, v36)
			end))
		end, {
			state.tryOnItems,
			state.lookDetailsObj,
			state.lookId,
			state.userRobux,
			v6,
			v7,
			state.onOverlayClosed,
			v10,
			v8,
			state.itemsToPurchase,
			state.totalPrice,
			v31
		})
	}
end

return useLookUnifiedPurchaseFlow
