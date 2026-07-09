local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local NotificationService = game:GetService("NotificationService")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Promise = require(AvatarExperienceCatalogParent.Promise)
local tutils = require(AvatarExperienceCatalogParent.tutils)
local mutedError = require(AvatarExperienceCatalogParent.Loggers).mutedError

require(AvatarExperienceCatalogParent.Http)

local RoactUtils = require(AvatarExperienceCatalogParent.RoactUtils)
local SignalsReact = require(AvatarExperienceCatalogParent.SignalsReact)
local AvatarExperienceNavigation = require(AvatarExperienceCatalogParent.AvatarExperienceNavigation)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local ToastRodux = require(AvatarExperienceCatalogParent.ToastRodux)
local RobloxSubscriptionPurchaseApp = require(AvatarExperienceCatalogParent.RobloxSubscriptionPurchaseApp)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local SharedFlags = require(AvatarExperienceCatalogParent.SharedFlags)
local RobloxEventReceiver = require(AvatarExperienceCatalogParent.RealtimeDelivery).RobloxEventReceiver

require(AvatarExperienceCatalog.Components.Checkout.CheckoutPage)

local PurchaseItemsSuccessThunk = require(AvatarExperienceCatalog.State.Thunks.PurchaseItemsSuccessThunk)
local SaveAsAvatarThunk = require(AvatarExperienceCatalog.State.Thunks.SaveAsAvatarThunk)
local SaveAsMakeupLookThunk = require(AvatarExperienceCatalog.State.Thunks.SaveAsMakeupLookThunk)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local SetSelectedTimedOption = require(AvatarExperienceCatalog.State.Actions.SetSelectedTimedOption)
local CloseCentralOverlay = require(AvatarExperienceCatalogParent.CentralOverlay).Thunks.CloseCentralOverlay
local Constants = AvatarExperienceCommon.Constants

require(AvatarExperienceCatalog.Requests.PurchaseItems.PurchaseItemsTypes)

local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local ToastType = ToastRodux.Enums.ToastType
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local DiscountTypeEnum = AvatarExperienceCommon.Enums.DiscountTypeEnum
local PurchaseItems = require(AvatarExperienceCatalog.Requests.PurchaseItems)
local getRobloxSubscriptionProducts = RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local mapPurchaseItemsResponse = require(AvatarExperienceCatalog.Requests.PurchaseItems.mapPurchaseItemsResponse)
local getEquippableAssetsFromTryOnItems = require(AvatarExperienceCatalog.Utils.TryOns.getEquippableAssetsFromTryOnItems)
local getTryOnItemsContainsOnlyMakeupTypes = require(AvatarExperienceCatalog.Utils.TryOns.getTryOnItemsContainsOnlyMakeupTypes)
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

require(AvatarExperienceCatalog.Stores.createAXShoppingCartStore)

local getIsInsufficientRobuxError = require(AvatarExperienceCatalog.Requests.PurchaseItems.getIsInsufficientRobuxError)
local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)
local useOffersCartPricingCalculationsForCartItems = require(AvatarExperienceCatalog.Hooks.useOffersCartPricingCalculationsForCartItems)
local useSignalState = SignalsReact.useSignalState
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = require(AvatarExperienceCatalogParent.UniversalAppPolicy).useAppPolicy
local useNavigation = require(AvatarExperienceCatalogParent.Navigation).useNavigation
local useNavigationFocus = require(AvatarExperienceCatalogParent.Navigation).useNavigationFocus
local useSaveOptionsStoredValues = require(AvatarExperienceCatalog.Hooks.useSaveOptionsStoredValues)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local LocalizationRoactContext = require(AvatarExperienceCatalogParent.Localization).LocalizationRoactContext
local AvatarExperienceAnalytics = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics)
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local sendUnifiedEventsForMultiItemShopping = AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping
local getUnifiedEventsForMIS = AvatarExperienceAnalytics.Utils.getUnifiedEventsForMIS
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function selectTryOnLookId(p1) -- line: 88
	return p1.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local u67 = nil

if FFlagAXCatalogMakeupSupport then
	function u67(p2) -- line: 94
		return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
	end
end

local u68 = nil
local u69 = nil

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function u68(p3) -- line: 101
		return p3.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
	end
	function u69(p4) -- line: 105
		return p4.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
	end
end

local function selectAvatarSceneLooks(p5) -- line: 110
	return p5.AvatarExperience.AvatarScene.Looks
end
local function selectTryOnItems(p6) -- line: 114
	return p6.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function selectTryOnBodyColor3s(p7) -- line: 118
	return p7.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
end
local function selectTryOnBodyScales(p8) -- line: 122
	return p8.AvatarExperience.AvatarScene.OutfitTryOn.Scale
end
local function selectTryOnBodyPartColorRangeIds(p9) -- line: 126
	return p9.AvatarExperience.AvatarScene.OutfitTryOn.BodyPartColorRangeIds
end
local function selectAssetInfos(p10) -- line: 130
	return p10.AvatarExperience.Common.AssetInfos or {}
end
local function selectBundleInfos(p11) -- line: 134
	return p11.AvatarExperience.Common.BundleInfos or {}
end
local function selectCollectibles(p12) -- line: 138
	return p12.AvatarExperience.Common.Collectibles or {}
end
local function selectLocalUserId(p13) -- line: 142
	return p13.LocalUserId
end
local function selectShouldTryOnWithoutEquippedItems(p14) -- line: 146
	return p14.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems
end
local function selectUserRobux(p15) -- line: 150
	local LocalUserId = p15.LocalUserId

	if not LocalUserId or not p15.UserRobux then
		return nil
	end

	return p15.UserRobux[LocalUserId]
end
local function v81(p16) -- line: 158
	local LocalUserId = p16.LocalUserId

	if not LocalUserId or not p16.Users then
		return false
	end

	return p16.Users[LocalUserId].hasRobloxSubscription
end
local function selectItemInfoForTryOnItems(p17) -- line: 170
	-- upvalues: Constants (copy), FFlagAXDurablesForMIS (copy)
	local TryOnItems = p17.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v105 = p17.AvatarExperience.Common.AssetInfos or {}
	local v106 = p17.AvatarExperience.Common.BundleInfos or {}
	local v107 = p17.AvatarExperience.Common.Collectibles or {}
	local t1 = {}

	for _, v110 in TryOnItems do
		if v110.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
			table.insert(t1, {
				itemId = v110.itemId,
				itemType = v110.itemType,
				itemData = v110.itemData,
				collectibleItemId = v110.itemId,
				ordering = v110.itemRecency
			})
		else
			local v111 = if v110.itemType ~= Enum.AvatarItemType.Asset.Name then v106[v110.itemId] else v105[v110.itemId]
			local v112 = if not v111 then nil else v111.collectibleItemId
			local v113 = if not v112 or not v107.CollectiblesItemInfo then nil else v107.CollectiblesItemInfo[v112]

			if v111 and v112 and v113 then
				local v114 = if not v107.CollectiblesResellableInstances then nil else v107.CollectiblesResellableInstances[v112]

				table.insert(t1, {
					itemId = v110.itemId,
					itemType = v110.itemType,
					itemData = v111,
					collectibleItemId = v112,
					ordering = v110.itemRecency,
					collectibleItemInfo = v113,
					resellableInstances = v114,
					selectedTimedOptionIndex = if not FFlagAXDurablesForMIS then nil else v110.selectedTimedOptionIndex
				})
			end
		end
	end

	return t1
end
local function v83(p18, p19) -- line: 218
	local t2 = {}

	for _, v119 in p18 do
		local v120 = table.clone(v119)

		if p19[v120.collectibleItemId] then
			v120.discountInformation = p19[v120.collectibleItemId].discountInformation or {}
			v120.priceInRobuxDiscountedByOffers = p19[v120.collectibleItemId].priceInRobux
		end

		table.insert(t2, v120)
	end

	return t2
end
local function useCheckoutPageViewModel(t3: {[any]: any}) -- line: 249
	-- upvalues: AvatarExperienceCatalogParent (copy), useAXCatalogStoreContext (copy), useNavigation (copy), useAvatarRoute (copy), useNetworking (copy), useDispatch (copy), FFlagAXMISWithOffers (copy), useSaveOptionsStoredValues (copy), useSignalState (copy), FFlagAXMISWithBlackbird (copy), React (copy), useSelector (copy), selectTryOnItems (copy), tutils (copy), selectTryOnBodyColor3s (copy), selectTryOnBodyScales (copy), selectTryOnBodyPartColorRangeIds (copy), selectTryOnLookId (copy), FFlagAXCatalogMakeupSupport (copy), u67 (ref), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), u68 (ref), u69 (ref), selectAvatarSceneLooks (copy), selectItemInfoForTryOnItems (copy), selectShouldTryOnWithoutEquippedItems (copy), selectLocalUserId (copy), selectUserRobux (copy), v81 (copy), useLocalization (copy), LocalizationRoactContext (copy), useAppPolicy (copy), useNavigationFocus (copy), FFlagAXEnableExpiredUserLookCheckout (copy), RobloxEventReceiver (copy), NotificationService (copy), AvatarScreen (copy), getRobloxSubscriptionProducts (copy), mutedError (copy), useOffersCartPricingCalculationsForCartItems (copy), Cryo (copy), Constants (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), CartIdService (copy), FFlagAXDurablesForMIS (copy), SetSelectedTimedOption (copy), v83 (copy), FIntBlackbirdUpsellMinPriceForDiscountInclusive (copy), FIntBlackbirdUpsellMaxPriceForDiscountInclusive (copy), ToastType (copy), SetCurrentToastMessage (copy), getTryOnItemsContainsOnlyMakeupTypes (copy), FFlagAXMISSaveWearFix (copy), SaveAsMakeupLookThunk (copy), SaveAsAvatarThunk (copy), getTryOnItemReducerKey (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), getEquippableAssetsFromTryOnItems (copy), PurchaseItemsSuccessThunk (copy), DiscountTypeEnum (copy), CloseCentralOverlay (copy), Promise (copy), AvatarScreenProperties (copy), sendUnifiedEventsForMultiItemShopping (copy), getUnifiedEventsForMIS (copy), PurchaseItems (copy), mapPurchaseItemsResponse (copy), getIsInsufficientRobuxError (copy)
	local PurchasePromptLite = require(AvatarExperienceCatalogParent.PurchasePromptLite)
	local shoppingCartStore = useAXCatalogStoreContext().shoppingCartStore
	local v124 = useNavigation()
	local v125 = useAvatarRoute()
	local v126 = useNetworking()
	local v127 = useDispatch()
	local v128 = if not FFlagAXMISWithOffers then nil else useSaveOptionsStoredValues()
	local v129 = useSignalState(shoppingCartStore.getItems)
	local v130 = if not FFlagAXMISWithBlackbird then nil else useSignalState(shoppingCartStore.getDiscounts)
	local v131 = useSignalState(shoppingCartStore.getCanPurchase)
	local v132 = useSignalState(shoppingCartStore.getPurchasableItemsTotalPriceInRobux)
	local v133 = useSignalState(shoppingCartStore.getPurchasableItemsTotalOriginalPriceInRobux)
	local v134 = useSignalState(shoppingCartStore.getErroredItemCount)
	local u135 = nil
	local u136 = nil

	if FFlagAXMISWithOffers then
		local v137, v138 = React.useState(false)

		u135 = v137
		u136 = v138
	end

	local v139, v140 = React.useState(not FFlagAXMISWithOffers or (not v128 or v128.getWearAfterPurchase()))
	local v141, v142 = React.useState(not not FFlagAXMISWithOffers and (not not v128 and v128.getAddToAvatars()))
	local v143, v144 = React.useState(false)
	local v145 = nil
	local u146 = nil

	if FFlagAXMISWithBlackbird then
		local v147

		v145, v147 = React.useState({})
		u146 = v147
	end

	local v148 = nil
	local u149 = nil

	if FFlagAXMISWithOffers then
		local v150

		v148, v150 = React.useState(false)
		u149 = v150
	end

	local v151 = useSelector(selectTryOnItems, tutils.deepEqual)
	local v152 = useSelector(selectTryOnBodyColor3s, tutils.deepEqual)
	local v153 = useSelector(selectTryOnBodyScales, tutils.deepEqual)
	local v154 = useSelector(selectTryOnBodyPartColorRangeIds, tutils.deepEqual)
	local v155 = useSelector(selectTryOnLookId)
	local v156 = if not FFlagAXCatalogMakeupSupport then nil else useSelector(u67)
	local v157 = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else useSelector(u68)
	local v158 = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else useSelector(u69)
	local v159 = useSelector(selectAvatarSceneLooks, tutils.deepEqual)
	local v160 = useSelector(selectItemInfoForTryOnItems, tutils.deepEqual)
	local v161 = useSelector(selectShouldTryOnWithoutEquippedItems)
	local v162 = useSelector(selectLocalUserId)
	local v163 = useSelector(selectUserRobux)
	local v164 = if not FFlagAXMISWithBlackbird then nil else useSelector(v81)
	local v165 = useLocalization({
		purchaseFailedTitle = "Feature.Catalog.Title.Checkout.PurchaseFailedSingular",
		purchaseFailedUnknownError = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		purchaseFailedButton = "Feature.Avatar.Action.GotIt",
		characterSavedHeading = "Feature.Avatar.Heading.LooksAvatarSaved",
		characterSavedMsg = "Feature.Avatar.Message.LooksAvatarSaved",
		purchaseFailedTitlePlural = {
			"Feature.Catalog.Title.Checkout.PurchaseFailedPlural",
			count = #v129
		}
	})
	local v166 = React.useContext(LocalizationRoactContext)
	local v167 = useAppPolicy(function(p20) -- line: 320
		return p20.getDisableResellingCollectiblesForCompliance()
	end)
	local v168 = if not FFlagAXMISWithBlackbird then nil else useAppPolicy(function(p21) -- line: 324
		return p21.getDisableBlackbirdEntrypoints()
	end)
	local v169 = React.useRef(false)
	local v170 = useNavigationFocus()
	local u171 = nil

	if FFlagAXEnableExpiredUserLookCheckout then
		local v172 = React.useMemo(function() -- line: 338
			-- upvalues: RobloxEventReceiver (copy), NotificationService (copy)
			return RobloxEventReceiver.new(NotificationService)
		end, {})

		u171 = React.useRef(nil)

		if v172 ~= nil then
			u171.current = v172:observeEvent("AvatarAssetOwnershipNotifications", function() -- line: 346
				-- upvalues: FFlagAXEnableExpiredUserLookCheckout (copy), v125 (copy), AvatarScreen (copy), v124 (copy)
				if ((if not FFlagAXEnableExpiredUserLookCheckout then nil else v125 and (v125.current and v125.current.name))) == AvatarScreen.ExpiredUserLookCheckout then
					v124.pop(2)
				end
			end)
		end
	end

	React.useEffect(function() -- line: 360
		-- upvalues: t3 (copy), v163 (copy), FFlagAXMISWithBlackbird (copy), getRobloxSubscriptionProducts (copy), u146 (ref), mutedError (copy), FFlagAXEnableExpiredUserLookCheckout (copy), u171 (ref)
		if t3.fetchUserRobux and not v163 then
			t3.fetchUserRobux()
		end

		if FFlagAXMISWithBlackbird then
			getRobloxSubscriptionProducts():andThen(function(p22) -- line: 368
				-- upvalues: u146 (ref)
				u146(p22)
			end):catch(function(p23) -- line: 371
				-- upvalues: mutedError (copy)
				mutedError("CheckoutPageViewModel", "Failed to fetch Roblox subscription products: " .. tostring(p23))
			end)
		end

		return function() -- line: 379
			-- upvalues: FFlagAXEnableExpiredUserLookCheckout (copy), u171 (ref)
			if FFlagAXEnableExpiredUserLookCheckout and u171.current ~= nil then
				u171.current:disconnect()
				u171.current = nil
			end
		end
	end, {})
	React.useEffect(function() -- line: 391
		-- upvalues: v170 (copy), v169 (copy), t3 (copy)
		if v170 and (v169.current and t3.fetchUserRobux) then
			t3.fetchUserRobux()
			v169.current = false
		end
	end, {
		v170,
		t3.fetchUserRobux
	})
	React.useLayoutEffect(function() -- line: 400
		-- upvalues: shoppingCartStore (copy), v160 (copy), v167 (copy), FFlagAXMISWithOffers (copy), u149 (ref), FFlagAXEnableExpiredUserLookCheckout (copy), v125 (copy), AvatarScreen (copy), v124 (copy)
		shoppingCartStore.syncFromTryOns(v160, v167)

		if FFlagAXMISWithOffers then
			u149(true)
		end

		local v194 = if not FFlagAXEnableExpiredUserLookCheckout then nil else v125 and (v125.current and v125.current.name)

		if FFlagAXEnableExpiredUserLookCheckout then
			if v160 and #v160 <= 0 and v194 == AvatarScreen.Checkout then
				v124.goBack()

				return
			end
		elseif v160 and #v160 <= 0 then
			v124.goBack()
		end
	end, {
		shoppingCartStore,
		v160,
		v167,
		v124,
		if not FFlagAXEnableExpiredUserLookCheckout then nil else v125
	})

	local v173 = React.useMemo(function() -- line: 433
		-- upvalues: v125 (copy), FFlagAXEnableExpiredUserLookCheckout (copy), AvatarScreen (copy)
		local v195 = v125 and (v125.current and v125.current.name)

		if FFlagAXEnableExpiredUserLookCheckout then
			return v195 == AvatarScreen.ExpiredUserLookCheckout or v195 == AvatarScreen.Checkout
		end

		return v195 == AvatarScreen.Checkout
	end, { v125 })
	local u174 = nil

	if FFlagAXMISWithOffers then
		u174 = useOffersCartPricingCalculationsForCartItems(v129, v173, v148)
	end

	local v175 = React.useMemo(function() -- line: 449
		-- upvalues: v129 (copy), Cryo (copy), Constants (copy), t3 (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), CartIdService (copy), FFlagAXDurablesForMIS (copy), shoppingCartStore (copy), v127 (copy), SetSelectedTimedOption (copy), FFlagAXMISWithOffers (copy), u174 (ref), v83 (copy)
		local t4 = {}

		for _, v198 in v129 do
			table.insert(t4, Cryo.Dictionary.join(v198, {
				onActivated = function() -- line: 455
					-- upvalues: v198 (copy), Constants (copy), t3 (copy)
					if v198.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
						return
					end

					if t3.onOpenItemDetailsPage then
						t3.onOpenItemDetailsPage(v198.itemId, v198.itemType, v198.itemSubType)
					end
				end,
				onRemove = function() -- line: 464
					-- upvalues: t3 (copy), v198 (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), CartIdService (copy)
					if t3.onRemoveItem then
						t3.onRemoveItem(v198.itemId, v198.itemType)

						if FFlagAXMISEnableMultiShoppingUnifiedEvents then
							local ASSET = nil

							if v198.itemType == "Asset" then
								ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
							elseif v198.itemType == "Bundle" then
								ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
							end

							sendUnifiedEventForDeferredAction({
								action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
								cartId = CartIdService.getCartId(),
								itemId = v198.itemId,
								itemType = ASSET,
								assetType = if v198.itemType ~= "Asset" then nil else v198.itemSubType,
								bundleType = if v198.itemType ~= "Asset" then v198.itemSubType else nil
							})
						end
					end
				end,
				onTimedOptionPriceChanged = if not FFlagAXDurablesForMIS then nil else function(n1: number, n2: number?) -- line: 488
					-- upvalues: shoppingCartStore (copy), v198 (copy), Cryo (copy), v127 (copy), SetSelectedTimedOption (copy)
					if shoppingCartStore.updateItemPrice then
						if v198.timedOptions then
							local v248 = Cryo.List.findWhere(v198.timedOptions, function(p24) -- line: 493
								-- upvalues: n2 (copy)
								return p24.days == n2
							end) or #v198.timedOptions

							v127(SetSelectedTimedOption({
								itemId = v198.itemId,
								itemType = v198.itemType,
								selectedTimedOptionIndex = v248
							}))
						end

						shoppingCartStore.updateItemPrice(v198.itemId, v198.itemType, n1, n2)
					end
				end
			}))
		end

		if FFlagAXMISWithOffers and u174.discountedItemsFromOffers and #Cryo.Dictionary.keys(u174.discountedItemsFromOffers) > 0 then
			t4 = v83(t4, u174.discountedItemsFromOffers)
		end

		return t4
	end, {
		v129,
		t3.onOpenItemDetailsPage,
		t3.onRemoveItem,
		if not FFlagAXDurablesForMIS then nil else shoppingCartStore,
		if not FFlagAXDurablesForMIS then nil else v127,
		if not FFlagAXMISWithOffers then nil else u174.discountedItemsFromOffers
	})
	local v176 = if not FFlagAXEnableExpiredUserLookCheckout then nil else React.useMemo(function() -- line: 538
		-- upvalues: v125 (copy), AvatarScreen (copy)
		return (v125 and (v125.current and v125.current.name)) == AvatarScreen.ExpiredUserLookCheckout
	end, { v125 })
	local v177 = if not FFlagAXMISWithBlackbird then nil else React.useMemo(function() -- line: 546
		-- upvalues: v164 (copy), v168 (copy), FFlagAXMISWithOffers (copy), Cryo (copy), u174 (ref), v129 (copy), FIntBlackbirdUpsellMinPriceForDiscountInclusive (copy), FIntBlackbirdUpsellMaxPriceForDiscountInclusive (copy)
		if not v164 and not v168 and (not FFlagAXMISWithOffers or FFlagAXMISWithOffers and #Cryo.Dictionary.keys(u174.offersAvailable) == 0) then
			for _, v200 in v129 do
				if v200.priceInRobux >= FIntBlackbirdUpsellMinPriceForDiscountInclusive and v200.priceInRobux <= FIntBlackbirdUpsellMaxPriceForDiscountInclusive and (not v200.isOwned or v200.isOwned and v200.expirationTime) then
					return true
				end
			end
		end

		return false
	end, {
		v164,
		v168,
		v129,
		if not FFlagAXMISWithOffers then nil else u174.offersAvailable
	})
	local v178 = React.useCallback(function(s1: string, s2: string, _: string) -- line: 577
		-- upvalues: t3 (copy)
		if t3.onRemoveItem then
			t3.onRemoveItem(s1, s2)
		end
	end, {
		t3.onRemoveItem,
		v151,
		v124
	})
	local v179 = React.useCallback(function(s4: string, s5: string, s6: string) -- line: 583
		-- upvalues: t3 (copy)
		if t3.onOpenItemDetailsPage then
			t3.onOpenItemDetailsPage(s4, s5, s6)
		end
	end, { t3.onOpenItemDetailsPage })
	local v180 = React.useCallback(function() -- line: 589
		-- upvalues: v124 (copy), AvatarScreen (copy)
		v124.navigate(AvatarScreen.CartUnavailableItemsPrompt)
	end, { v124 })
	local v181 = React.useCallback(function() -- line: 593
		-- upvalues: v140 (copy), v139 (copy), FFlagAXMISWithOffers (copy), v128 (copy)
		v140(not v139)

		if FFlagAXMISWithOffers and v128 then
			v128.setWearAfterPurchase(not v139)
		end
	end, {
		v139,
		if not FFlagAXMISWithOffers then nil else v128
	})
	local v182 = React.useCallback(function() -- line: 600
		-- upvalues: v142 (copy), v141 (copy), FFlagAXMISWithOffers (copy), v128 (copy)
		v142(not v141)

		if FFlagAXMISWithOffers and v128 then
			v128.setAddToAvatars(not v141)
		end
	end, {
		v141,
		if not FFlagAXMISWithOffers then nil else v128
	})
	local v183 = if not FFlagAXMISWithOffers then nil else React.useCallback(function() -- line: 608
		-- upvalues: u136 (ref), u135 (ref)
		u136(not u135)
	end, { u135 })
	local v184 = React.useCallback(function() -- line: 613
		-- upvalues: v129 (copy), Constants (copy), FFlagAXMISWithOffers (copy), u174 (ref), FFlagAXDurablesForMIS (copy)
		local t5 = {}

		for _, v209 in v129 do
			if v209.itemId ~= Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
				local v210 = if not FFlagAXMISWithOffers then nil else u174.discountedItemsFromOffers[v209.collectibleItemId]

				table.insert(t5, {
					agreedPriceRobux = if not FFlagAXMISWithOffers or not v210 then v209.priceInRobux else v210.priceInRobux,
					collectibleProductId = v209.collectibleProductId,
					collectibleItemId = if not FFlagAXMISWithOffers then nil else v209.collectibleItemId,
					rentalOption = if not FFlagAXDurablesForMIS or (not v209.selectedTimedOptionDays or not (v209.selectedTimedOptionDays > 0)) then nil else {
						durationDays = v209.selectedTimedOptionDays
					},
					offerIds = if not FFlagAXMISWithOffers or not v210 then nil else v210.offerIdsApplied
				})
			end
		end

		return t5
	end, {
		v129,
		if not FFlagAXMISWithOffers then nil else u174
	})
	local v185 = React.useCallback(function() -- line: 646
		-- upvalues: v165 (copy), ToastType (copy), v127 (copy), SetCurrentToastMessage (copy)
		local t6 = {
			isLocalized = true,
			toastMessage = v165.characterSavedHeading,
			toastSubMessage = v165.characterSavedMsg,
			toastType = ToastType.SuccessConfirmation
		}

		v127(SetCurrentToastMessage(t6))
	end, {
		v127,
		v165
	})
	local v186 = React.useCallback(function(p25) -- line: 656
		-- upvalues: FFlagAXCatalogMakeupSupport (copy), getTryOnItemsContainsOnlyMakeupTypes (copy), v159 (copy), v156 (copy), v155 (copy), FFlagAXMISSaveWearFix (copy), v127 (copy), SaveAsMakeupLookThunk (copy), v126 (copy), t3 (copy), SaveAsAvatarThunk (copy), v185 (copy)
		if FFlagAXCatalogMakeupSupport then
			local v213 = getTryOnItemsContainsOnlyMakeupTypes(p25)
			local v214 = not v213 and "Avatar" or "Makeup"

			if v159 and v159[v156] and v159[v156].name then
				v214 = v159[v156].name
			end

			if v159 and v159[v155] and v159[v155].name then
				v214 = v159[v155].name
			end

			if v213 then
				if FFlagAXMISSaveWearFix then
					v127(SaveAsMakeupLookThunk(v126, v214, p25, nil, t3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn))

					return
				end

				v127(SaveAsMakeupLookThunk(v126, v214, p25))

				return
			end

			v127(SaveAsAvatarThunk(v214, t3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn, p25, v185))

			return
		end

		local s7 = "Avatar"

		if v159 and v159[v155] and v159[v155].name then
			s7 = v159[v155].name
		end

		v127(SaveAsAvatarThunk(s7, t3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn, p25, v185))
	end, {
		v127,
		v185,
		t3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
		v159,
		v155,
		if not FFlagAXCatalogMakeupSupport then nil else v126,
		if not FFlagAXCatalogMakeupSupport then nil else v156
	})
	local v187 = React.useCallback(function(p26) -- line: 721
		-- upvalues: shoppingCartStore (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), v159 (copy), v155 (copy), v156 (copy), t3 (copy), v127 (copy), SetCurrentToastMessage (copy), v166 (copy), ToastType (copy), getTryOnItemReducerKey (copy), v151 (copy), v141 (copy), v186 (copy), FFlagAXMISSaveWearFix (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), v139 (copy), getEquippableAssetsFromTryOnItems (copy), PurchaseItemsSuccessThunk (copy), v161 (copy), v152 (copy), v153 (copy), v154 (copy)
		local v217 = shoppingCartStore.updateCartFromPurchaseResponse(p26)
		local boughtItems = v217.boughtItems
		local equippableItems = v217.equippableItems
		local needDataRefeshItems = v217.needDataRefeshItems
		local v221 = nil
		local v222 = nil

		if FFlagAXMISEnableMultiShoppingUnifiedEvents then
			v221 = v159[v155]

			if v221 ~= nil then
				v221 = table.clone(v221)
				v221.itemId = v155
			end

			v222 = v159[v156]

			if v222 ~= nil then
				v222 = table.clone(v222)
				v222.itemId = v156
			end
		end

		for _, v224 in needDataRefeshItems do
			if t3.fetchItemData then
				t3.fetchItemData(v224.itemId, v224.itemType)
			end
		end

		v127(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v166:Format("Feature.Catalog.Title.Checkout.ItemsPurchased", {
				count = #boughtItems
			}),
			toastType = ToastType.InformationMessage
		}))

		local t7 = {}

		for _, v227 in equippableItems do
			local v228 = v151[getTryOnItemReducerKey(v227.itemId, v227.itemType)]

			if v228 then
				table.insert(t7, v228)
			end
		end

		if v141 then
			v186(t7)
		end

		if not FFlagAXMISSaveWearFix then
			for _, v230 in equippableItems do
				if t3.onRemoveItem then
					t3.onRemoveItem(v230.itemId, v230.itemType)
				end
			end
		end

		local t8 = {}

		if not FFlagAXMISSaveWearFix and FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
		end

		if v139 then
			t8 = getEquippableAssetsFromTryOnItems(t7)
		end

		local v232 = v156 ~= nil

		v127(PurchaseItemsSuccessThunk(boughtItems, t8, v161, v152, v153, v154, t7, t3.getBundleOutfitInfoFromProvidedTryOns, v232, if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v221, if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v222, if not FFlagAXMISSaveWearFix then nil else t3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn))

		if FFlagAXMISSaveWearFix then
			for _, v234 in equippableItems do
				if t3.onRemoveItem then
					t3.onRemoveItem(v234.itemId, v234.itemType)
				end
			end

			if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
				avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
			end
		end
	end, {
		v127,
		shoppingCartStore.updateCartFromPurchaseResponse,
		v139,
		v141,
		v152,
		v153,
		v154,
		v151,
		v161,
		v186,
		t3.onRemoveItem,
		t3.fetchItemData,
		t3.getBundleOutfitInfoFromProvidedTryOns,
		v156,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v155,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v159,
		if not FFlagAXMISSaveWearFix then nil else t3.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn
	})
	local v188 = if not FFlagAXMISWithBlackbird then React.useCallback(function() -- line: 903
		-- upvalues: v124 (copy), AvatarScreen (copy), v169 (copy)
		v124.navigate(AvatarScreen.InsufficientRobuxPrompt)
		v169.current = true
	end, { v124 }) else React.useCallback(function() -- line: 853
		-- upvalues: v130 (copy), DiscountTypeEnum (copy), v127 (copy), PurchasePromptLite (copy), CloseCentralOverlay (copy), Promise (copy), v132 (copy), v133 (copy), v169 (copy)
		local u235 = nil

		if v130 then
			for _, v237 in v130 do
				if v237.discountCampaign == DiscountTypeEnum.RobloxPlusSubscription then
					u235 = v237

					break
				end
			end
		end

		v127(PurchasePromptLite.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt({
			productPayload = {
				kind = "RobuxUpsell"
			},
			purchaseCallbacks = {
				onFlowComplete = function() -- line: 869
					-- upvalues: v127 (copy), CloseCentralOverlay (copy)
					v127(CloseCentralOverlay())
				end,
				fetchProductInfo = function() -- line: 872
					-- upvalues: Promise (copy), v132 (copy), u235 (ref), v133 (copy)
					return Promise.resolve({
						IsForSale = true,
						Name = "RobuxUpsell",
						PriceInRobux = v132,
						BasePriceInRobux = if not u235 then nil else v133,
						PriceDiscountDetails = if not u235 then nil else {{
							Type = u235.discountCampaign,
							AmountInRobux = v133 - v132,
							Percent = u235.robuxDiscountPercentage
						}}
					})
				end
			}
		}))
		v169.current = true
	end, {
		v124,
		v127,
		v132,
		v133,
		v130
	})
	local v189 = if not FFlagAXMISWithBlackbird then nil else React.useMemo(function() -- line: 911
		-- upvalues: v130 (copy), DiscountTypeEnum (copy), FFlagAXMISWithOffers (copy), u174 (ref), v133 (copy), v132 (copy)
		local v238 = nil

		if v130 then
			for _, v240 in v130 do
				if v240.discountCampaign == DiscountTypeEnum.RobloxPlusSubscription then
					v238 = v240

					break
				end
			end
		end

		if FFlagAXMISWithOffers then
			local v241 = table.clone(u174.discountSummaryEntriesFromOffers)

			if v238 then
				table.insert(v241, 1, {
					type = DiscountTypeEnum.RobloxPlusSubscription,
					amountInRobux = v133 - v132,
					percent = v238.robuxDiscountPercentage
				})
			end

			return {
				itemPrice = {
					basePriceInRobux = v133,
					priceInRobux = math.max(v132 - u174.totalSelectedOffersDiscount, 0),
					discounts = v241
				},
				savingsSummary = u174.savingsSummary
			}
		end

		if v238 and v133 and v132 then
			return {
				itemPrice = {
					basePriceInRobux = v133,
					priceInRobux = v132,
					discounts = {{
						type = DiscountTypeEnum.RobloxPlusSubscription,
						amountInRobux = v133 - v132,
						percent = v238.robuxDiscountPercentage
					}}
				}
			}
		end

		return nil
	end, {
		v133,
		v132,
		v130,
		if not FFlagAXMISWithOffers then nil else u174.discountSummaryEntriesFromOffers,
		if not FFlagAXMISWithOffers then nil else u174.totalSelectedOffersDiscount,
		if not FFlagAXMISWithOffers then nil else u174.savingsSummary
	})
	local v190 = React.useCallback(function() -- line: 982
		-- upvalues: v144 (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), v159 (copy), v155 (copy), v156 (copy), v157 (copy), v158 (copy), v125 (copy), AvatarScreenProperties (copy), sendUnifiedEventsForMultiItemShopping (copy), getUnifiedEventsForMIS (copy), v129 (copy), v151 (copy), UnifiedEventLogEnums (copy), mutedError (copy), PurchaseItems (copy), v126 (copy), v162 (copy), v184 (copy), mapPurchaseItemsResponse (copy), v187 (copy), t3 (copy), getIsInsufficientRobuxError (copy), v188 (copy), v124 (copy), AvatarScreen (copy), v165 (copy)
		v144(true)

		if FFlagAXMISEnableMultiShoppingUnifiedEvents and not pcall(function() -- line: 986
			-- upvalues: v159 (copy), v155 (copy), v156 (copy), v157 (copy), v158 (copy), v125 (copy), AvatarScreenProperties (copy), sendUnifiedEventsForMultiItemShopping (copy), getUnifiedEventsForMIS (copy), v129 (copy), v151 (copy), UnifiedEventLogEnums (copy)
			local v249 = v159[v155]

			if v249 ~= nil then
				v249 = table.clone(v249)
				v249.itemId = v155
			end

			local v250 = v159[v156]

			if v250 ~= nil then
				v250 = table.clone(v250)
				v250.itemId = v156
			end

			if v249 then
				v249.isOrganicLook = v157 == nil
			end

			if v250 then
				v250.isOrganicLook = v158 == nil
			end

			local v251 = AvatarScreenProperties[v125 and (v125.current and v125.current.name)]
			local v252 = if not v251 or not v251.analyticsData then nil else v251.analyticsData.unifiedLoggingSurface

			sendUnifiedEventsForMultiItemShopping(getUnifiedEventsForMIS(v129, v151, v249, v250, UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT), v252)
		end) then
			mutedError("Failed to send unified events for multi-item shopping purchase attempt")
		end

		PurchaseItems({
			networkImpl = v126,
			userId = v162,
			lookId = v155,
			makeupLookId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v156,
			lineItems = v184()
		}):andThen(function(p27) -- line: 1040
			-- upvalues: mapPurchaseItemsResponse (copy), v187 (copy), t3 (copy)
			if p27.isJSONValid and p27.responseCode == 200 then
				local responseBody = p27.responseBody
				local v255 = mapPurchaseItemsResponse(responseBody)

				v187(v255)

				if t3.fetchUserRobux then
					t3.fetchUserRobux()
				end
			end
		end):catch(function(p28) -- line: 1051
			-- upvalues: getIsInsufficientRobuxError (copy), v188 (copy), v124 (copy), AvatarScreen (copy), v129 (copy), v165 (copy)
			if getIsInsufficientRobuxError(p28) then
				v188()

				return
			end

			v124.navigate(AvatarScreen.GenericPrompt, {
				titleText = if #v129 ~= 1 then v165.purchaseFailedTitlePlural else v165.purchaseFailedTitle,
				bodyText = v165.purchaseFailedUnknownError,
				buttonText = v165.purchaseFailedButton
			})
		end):finally(function() -- line: 1064
			-- upvalues: v144 (copy)
			v144(false)
		end)
	end, {
		v184,
		v162,
		v126,
		v188,
		t3.fetchUserRobux,
		v187,
		v129,
		v165,
		v124,
		v155,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v156,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v159,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v151,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v157,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v158,
		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else v125
	})
	local v191 = React.useCallback(function() -- line: 1089
		-- upvalues: FFlagAXMISWithOffers (copy), v132 (copy), u174 (ref), v163 (copy), v188 (copy), v190 (copy)
		local v242 = if not FFlagAXMISWithOffers then v132 else v132 - u174.totalSelectedOffersDiscount

		if v163 and v242 > v163 then
			v188()

			return
		end

		v190()
	end, {
		v163,
		v132,
		v190,
		v188,
		if not FFlagAXMISWithOffers then nil else u174.totalSelectedOffersDiscount
	})

	return {
		canPurchase = v131,
		cartItems = v175,
		discounts = if not FFlagAXMISWithBlackbird then nil else v130,
		erroredItemCount = v134,
		isPurchasing = v143,
		isVisible = v173,
		hideBuyOptions = if not FFlagAXEnableExpiredUserLookCheckout then nil else v176,
		shouldShowBlackbirdUpsellBanner = if not FFlagAXMISWithBlackbird then nil else v177,
		isWearAfterPurchaseChecked = v139,
		isAddToMyAvatarsChecked = v141,
		isSaveOptionsOpen = u135,
		onCheckoutButtonActivated = v191,
		onOpenItemDetailsPage = v179,
		onRemoveItem = v178,
		onUnavailableButtonActivated = v180,
		onWearAfterPurchaseToggle = v181,
		onAddToMyAvatarsToggle = v182,
		onSaveOptionsOpenToggle = v183,
		purchasableItemsTotalPriceInRobux = if not FFlagAXMISWithOffers then v132 else math.max(v132 - u174.totalSelectedOffersDiscount, 0),
		purchasableItemsTotalOriginalPriceInRobux = v133,
		robloxSubscriptionProducts = if not FFlagAXMISWithBlackbird then nil else v145,
		discountSummaryProps = if not FFlagAXMISWithBlackbird then nil else v189,
		offersAvailable = if not FFlagAXMISWithOffers then nil else u174.offersAvailable,
		handleDeselectOfferId = if not FFlagAXMISWithOffers then nil else u174.handleDeselectOfferId
	}
end

return useCheckoutPageViewModel
