local NotificationService = game:GetService("NotificationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Promise")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Loggers").mutedError
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/ToastRodux")
local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RobloxSubscriptionPurchaseApp")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
local robloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RealtimeDelivery").RobloxEventReceiver

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutPage")

local PurchaseItemsSuccessThunk = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Thunks/PurchaseItemsSuccessThunk")
local SaveAsAvatarThunk = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Thunks/SaveAsAvatarThunk")
local SaveAsMakeupLookThunk = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Thunks/SaveAsMakeupLookThunk")
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local SetSelectedTimedOption = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Actions/SetSelectedTimedOption")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/CentralOverlay").Thunks.CloseCentralOverlay

local constants = AvatarExperienceCommon.Constants
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local toastType = ToastRodux.Enums.ToastType
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local discountTypeEnum = AvatarExperienceCommon.Enums.DiscountTypeEnum

local PurchaseItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Requests/PurchaseItems")
local getRobloxSubscriptionProducts = RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore

local mapPurchaseItemsResponse = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Requests/PurchaseItems/mapPurchaseItemsResponse")
local getEquippableAssetsFromTryOnItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/TryOns/getEquippableAssetsFromTryOnItems")
local getTryOnItemsContainsOnlyMakeupTypes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/TryOns/getTryOnItemsContainsOnlyMakeupTypes")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Stores/createAXShoppingCartStore")
local getIsInsufficientRobuxError = AvatarExperienceCommon.Utils.getIsInsufficientRobuxError

local useAXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/useAXCatalogStoreContext")
local useOffersCartPricingCalculationsForCartItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useOffersCartPricingCalculationsForCartItems")
local useSignalState = SignalsReact.useSignalState
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/UniversalAppPolicy").useAppPolicy
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigation
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigationFocus
local useSaveOptionsStoredValues = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useSaveOptionsStoredValues")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").LocalizationRoactContext

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface
local getMarketplaceUnifiedAssetType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType
local getMarketplaceUnifiedBundleType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType
local sendUnifiedEventsForMultiItemShopping = AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping
local getUnifiedEventsForMIS = AvatarExperienceAnalytics.Utils.getUnifiedEventsForMIS
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local unifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local fFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local fFlagAXBackgroundsEquipTryOnCounters = AvatarExperienceFlags.FFlagAXBackgroundsEquipTryOnCounters
local fIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive
local reportBackgroundUserActionCounter = AvatarExperienceAnalytics.reportBackgroundUserActionCounter
local defineFastFlag = game:DefineFastFlag("AXFixSelectUserRobloxSubscriptionNil", false)

local function selectTryOnLookId(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local fn = fFlagAXCatalogMakeupSupport and function(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
end or nil
local fn2, fn3

if fFlagAXMISEnableMultiShoppingUnifiedEvents then
	fn2 = function(p2)
		return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
	end

	fn3 = function(p2)
		return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
	end
else
	fn2 = nil
	fn3 = nil
end

local function selectAvatarSceneLooks(p2)
	return p2.AvatarExperience.AvatarScene.Looks
end

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function selectTryOnItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function selectTryOnBodyColor3s(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
end

local function selectTryOnBodyScales(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.Scale
end

local function selectTryOnBodyPartColorRangeIds(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.BodyPartColorRangeIds
end

local function selectAssetInfos(p2)
	return p2.AvatarExperience.Common.AssetInfos or {}
end

local function selectBundleInfos(p2)
	return p2.AvatarExperience.Common.BundleInfos or {}
end

local function selectCollectibles(p2)
	return p2.AvatarExperience.Common.Collectibles or {}
end

local function selectLocalUserId(p2)
	return p2.LocalUserId
end

local function selectShouldTryOnWithoutEquippedItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems
end

local function selectUserRobux(p2)
	local localUserId = p2.LocalUserId

	if localUserId and p2.UserRobux then
		return p2.UserRobux[localUserId]
	end

	return nil
end

local function fn4(p2)
	local localUserId = p2.LocalUserId

	if localUserId and p2.Users and (not defineFastFlag or p2.Users[localUserId]) then
		return p2.Users[localUserId].hasRobloxSubscription
	end

	return false
end

local function selectItemInfoForTryOnItems(p2)
	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local assetInfos = p2.AvatarExperience.Common.AssetInfos or {}

	local bundleInfos = p2.AvatarExperience.Common.BundleInfos or {}

	local collectibles = p2.AvatarExperience.Common.Collectibles or {}

	local itemInfoForTryOnItems = {}

	for k, tryOnItem in tryOnItems do
		if tryOnItem.itemId == constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
			table.insert(itemInfoForTryOnItems, {
				itemId = tryOnItem.itemId,
				itemType = tryOnItem.itemType,
				itemData = tryOnItem.itemData,
				collectibleItemId = tryOnItem.itemId,
				ordering = tryOnItem.itemRecency
			})
		else
			local v5

			if tryOnItem.itemType == Enum.AvatarItemType.Asset.Name then
				v5 = assetInfos[tryOnItem.itemId]
			else
				v5 = bundleInfos[tryOnItem.itemId]
			end

			local collectibleItemId = if v5 then v5.collectibleItemId else nil
			local v6

			if collectibleItemId and collectibles.CollectiblesItemInfo then
				v6 = collectibles.CollectiblesItemInfo[collectibleItemId]
			end

			if v5 and collectibleItemId and v6 then
				local v7 = if collectibles.CollectiblesResellableInstances then collectibles.CollectiblesResellableInstances[collectibleItemId] else nil

				local v8 = {
					itemId = tryOnItem.itemId,
					itemType = tryOnItem.itemType,
					itemData = v5,
					collectibleItemId = collectibleItemId,
					ordering = tryOnItem.itemRecency,
					collectibleItemInfo = v6,
					resellableInstances = v7,
					selectedTimedOptionIndex = 0
				}

				local v9 = if fFlagAXDurablesForMIS then tryOnItem.selectedTimedOptionIndex else nil
				v8.selectedTimedOptionIndex = v9
				table.insert(itemInfoForTryOnItems, v8)
			end
		end
	end

	return itemInfoForTryOnItems
end

local function fn5(items, discountedItemsFromOffers)
	local clones = {}

	for k, item in items do
		local clone = table.clone(item)

		if discountedItemsFromOffers[clone.collectibleItemId] then
			clone.discountInformation = discountedItemsFromOffers[clone.collectibleItemId].discountInformation
				or {}
			clone.priceInRobuxDiscountedByOffers = discountedItemsFromOffers[clone.collectibleItemId].priceInRobux

			local v5 = if fFlagAXMISOffersChip then #discountedItemsFromOffers[clone.collectibleItemId].offerIdsApplied > 0 else nil
			clone.offerApplied = v5
		end

		table.insert(clones, clone)
	end

	return clones
end

local function useCheckoutPageViewModel(data)
	local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/PurchasePromptLite")

	local shoppingCartStore = useAXCatalogStoreContext().shoppingCartStore

	local v5 = useNavigation()
	local v6 = useAvatarRoute()
	local v7 = useNetworking()
	local v8 = useDispatch()
	local v9 = if fFlagAXMISWithOffers then useSaveOptionsStoredValues() else nil

	local v10 = useSignalState(shoppingCartStore.getItems)
	local v11 = if fFlagAXUnifiedEventStrictPayloads then useSelector(selectScreenSize) else nil
	local v12 = if fFlagAXMISWithBlackbird then useSignalState(shoppingCartStore.getDiscounts) else nil
	local v13 = useSignalState(shoppingCartStore.getCanPurchase)
	local v14 = useSignalState(shoppingCartStore.getPurchasableItemsTotalPriceInRobux)

	local v15 = useSignalState(shoppingCartStore.getPurchasableItemsTotalOriginalPriceInRobux)
	local v16 = useSignalState(shoppingCartStore.getErroredItemCount)
	local state, setState

	if fFlagAXMISWithOffers then
		state, setState = React.useState(false)
	else
		setState = nil
		state = nil
	end

	local state2, setState2 = React.useState(not (fFlagAXMISWithOffers and v9) or v9.getWearAfterPurchase())

	local useState = React.useState
	local v17 = if fFlagAXMISWithOffers and v9 then v9.getAddToAvatars() else false
	local state3, setState3 = useState(v17)

	local state4, setState4 = React.useState(false)
	local state5, setState5

	if fFlagAXMISWithBlackbird then
		state5, setState5 = React.useState({})
	else
		setState5 = nil
	end

	local state6, setState6

	if fFlagAXMISWithOffers then
		state6, setState6 = React.useState(false)
	else
		setState6 = nil
	end

	local v18 = useSelector(selectTryOnItems, tutils.deepEqual)
	local v19 = useSelector(selectTryOnBodyColor3s, tutils.deepEqual)
	local v20 = useSelector(selectTryOnBodyScales, tutils.deepEqual)
	local v21 = useSelector(selectTryOnBodyPartColorRangeIds, tutils.deepEqual)
	local v22 = useSelector(selectTryOnLookId)
	local v23 = if fFlagAXCatalogMakeupSupport then useSelector(fn) else nil

	local v24 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then useSelector(fn2) else nil

	local v25 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then useSelector(fn3) else nil

	local v26 = useSelector(selectAvatarSceneLooks, tutils.deepEqual)
	local v27 = useSelector(selectItemInfoForTryOnItems, tutils.deepEqual)
	local v28 = useSelector(selectShouldTryOnWithoutEquippedItems)
	local v29 = useSelector(selectLocalUserId)
	local v30 = useSelector(selectUserRobux)
	local v31 = if fFlagAXMISWithBlackbird then useSelector(fn4) else nil

	local v32 = useLocalization({
		purchaseFailedTitle = "Feature.Catalog.Title.Checkout.PurchaseFailedSingular",
		purchaseFailedTitlePlural = {
			"Feature.Catalog.Title.Checkout.PurchaseFailedPlural",
			count = #v10
		},
		purchaseFailedUnknownError = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		purchaseFailedButton = "Feature.Avatar.Action.GotIt",
		characterSavedHeading = "Feature.Avatar.Heading.LooksAvatarSaved",
		characterSavedMsg = "Feature.Avatar.Message.LooksAvatarSaved"
	})

	local v33 = React.useContext(localizationRoactContext)
	local v34 = useAppPolicy(function(p2)
		return p2.getDisableResellingCollectiblesForCompliance()
	end)
	local v35

	if fFlagAXMISWithBlackbird then
		v35 = useAppPolicy(function(p2)
			return p2.getDisableBlackbirdEntrypoints()
		end)
	else
		v35 = nil
	end

	local ref = React.useRef(false)

	local v36 = useNavigationFocus()
	local ref2

	if fFlagAXEnableExpiredUserLookCheckout then
		local v37 = React.useMemo(function()
			return robloxEventReceiver.new(NotificationService)
		end, {})
		ref2 = React.useRef(nil)

		if v37 ~= nil then
			ref2.current = v37:observeEvent("AvatarAssetOwnershipNotifications", function()
				local v38

				if fFlagAXEnableExpiredUserLookCheckout then
					v38 = v6 and v6.current and v6.current.name
				end

				if v38 == avatarScreen.ExpiredUserLookCheckout then
					v5.pop(2)
				end
			end)
		end
	else
		ref2 = nil
	end

	React.useEffect(function()
		if data.fetchUserRobux and not v30 then
			data.fetchUserRobux()
		end

		if fFlagAXMISWithBlackbird then
			getRobloxSubscriptionProducts():andThen(function(p2)
				setState5(p2)
			end):catch(function(p2)
				mutedError(
					"CheckoutPageViewModel",
					"Failed to fetch Roblox subscription products: " .. tostring(p2)
				)
			end)
		end

		return function()
			if fFlagAXEnableExpiredUserLookCheckout and ref2.current ~= nil then
				ref2.current:disconnect()
				ref2.current = nil
			end
		end
	end, {})

	React.useEffect(function()
		if v36 and ref.current and data.fetchUserRobux then
			data.fetchUserRobux()
			ref.current = false
		end
	end, { v36, data.fetchUserRobux })

	local function fn6()
		shoppingCartStore.syncFromTryOns(v27, v34)

		if fFlagAXMISWithOffers then
			setState6(true)
		end

		local name

		if fFlagAXEnableExpiredUserLookCheckout then
			name = v6 and v6.current and v6.current.name
		end

		if fFlagAXEnableExpiredUserLookCheckout then
			if
				v27
				and #v27 <= 0
				and (name == avatarScreen.Checkout or name == avatarScreen.ExpiredUserLookCheckout)
			then
				v5.goBack()
			end
		elseif v27 and #v27 <= 0 then
			v5.goBack()
		end
	end

	React.useLayoutEffect(fn6, {
		shoppingCartStore,
		v27,
		v34,
		v5,
		if fFlagAXEnableExpiredUserLookCheckout then v6 else nil
	})

	local v39 = React.useMemo(function(): boolean
		local name = v6 and v6.current and v6.current.name

		if fFlagAXEnableExpiredUserLookCheckout then
			return name == avatarScreen.ExpiredUserLookCheckout or name == avatarScreen.Checkout
		end

		return name == avatarScreen.Checkout
	end, { v6 })

	local v40 = if fFlagAXMISWithOffers then useOffersCartPricingCalculationsForCartItems(v10, v39, state6) else nil

	local useMemo = React.useMemo
	local function fn7()
		local result = {}

		for k, v41 in v10 do
			table.insert(result, Cryo.Dictionary.join(v41, {
				onActivated = function()
					if v41.itemId == constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
						return
					end

					if data.onOpenItemDetailsPage then
						data.onOpenItemDetailsPage(v41.itemId, v41.itemType, v41.itemSubType)
					end
				end,
				onRemove = function()
					if data.onRemoveItem then
						if fFlagAXBackgroundsEquipTryOnCounters then
							reportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset(
								"RemoveTryOn",
								v41.itemType,
								v41.itemSubType
							)
						end

						data.onRemoveItem(v41.itemId, v41.itemType)

						if fFlagAXMISEnableMultiShoppingUnifiedEvents then
							local v42 = nil

							if v41.itemType == "Asset" then
								v42 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
							elseif v41.itemType == "Bundle" then
								v42 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
							end

							local v43 = nil
							local v44 = nil
							local v45 = nil
							local v46 = nil
							local v47 = nil
							local v48 = nil

							if fFlagAXUnifiedEventStrictPayloads then
								local ATTRIBUTE_PREFIX = unifiedEventLogConstants.ATTRIBUTE_PREFIX
								local v49 = ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_ITEM_ID
								local v50 = ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_ITEM_TYPE

								for k2, v52 in unifiedSelectionListStore.getSelectionList() do
									if
										tostring(v52[v49]) == tostring(v41.itemId)
										and tostring(v52[v50]) == tostring(v42)
									then
										v43 = v52[ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_GRID_POSITION_ROW]

										v44 = v52[ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_GRID_POSITION_COLUMN]

										v45 = v52[ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_ELEMENT_SIZE_HEIGHT]

										v46 = v52[ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_ELEMENT_SIZE_WIDTH]

										v47 = v52[ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_SCREEN_SIZE_HEIGHT]

										v48 = v52[ATTRIBUTE_PREFIX .. unifiedEventLogConstants.FIELD_SCREEN_SIZE_WIDTH]
										break
									end
								end
							end

							local v49 = {
								action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
								cartId = cartIdService.getCartId(),
								itemId = v41.itemId,
								itemType = 0,
								assetType = 0,
								bundleType = 0,
								gridPositionRow = 0,
								gridPositionColumn = 0,
								elementSizeHeight = 0,
								elementSizeWidth = 0,
								screenSizeHeight = 0,
								screenSizeWidth = 0
							}

							if fFlagAXUnifiedEventStrictPayloads then
								if v41.itemType == "Asset" then
									v42 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
								else
									v42 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
								end
							end

							v49.itemType = v42
							local v50

							if v41.itemType == "Asset" then
								if fFlagAXUnifiedEventStrictPayloads then
									v50 = getMarketplaceUnifiedAssetType(v41.itemSubType)
								else
									v50 = v41.itemSubType
								end
							end

							v49.assetType = v50
							local v51

							if v41.itemType ~= "Asset" then
								if fFlagAXUnifiedEventStrictPayloads then
									v51 = getMarketplaceUnifiedBundleType(v41.itemSubType)
								else
									v51 = v41.itemSubType
								end
							end

							v49.bundleType = v51
							local v52 = if fFlagAXUnifiedEventStrictPayloads then v43 or k else nil
							v49.gridPositionRow = v52

							v49.gridPositionColumn = fFlagAXUnifiedEventStrictPayloads and (v44 or 1) or nil

							if not fFlagAXUnifiedEventStrictPayloads then
								v45 = nil
							end

							v49.elementSizeHeight = v45

							if not fFlagAXUnifiedEventStrictPayloads then
								v46 = nil
							end

							v49.elementSizeWidth = v46

							if fFlagAXUnifiedEventStrictPayloads then
								if not v47 then
									v47 = if v11 then math.round(v11.Y) else nil
								end
							else
								v47 = nil
							end

							v49.screenSizeHeight = v47

							if fFlagAXUnifiedEventStrictPayloads then
								if not v48 then
									v48 = if v11 then math.round(v11.X) else nil
								end
							else
								v48 = nil
							end

							v49.screenSizeWidth = v48

							sendUnifiedEventForDeferredAction(
								v49,
								fFlagAXUnifiedEventStrictPayloads and {
									surface = getUnifiedLoggingSurface(v6)
								} or nil
							)
						end
					end
				end,
				onTimedOptionPriceChanged = fFlagAXDurablesForMIS and function(p2, p3)
					if shoppingCartStore.updateItemPrice then
						if v41.timedOptions then
							local v42 = Cryo.List.findWhere(v41.timedOptions, function(p4): boolean
								return p4.days == p3
							end) or #v41.timedOptions

							v8(SetSelectedTimedOption({
								itemId = v41.itemId,
								itemType = v41.itemType,
								selectedTimedOptionIndex = v42
							}))
						end

						shoppingCartStore.updateItemPrice(v41.itemId, v41.itemType, p2, p3)
					end
				end or nil
			}))
		end

		if
			fFlagAXMISWithOffers
			and v40.discountedItemsFromOffers
			and #Cryo.Dictionary.keys(v40.discountedItemsFromOffers) > 0
		then
			result = fn5(result, v40.discountedItemsFromOffers)
		end

		return result
	end

	local v42 = if fFlagAXUnifiedEventStrictPayloads then v11 else nil
	local v43 = if fFlagAXUnifiedEventStrictPayloads then v6 else nil
	local onOpenItemDetailsPage = data.onOpenItemDetailsPage
	local onRemoveItem = data.onRemoveItem
	local v44 = if fFlagAXDurablesForMIS then shoppingCartStore else nil
	local v45 = if fFlagAXDurablesForMIS then v8 else nil
	local v46 = if fFlagAXMISWithOffers then v40.discountedItemsFromOffers else nil
	local v47 = useMemo(fn7, {
		v10,
		v42,
		v43,
		onOpenItemDetailsPage,
		onRemoveItem,
		v44,
		v45,
		v46
	})
	local v48

	if fFlagAXEnableExpiredUserLookCheckout then
		v48 = React.useMemo(function(): boolean
			return (v6 and v6.current and v6.current.name) == avatarScreen.ExpiredUserLookCheckout
		end, { v6 })
	end

	local v49

	if fFlagAXMISWithBlackbird then
		local useMemo2 = React.useMemo
		local function fn8(): boolean
			if
				v31
				or v35
				or fFlagAXMISWithOffers
				and (not fFlagAXMISWithOffers or #Cryo.Dictionary.keys(v40.offersAvailable) ~= 0)
			then
				return false
			end

			for k, v50 in v10 do
				if
					fIntBlackbirdUpsellMinPriceForDiscountInclusive <= v50.priceInRobux
					and v50.priceInRobux <= fIntBlackbirdUpsellMaxPriceForDiscountInclusive
					and (not v50.isOwned or v50.isOwned and v50.expirationTime)
				then
					return true
				end
			end

			return false
		end

		local v51 = if fFlagAXMISWithOffers then v40.offersAvailable else nil
		v49 = useMemo2(fn8, { v31, v35, v10, v51 })
	end

	local v50 = React.useCallback(function(p2, p3, p4)
		if data.onRemoveItem then
			data.onRemoveItem(p2, p3)
		end
	end, { data.onRemoveItem, v18, v5 })

	local v51 = React.useCallback(function(p2, p3, p4)
		if data.onOpenItemDetailsPage then
			data.onOpenItemDetailsPage(p2, p3, p4)
		end
	end, { data.onOpenItemDetailsPage })

	local v52 = React.useCallback(function()
		v5.navigate(avatarScreen.CartUnavailableItemsPrompt)
	end, { v5 })

	local function fn8()
		setState2(not state2)

		if fFlagAXMISWithOffers and v9 then
			v9.setWearAfterPurchase(not state2)
		end
	end

	local v55 = React.useCallback(fn8, { state2, if fFlagAXMISWithOffers then v9 else nil })

	local function fn9()
		setState3(not state3)

		if fFlagAXMISWithOffers and v9 then
			v9.setAddToAvatars(not state3)
		end
	end

	local v58 = React.useCallback(fn9, { state3, if fFlagAXMISWithOffers then v9 else nil })
	local v59

	if fFlagAXMISWithOffers then
		v59 = React.useCallback(function()
			setState(not state)
		end, { state })
	end

	local function fn10()
		local result = {}

		for k, v60 in v10 do
			if v60.itemId == constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
				continue
			end

			local v61 = if fFlagAXMISWithOffers then v40.discountedItemsFromOffers[v60.collectibleItemId] else nil

			local v63 = if fFlagAXMISWithOffers and v61 then v61.priceInRobux else v60.priceInRobux
			local v62 = {
				agreedPriceRobux = v63,
				collectibleProductId = v60.collectibleProductId,
				collectibleItemId = 0,
				rentalOption = 0,
				offerIds = 0
			}
			local v64 = if fFlagAXMISWithOffers then v60.collectibleItemId else nil
			v62.collectibleItemId = v64
			v62.rentalOption = fFlagAXDurablesForMIS
				and v60.selectedTimedOptionDays
				and v60.selectedTimedOptionDays > 0
				and { durationDays = v60.selectedTimedOptionDays }
				or nil

			local v65 = if fFlagAXMISWithOffers and v61 then v61.offerIdsApplied else nil
			v62.offerIds = v65
			table.insert(result, v62)
		end

		return result
	end

	local v62 = React.useCallback(fn10, { v10, if fFlagAXMISWithOffers then v40 else nil })

	local v63 = React.useCallback(function()
		v8(setCurrentToastMessage({
			isLocalized = true,
			toastMessage = v32.characterSavedHeading,
			toastSubMessage = v32.characterSavedMsg,
			toastType = toastType.SuccessConfirmation
		}))
	end, { v8, v32 })

	local useCallback4 = React.useCallback
	local function fn11(p2)
		if fFlagAXCatalogMakeupSupport then
			local v64 = getTryOnItemsContainsOnlyMakeupTypes(p2)

			local v65 = not (v26 and v26[v23] and v26[v23].name) and (v64 and "Makeup" or "Avatar")
				or v26[v23].name

			if v26 and v26[v22] and v26[v22].name then
				v65 = v26[v22].name
			end

			if not v64 then
				v8(SaveAsAvatarThunk(v65, data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn, p2, v63))
			elseif fFlagAXMISSaveWearFix then
				v8(SaveAsMakeupLookThunk(v7, v65, p2, nil, data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn))
			else
				v8(SaveAsMakeupLookThunk(v7, v65, p2))
			end
		else
			v8(SaveAsAvatarThunk(
				not (v26 and v26[v22] and v26[v22].name) and "Avatar" or v26[v22].name,
				data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
				p2,
				v63
			))
		end
	end

	local getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn = data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn
	local v65 = if fFlagAXCatalogMakeupSupport then v7 else nil
	local v67 = useCallback4(fn11, {
		v8,
		v63,
		getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
		v26,
		v22,
		v65,
		if fFlagAXCatalogMakeupSupport then v23 else nil
	})

	local useCallback5 = React.useCallback
	local function fn12(p2, p3)
		local v68 = shoppingCartStore.updateCartFromPurchaseResponse(p2)
		local boughtItems = v68.boughtItems
		local equippableItems = v68.equippableItems
		local needDataRefeshItems = v68.needDataRefeshItems
		local clone, clone2

		if fFlagAXMISEnableMultiShoppingUnifiedEvents then
			clone = v26[v22]

			if clone ~= nil then
				clone = table.clone(clone)
				clone.itemId = v22
			end

			clone2 = v26[v23]

			if clone2 ~= nil then
				clone2 = table.clone(clone2)
				clone2.itemId = v23
			end
		end

		for k, needDataRefeshItem in needDataRefeshItems do
			if data.fetchItemData then
				data.fetchItemData(needDataRefeshItem.itemId, needDataRefeshItem.itemType)
			end
		end

		v8(setCurrentToastMessage({
			toastMessage = v33:Format("Feature.Catalog.Title.Checkout.ItemsPurchased", {
				count = #boughtItems
			}),
			isLocalized = true,
			toastType = toastType.InformationMessage
		}))

		local v69 = {}

		for k, equippableItem in equippableItems do
			local v70 = p3[getTryOnItemReducerKey(equippableItem.itemId, equippableItem.itemType)]

			if v70 then
				table.insert(v69, v70)
			end
		end

		if state3 then
			v67(v69)
		end

		if not fFlagAXMISSaveWearFix then
			for k, equippableItem in equippableItems do
				if data.onRemoveItem then
					data.onRemoveItem(equippableItem.itemId, equippableItem.itemType)
				end
			end
		end

		local v70 = {}

		if not fFlagAXMISSaveWearFix and fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
		end

		if state2 then
			v70 = getEquippableAssetsFromTryOnItems(v69)
		end

		local v71 = v23 ~= nil
		local getBundleOutfitInfoFromProvidedTryOns = data.getBundleOutfitInfoFromProvidedTryOns

		if not fFlagAXMISEnableMultiShoppingUnifiedEvents then
			clone = nil
		end

		if not fFlagAXMISEnableMultiShoppingUnifiedEvents then
			clone2 = nil
		end

		local v78 = if fFlagAXMISSaveWearFix then data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn else nil
		v8(PurchaseItemsSuccessThunk(
			boughtItems,
			v70,
			v28,
			v19,
			v20,
			v21,
			v69,
			getBundleOutfitInfoFromProvidedTryOns,
			v71,
			clone,
			clone2,
			v78
		))

		if fFlagAXMISSaveWearFix then
			for k, equippableItem in equippableItems do
				if data.onRemoveItem then
					data.onRemoveItem(equippableItem.itemId, equippableItem.itemType)
				end
			end

			if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
				avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
			end
		end
	end

	local updateCartFromPurchaseResponse = shoppingCartStore.updateCartFromPurchaseResponse

	local onRemoveItem2 = data.onRemoveItem
	local fetchItemData = data.fetchItemData
	local getBundleOutfitInfoFromProvidedTryOns = data.getBundleOutfitInfoFromProvidedTryOns
	local v69 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v22 else nil
	local v70 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v26 else nil
	local v71 = if fFlagAXMISSaveWearFix then data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn else nil
	local v72 = useCallback5(fn12, {
		v8,
		updateCartFromPurchaseResponse,
		state2,
		state3,
		v19,
		v20,
		v21,
		v28,
		v67,
		onRemoveItem2,
		fetchItemData,
		getBundleOutfitInfoFromProvidedTryOns,
		v23,
		v69,
		v70,
		v71
	})
	local v73

	if fFlagAXMISWithBlackbird then
		v73 = React.useCallback(function()
			local v74 = nil

			if v12 then
				for k, v76 in v12 do
					if v76.discountCampaign == discountTypeEnum.RobloxPlusSubscription then
						v74 = v76
						break
					end
				end
			end

			local v75 = {}

			if v74 then
				table.insert(v75, 1, {
					Type = discountTypeEnum.RobloxPlusSubscription,
					AmountInRobux = v15 - v14,
					Percent = v74.robuxDiscountPercentage
				})
			end

			if v40.discountSummaryEntriesFromOffers then
				for k, discountSummaryEntriesFromOffer in v40.discountSummaryEntriesFromOffers do
					table.insert(v75, {
						Type = discountSummaryEntriesFromOffer.type,
						AmountInRobux = discountSummaryEntriesFromOffer.amountInRobux,
						Percent = discountSummaryEntriesFromOffer.percent,
						LocalizedDiscountAttribution = discountSummaryEntriesFromOffer.localizedDiscountAttribution
					})
				end
			end

			v8(PurchasePromptLite.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt({
				productPayload = { kind = "RobuxUpsell" },
				purchaseCallbacks = {
					onFlowComplete = function()
						v8(closeCentralOverlay())
					end,
					fetchProductInfo = function()
						local resolve = Promise.resolve
						local robuxUpsell = {
							PriceInRobux = v14 - v40.totalSelectedOffersDiscount,
							IsForSale = true,
							Name = "RobuxUpsell",
							SavingsSummaryOverride = 0,
							BasePriceInRobux = 0,
							PriceDiscountDetails = 0
						}

						local v76 = if v74 then v40.savingsSummary else nil
						robuxUpsell.SavingsSummaryOverride = v76

						robuxUpsell.BasePriceInRobux = if v74 then v15 else nil

						robuxUpsell.PriceDiscountDetails = if v74 then v75 else nil
						return resolve(robuxUpsell)
					end
				}
			}))

			ref.current = true
		end, { v5, v8, v14, v15, v12, v40 })
	else
		v73 = React.useCallback(function()
			v5.navigate(avatarScreen.InsufficientRobuxPrompt)

			ref.current = true
		end, { v5 })
	end

	local v74

	if fFlagAXMISWithBlackbird then
		local useMemo2 = React.useMemo
		local function fn13()
			local v75 = nil

			if v12 then
				for k, v77 in v12 do
					if v77.discountCampaign == discountTypeEnum.RobloxPlusSubscription then
						v75 = v77
						break
					end
				end
			end

			if fFlagAXMISWithOffers then
				local clone = table.clone(v40.discountSummaryEntriesFromOffers)

				if v75 then
					table.insert(clone, 1, {
						type = discountTypeEnum.RobloxPlusSubscription,
						amountInRobux = v15 - v14,
						percent = v75.robuxDiscountPercentage
					})
				end

				return {
					itemPrice = {
						basePriceInRobux = v15,
						priceInRobux = math.max(v14 - v40.totalSelectedOffersDiscount, 0),
						discounts = clone
					},
					savingsSummary = v40.savingsSummary
				}
			elseif v75 and v15 and v14 then
				return {
					itemPrice = {
						basePriceInRobux = v15,
						priceInRobux = v14,
						discounts = {
							{
								type = discountTypeEnum.RobloxPlusSubscription,
								amountInRobux = v15 - v14,
								percent = v75.robuxDiscountPercentage
							}
						}
					}
				}
			else
				return nil
			end
		end

		local discountSummaryEntriesFromOffers = if fFlagAXMISWithOffers then v40.discountSummaryEntriesFromOffers else nil
		local totalSelectedOffersDiscount = if fFlagAXMISWithOffers then v40.totalSelectedOffersDiscount else nil
		local v76 = if fFlagAXMISWithOffers then v40.savingsSummary else nil
		v74 = useMemo2(fn13, {
			v15,
			v14,
			v12,
			discountSummaryEntriesFromOffers,
			totalSelectedOffersDiscount,
			v76
		})
	end

	local useCallback6 = React.useCallback
	local function fn13()
		setState4(true)

		if fFlagAXMISEnableMultiShoppingUnifiedEvents and not pcall(function()
			local clone = v26[v22]

			if clone ~= nil then
				clone = table.clone(clone)
				clone.itemId = v22
			end

			local clone2 = v26[v23]

			if clone2 ~= nil then
				clone2 = table.clone(clone2)
				clone2.itemId = v23
			end

			if clone then
				clone.isOrganicLook = v24 == nil
			end

			if clone2 then
				clone2.isOrganicLook = v25 == nil
			end

			local name = v6 and v6.current and v6.current.name
			local avatarScreenProperty = avatarScreenProperties[name]
			local unifiedLoggingSurface

			if avatarScreenProperty and avatarScreenProperty.analyticsData then
				unifiedLoggingSurface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			end

			if not fFlagAXUnifiedEventStrictPayloads then
				sendUnifiedEventsForMultiItemShopping(
					getUnifiedEventsForMIS(
						v10,
						v18,
						clone,
						clone2,
						unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
					),
					unifiedLoggingSurface
				)

				return
			end

			local unifiedEventsForMIS, v75 = getUnifiedEventsForMIS(
				v10,
				v18,
				clone,
				clone2,
				unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
				unifiedLoggingSurface,
				v24,
				v25
			)

			sendUnifiedEventsForMultiItemShopping(unifiedEventsForMIS, unifiedLoggingSurface, v75)
		end) then
			mutedError("Failed to send unified events for multi-item shopping purchase attempt")
		end

		PurchaseItems({
			networkImpl = v7,
			userId = v29,
			lookId = v22,
			makeupLookId = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v23 else nil,
			lineItems = v62()
		}):andThen(function(data2)
			if data2.isJSONValid and data2.responseCode == 200 then
				v72(mapPurchaseItemsResponse(data2.responseBody), tutils.deepCopy(v18))

				PurchasePromptLite.Events.firePurchaseCompleted()

				if data.fetchUserRobux then
					data.fetchUserRobux()
				end
			end
		end):catch(function(p2)
			if getIsInsufficientRobuxError(p2) then
				v73()
				return
			end

			local navigate = v5.navigate
			local genericPrompt = avatarScreen.GenericPrompt
			local v79 = if #v10 == 1 then v32.purchaseFailedTitle else v32.purchaseFailedTitlePlural
			navigate(genericPrompt, {
				titleText = v79,
				bodyText = v32.purchaseFailedUnknownError,
				buttonText = v32.purchaseFailedButton
			})
		end):finally(function()
			setState4(false)
		end)
	end

	local fetchUserRobux = data.fetchUserRobux
	local v76 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v23 else nil
	local v77 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v26 else nil
	local v78 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v18 else nil
	local v79 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v24 else nil
	local v80 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then v25 else nil
	local v82 = useCallback6(fn13, {
		v62,
		v29,
		v7,
		v73,
		fetchUserRobux,
		v72,
		v10,
		v32,
		v5,
		v22,
		v76,
		v77,
		v78,
		v79,
		v80,
		if fFlagAXMISEnableMultiShoppingUnifiedEvents then v6 else nil,
		PurchasePromptLite.Events.firePurchaseCompleted
	})

	local useCallback7 = React.useCallback
	local function fn14()
		local v83 = if fFlagAXMISWithOffers then v14 - v40.totalSelectedOffersDiscount else v14

		if v30 and v30 < v83 then
			v73()
		else
			v82()
		end
	end

	local v84 = if fFlagAXMISWithOffers then v40.totalSelectedOffersDiscount else nil
	local v85 = useCallback7(fn14, { v30, v14, v82, v73, v84 })

	local v86 = {
		canPurchase = v13,
		cartItems = v47,
		discounts = if fFlagAXMISWithBlackbird then v12 else nil,
		erroredItemCount = v16,
		isPurchasing = state4,
		isVisible = v39,
		hideBuyOptions = nil,
		shouldShowBlackbirdUpsellBanner = nil,
		isWearAfterPurchaseChecked = nil,
		isAddToMyAvatarsChecked = nil,
		isSaveOptionsOpen = nil,
		onCheckoutButtonActivated = nil,
		onOpenItemDetailsPage = nil,
		onRemoveItem = nil,
		onUnavailableButtonActivated = nil,
		onWearAfterPurchaseToggle = nil,
		onAddToMyAvatarsToggle = nil,
		onSaveOptionsOpenToggle = nil,
		purchasableItemsTotalPriceInRobux = 0,
		purchasableItemsTotalOriginalPriceInRobux = 0,
		robloxSubscriptionProducts = 0,
		discountSummaryProps = 0,
		offersAvailable = 0,
		handleDeselectOfferId = 0
	}

	if not fFlagAXEnableExpiredUserLookCheckout then
		v48 = nil
	end

	v86.hideBuyOptions = v48

	if not fFlagAXMISWithBlackbird then
		v49 = nil
	end

	v86.shouldShowBlackbirdUpsellBanner = v49
	v86.isWearAfterPurchaseChecked = state2
	v86.isAddToMyAvatarsChecked = state3
	v86.isSaveOptionsOpen = state
	v86.onCheckoutButtonActivated = v85
	v86.onOpenItemDetailsPage = v51
	v86.onRemoveItem = v50
	v86.onUnavailableButtonActivated = v52
	v86.onWearAfterPurchaseToggle = v55
	v86.onAddToMyAvatarsToggle = v58
	v86.onSaveOptionsOpenToggle = v59

	local v88 = if fFlagAXMISWithOffers then math.max(v14 - v40.totalSelectedOffersDiscount, 0) else v14
	v86.purchasableItemsTotalPriceInRobux = v88

	v86.purchasableItemsTotalOriginalPriceInRobux = v15

	if not fFlagAXMISWithBlackbird then
		state5 = nil
	end

	v86.robloxSubscriptionProducts = state5

	if not fFlagAXMISWithBlackbird then
		v74 = nil
	end

	v86.discountSummaryProps = v74
	local v89 = if fFlagAXMISWithOffers then v40.offersAvailable else nil
	v86.offersAvailable = v89
	local v90 = if fFlagAXMISWithOffers then v40.handleDeselectOfferId else nil
	v86.handleDeselectOfferId = v90
	return v86
end

return useCheckoutPageViewModel
