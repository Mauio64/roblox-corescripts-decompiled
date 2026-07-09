local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants

require(Modules.AvatarExperience.Common.Reducers.Looks)

local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local CartIdService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Lib.CartIdService
local OpenCentralOverlayForUnifiedPurchasePrompt = require(Modules.LuaApp.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLoggingUtils = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Utils.UnifiedEventLoggingUtils
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local ProductPurchaseSurface = require(CorePackages.Workspace.Packages.PurchasePromptLite).Enums.ProductPurchaseSurface
local FFlagAXCatalogMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport
local useAvatarSaveContext = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.useAvatarSaveContext
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local LookUtils = require(Modules.AvatarExperience.Common.Util.LookUtils)
local HandleLooksPurchaseSuccess = require(Modules.AvatarExperience.Catalog.Thunks.HandleLooksPurchaseSuccess)
local LookDetailsBottomBarUtils = require(Modules.AvatarExperience.Catalog.Components.LookDetails.LookDetailsBottomBarUtils)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local v38 = game:DefineFastFlag("AXFixUnifiedPurchaseFlowSessionTag", false)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXRenameBackToAddToAvatar = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRenameBackToAddToAvatar
local FFlagSkipCompletionModalForMarketplace = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSkipCompletionModalForMarketplace
local v42 = game:DefineFastFlag("HideLookDiscountPercentWithIneligibleItems", false)
local FFlagPurchasePromptFetchCartPricingForLooks = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPurchasePromptFetchCartPricingForLooks
local FFlagPurchasePromptFetchCartPricing = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPurchasePromptFetchCartPricing
local useShouldFetchCartPricingForLookPurchasePrompt = AvatarExperienceCatalog.Hooks.useShouldFetchCartPricingForLookPurchasePrompt

local function getAvatarEditorCategoryIndexesByName(s1: string, s2: string?) -- line: 77
	-- upvalues: GetAvatarEditorCategories (copy)
	local v50 = nil
	local v51 = nil

	for v52, v53 in (GetAvatarEditorCategories()) do
		if s1 == v53.Name then
			v50 = v52

			if not s2 or not v53.Subcategories then
				return v50, v51
			end

			for v54, v55 in v53.Subcategories do
				if s2 == v55.Name then
					return v50, v54
				end
			end

			return v50, v51
		end
	end

	return v50, v51
end
local function useLookUnifiedPurchaseFlow(t1: {[any]: any}) -- line: 121
	-- upvalues: useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), Analytics2 (copy), useAvatarSaveContext (copy), FFlagPurchasePromptFetchCartPricing (copy), useShouldFetchCartPricingForLookPurchasePrompt (copy), React (copy), LookUtils (copy), Cryo (copy), WidgetConstants (copy), CloseCentralOverlay (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), v38 (copy), UnifiedEventLogEnums (copy), CartIdService (copy), UnifiedEventLoggingUtils (copy), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy), LookDetailsBottomBarUtils (copy), HandleLooksPurchaseSuccess (copy), v42 (copy), Promise (copy), FFlagPurchasePromptFetchCartPricingForLooks (copy), FFlagAXCatalogMakeupSupport (copy), Constants (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagAXRenameBackToAddToAvatar (copy), ProductPurchaseSurface (copy), FFlagSkipCompletionModalForMarketplace (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), Constants2 (copy), Constants3 (copy), GetAvatarEditorCategories (copy), AvatarScreen (copy), NavigateWithLock (copy)
	local v57 = useDispatch()
	local v58 = useNavigation()
	local v59 = useAvatarRoute()
	local v60 = useRoactService(RoactNetworking)
	local v61 = useRoactService(Analytics)
	local v62 = useRoactService(Analytics2)
	local v63 = useAvatarSaveContext()
	local v64 = if not FFlagPurchasePromptFetchCartPricing then nil else useShouldFetchCartPricingForLookPurchasePrompt()
	local v65 = React.useCallback(function() -- line: 139
		-- upvalues: LookUtils (copy), t1 (copy), Cryo (copy), v61 (copy), WidgetConstants (copy)
		local _, _, _, v75 = LookUtils.getPurchaseInfoForLookId(t1.tryOnItems, t1.lookDetailsObj, t1.lookId)
		local v76 = if not t1.lookAnalyticsInfo then nil else Cryo.Dictionary.join(t1.lookAnalyticsInfo, {
			totalRobux = t1.totalPrice,
			assetIds = v75
		})

		if v76 and #v75 > 0 then
			v61.widgetInteractionV2(v76, WidgetConstants.ActionType.PURCHASE_ATTEMPT)
		end
	end, {
		t1.tryOnItems,
		t1.lookDetailsObj,
		t1.lookId,
		t1.lookAnalyticsInfo,
		t1.totalPrice,
		v61
	})
	local v66 = React.useCallback(function() -- line: 164
		-- upvalues: v57 (copy), CloseCentralOverlay (copy)
		v57(CloseCentralOverlay())
	end, { v57 })
	local v67 = React.useCallback(function(p1) -- line: 169
		-- upvalues: FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), t1 (copy), v38 (copy), Cryo (copy), UnifiedEventLogEnums (copy), CartIdService (copy), UnifiedEventLoggingUtils (copy), addUnifiedEventLogging (copy), UnifiedEventLogConstants (copy)
		if FFlagAXMISEnableMultiShoppingUnifiedEvents and not t1.lookAnalyticsInfo then
			t1.lookAnalyticsInfo = {}
		end

		if p1 and t1.lookAnalyticsInfo then
			local t2 = {
				current = p1
			}
			local v79 = if not t1.lookId or (not t1.lookDetailsObj or not t1.lookDetailsObj[t1.lookId]) then nil else t1.lookDetailsObj[t1.lookId].lookType

			if v38 then
				local v80 = Cryo.Dictionary.join(t1.lookAnalyticsInfo, {
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
					cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
					itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
					organicLookType = if t1.lookAnalyticsInfo.widgetType or not v79 then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(v79),
					widgetLookType = if not t1.lookAnalyticsInfo.widgetType or not v79 then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(v79),
					widgetItemPrice = if not t1.lookAnalyticsInfo.widgetType then nil else t1.totalPrice,
					organicItemPrice = if not t1.lookAnalyticsInfo.widgetType then t1.totalPrice else nil
				})

				addUnifiedEventLogging(t2, v80, {
					sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
				})

				return
			end

			local v81 = Cryo.Dictionary.join(t1.lookAnalyticsInfo, {
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
				cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
				organicLookType = if t1.lookAnalyticsInfo.widgetType or not v79 then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(v79),
				widgetLookType = if not t1.lookAnalyticsInfo.widgetType or not v79 then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(v79),
				widgetItemPrice = if not t1.lookAnalyticsInfo.widgetType then nil else t1.totalPrice,
				organicItemPrice = if not t1.lookAnalyticsInfo.widgetType then t1.totalPrice else nil,
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			}, {
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})

			addUnifiedEventLogging(t2, v81)
		end
	end, {
		t1.totalPrice,
		t1.lookAnalyticsInfo,
		t1.lookDetailsObj,
		t1.lookId
	})
	local v68 = React.useCallback(function(p2, p3) -- line: 232
		-- upvalues: LookDetailsBottomBarUtils (copy), t1 (copy), LookUtils (copy), Cryo (copy), v57 (copy), HandleLooksPurchaseSuccess (copy), v60 (copy), v63 (copy), v58 (copy), v61 (copy), v62 (copy), v59 (copy)
		local v84 = LookDetailsBottomBarUtils.getOwnedTryOnItems(t1.tryOnItems, t1.lookDetailsObj, t1.lookId)
		local isTryOnFromOutsideAX = t1.isTryOnFromOutsideAX
		local _, _, _, v89 = LookUtils.getPurchaseInfoForLookId(t1.tryOnItems, t1.lookDetailsObj, t1.lookId)
		local v90 = if not t1.lookAnalyticsInfo then nil else Cryo.Dictionary.join(t1.lookAnalyticsInfo, {
			totalRobux = t1.totalPrice,
			assetIds = v89
		})

		v57(HandleLooksPurchaseSuccess(p2, p3, v60, t1.lookId, t1.totalPrice, t1.tryOnItems, v84, v63, isTryOnFromOutsideAX, v90, v58, v61, v62, v59))
	end, {
		v57,
		v60,
		t1.lookId,
		t1.lookAnalyticsInfo,
		t1.totalPrice,
		t1.tryOnItems,
		v63,
		v58,
		v61,
		v62,
		t1.lookDetailsObj,
		v59,
		t1.isTryOnFromOutsideAX
	})
	local v69 = React.useCallback(function() -- line: 284
		-- upvalues: t1 (copy), v42 (copy), Promise (copy)
		local t3 = {}
		local v92 = if not t1.lookId or (not t1.lookDetailsObj[t1.lookId] or not t1.lookDetailsObj[t1.lookId].lookDiscounts) then nil else t1.lookDetailsObj[t1.lookId].lookDiscounts

		if v92 then
			local v93 = v92[1]

			t3.Type = v93.discountCampaign
			t3.AmountInRobux = if not t1.originalPrice then nil else t1.originalPrice - t1.totalPrice
			t3.Percent = if not v42 or not t1.hasNonDiscountedItems then v93.robuxDiscountPercentage else 0
		end

		return Promise.resolve({
			IsForSale = true,
			Name = "Looks",
			PriceInRobux = t1.totalPrice,
			BasePriceInRobux = t1.originalPrice,
			PriceDiscountDetails = { t3 }
		})
	end, {
		t1.lookId,
		t1.lookDetailsObj,
		t1.originalPrice,
		t1.totalPrice,
		if not v42 then nil else t1.hasNonDiscountedItems
	})
	local v70 = React.useCallback(function() -- line: 325
		-- upvalues: t1 (copy), FFlagPurchasePromptFetchCartPricingForLooks (copy), LookUtils (copy), FFlagAXCatalogMakeupSupport (copy), Constants (copy), v57 (copy), OpenCentralOverlayForUnifiedPurchasePrompt (copy), v66 (copy), v65 (copy), v68 (copy), v67 (copy), v69 (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagAXRenameBackToAddToAvatar (copy), ProductPurchaseSurface (copy), FFlagSkipCompletionModalForMarketplace (copy), v64 (copy), FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy)
		if not t1.lookId then
			return
		end

		local v94 = if not FFlagPurchasePromptFetchCartPricingForLooks or not LookUtils.getCartPricingRequestedItemsForLookId then nil else LookUtils.getCartPricingRequestedItemsForLookId(t1.tryOnItems, t1.lookDetailsObj, t1.lookId)
		local _, v96, v97, _, v99 = LookUtils.getPurchaseInfoForLookId(t1.tryOnItems, t1.lookDetailsObj, t1.lookId)
		local v100 = if not FFlagAXCatalogMakeupSupport or (not t1.lookDetailsObj or (not t1.lookDetailsObj[t1.lookId] or not t1.lookDetailsObj[t1.lookId].lookType)) then nil else t1.lookDetailsObj[t1.lookId].lookType == Constants.LookType.Makeup

		v57(OpenCentralOverlayForUnifiedPurchasePrompt({
			productPayload = {
				kind = "Look",
				salesLocationId = 0,
				id = t1.lookId,
				expectedPrice = t1.totalPrice,
				excludedAssetIds = v96,
				excludedBundleIds = v97,
				timedOptions = if not v99 or not (#v99 > 0) then nil else v99,
				cartPricingRequestedItems = if not FFlagPurchasePromptFetchCartPricingForLooks or (not v94 or not (#v94 > 0)) then nil else v94
			},
			purchaseCallbacks = {
				onFlowComplete = v66,
				onPurchaseAttempt = v65,
				onPurchaseSuccess = v68,
				onBuyItemButtonMounted = v67,
				fetchProductInfo = v69
			},
			postPurchaseActions = {
				{
					isActionSelected = true,
					label = if not FFlagAXCatalogMakeupSupport or not v100 then if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then t1.localized.wearAfterPurchaseLabel else t1.localized.wearAvatarAfterPurchaseLabel else t1.localized.wearAfterPurchaseMakeupLabel,
					actionKey = Constants.WearAfterPurchasePostPurchaseActionKey
				},
				{
					isActionSelected = true,
					label = if not FFlagAXCatalogMakeupSupport or not v100 then if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then t1.localized.addToMyAvatarsLabel else if not FFlagAXRenameBackToAddToAvatar then t1.localized.saveAsCharacterLabel else t1.localized.addToMyAvatarsLabel else t1.localized.saveAsMakeupLookLabel,
					actionKey = Constants.SaveAsCharacterPostPurchaseActionKey
				}
			},
			purchaseAnalyticsMetadata = {
				surface = ProductPurchaseSurface.Catalog
			},
			purchaseOptions = {
				shouldSkipOwnershipCheck = true,
				skipPurchaseSuccessModal = not not FFlagSkipCompletionModalForMarketplace or nil,
				shouldFetchCartPricing = v64
			}
		}, not not FFlagAddPerformanceMetricsToUnifiedPurchaseModal or nil))
	end, {
		v57,
		t1.lookId,
		t1.totalPrice,
		t1.tryOnItems,
		t1.lookDetailsObj,
		v60,
		v63,
		v58,
		v61,
		v62,
		t1.localized,
		v59,
		t1.isTryOnFromOutsideAX,
		v66,
		v65,
		v68,
		v67,
		v69,
		v64
	})
	local v71 = React.useCallback(function() -- line: 432
		-- upvalues: t1 (copy), v61 (copy), Constants2 (copy), Cryo (copy), Constants3 (copy), GetAvatarEditorCategories (copy), AvatarScreen (copy), v58 (copy), v57 (copy), NavigateWithLock (copy), v70 (copy)
		if t1.userRobux < t1.totalPrice then
			v61.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedInsufficientRobux)
		end

		if Cryo.isEmpty(t1.itemsToPurchase) and t1.lookId ~= nil then
			local CharacterKey = Constants3.CharacterKey
			local v102 = nil

			for v103, v104 in (GetAvatarEditorCategories()) do
				if CharacterKey == v104.Name then
					v102 = v103

					break
				end
			end

			local LeaveCatalogToAvatarPrompt = AvatarScreen.LeaveCatalogToAvatarPrompt
			local t4 = {
				onOverlayClosed = t1.onOverlayClosed,
				categoryOverride = v102,
				subcategoryOverride = nil
			}

			v61.sendAXCounter(Constants2.Counter.AvatarWidget.AvatarsWidgetBuyClickedNoItemsToPurchase)
			v57(NavigateWithLock(function() -- line: 451
				-- upvalues: v58 (copy), LeaveCatalogToAvatarPrompt (copy), t4 (copy)
				v58.navigate(LeaveCatalogToAvatarPrompt, t4)
			end))

			return
		end

		v70()
	end, {
		t1.tryOnItems,
		t1.lookDetailsObj,
		t1.lookId,
		t1.userRobux,
		v57,
		v58,
		t1.onOverlayClosed,
		v61,
		v59,
		t1.itemsToPurchase,
		t1.totalPrice,
		v70
	})

	return {
		onPurchaseAttempt = v65,
		onFlowComplete = v66,
		onBuyItemButtonMounted = v67,
		onPurchaseSuccess = v68,
		openUnifiedPurchasePrompt = v70,
		onButtonPressWithUnifiedPurchaseFlow = v71
	}
end

return useLookUnifiedPurchaseFlow
