local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local NotificationService = game:GetService("NotificationService")

local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Promise = require(parent.Promise)
local tutils = require(parent.tutils)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
require(parent.Http)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact = require(parent.SignalsReact)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local ToastRodux = require(parent.ToastRodux)
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RobloxEventReceiver = RealtimeDelivery.RobloxEventReceiver

require(AvatarExperienceCatalog.Components.Checkout.CheckoutPage)

local PurchaseItemsSuccessThunk = require(AvatarExperienceCatalog.State.Thunks.PurchaseItemsSuccessThunk)
local SaveAsAvatarThunk = require(AvatarExperienceCatalog.State.Thunks.SaveAsAvatarThunk)
local SaveAsMakeupLookThunk = require(AvatarExperienceCatalog.State.Thunks.SaveAsMakeupLookThunk)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local SetSelectedTimedOption = require(AvatarExperienceCatalog.State.Actions.SetSelectedTimedOption)
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local Constants = AvatarExperienceCommon.Constants
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
local getIsInsufficientRobuxError = AvatarExperienceCommon.Utils.getIsInsufficientRobuxError

local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)
local useOffersCartPricingCalculationsForCartItems = require(AvatarExperienceCatalog.Hooks.useOffersCartPricingCalculationsForCartItems)
local useSignalState = SignalsReact.useSignalState
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useNavigationFocus = Navigation2.useNavigationFocus
local useSaveOptionsStoredValues = require(AvatarExperienceCatalog.Hooks.useSaveOptionsStoredValues)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local LocalizationRoactContext = Localization2.LocalizationRoactContext

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface
local getMarketplaceUnifiedAssetType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType
local getMarketplaceUnifiedBundleType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType
local sendUnifiedEventsForMultiItemShopping = AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping
local getUnifiedEventsForMIS = AvatarExperienceAnalytics.Utils.getUnifiedEventsForMIS
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXMISWithOffers = AvatarExperienceFlags.FFlagAXMISWithOffers
local FFlagAXMISOffersChip = AvatarExperienceFlags.FFlagAXMISOffersChip
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local FFlagAXBackgroundsEquipTryOnCounters = AvatarExperienceFlags.FFlagAXBackgroundsEquipTryOnCounters
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive
local reportBackgroundUserActionCounter = AvatarExperienceAnalytics.reportBackgroundUserActionCounter
local defineFastFlag = game:DefineFastFlag("AXFixSelectUserRobloxSubscriptionNil", false)

local function selectTryOnLookId(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local fn = FFlagAXCatalogMakeupSupport and function(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookId
end or nil
local fn2, fn3

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	fn2 = function(p)
		return p.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
	end

	fn3 = function(p)
		return p.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
	end
else
	fn2 = nil
	fn3 = nil
end

local function selectAvatarSceneLooks(p)
	return p.AvatarExperience.AvatarScene.Looks
end

local function selectScreenSize(p)
	return p.ScreenSize
end

local function selectTryOnItems(p) -- 1 equivalent call inferred from this helper
	return p.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function selectTryOnBodyColor3s(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.BodyColor3s
end

local function selectTryOnBodyScales(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.Scale
end

local function selectTryOnBodyPartColorRangeIds(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.BodyPartColorRangeIds
end

local function selectAssetInfos(p) -- 1 equivalent call inferred from this helper
	return p.AvatarExperience.Common.AssetInfos or {}
end

local function selectBundleInfos(p) -- 1 equivalent call inferred from this helper
	return p.AvatarExperience.Common.BundleInfos or {}
end

local function selectCollectibles(p) -- 1 equivalent call inferred from this helper
	return p.AvatarExperience.Common.Collectibles or {}
end

local function selectLocalUserId(p) -- 2 equivalent calls inferred from this helper
	return p.LocalUserId
end

local function selectShouldTryOnWithoutEquippedItems(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.ShouldTryOnWithoutEquippedItems
end

local function selectUserRobux(p)
	local localUserId = selectLocalUserId(p) -- inferred equivalent call

	if localUserId and p.UserRobux then
		return p.UserRobux[localUserId]
	end

	return nil
end

local function fn4(p)
	local localUserId = selectLocalUserId(p) -- inferred equivalent call

	if localUserId and p.Users and (not defineFastFlag or p.Users[localUserId]) then
		return p.Users[localUserId].hasRobloxSubscription
	end

	return false
end

local function selectItemInfoForTryOnItems(p)
	local tryOnItems = selectTryOnItems(p) -- inferred equivalent call
	local assetInfos = selectAssetInfos(p) -- inferred equivalent call
	local bundleInfos = selectBundleInfos(p) -- inferred equivalent call
	local collectibles = selectCollectibles(p) -- inferred equivalent call
	local itemInfoForTryOnItems = {}

	for _, v in tryOnItems do
		if v.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
			table.insert(itemInfoForTryOnItems, {
				itemId = v.itemId,
				itemType = v.itemType,
				itemData = v.itemData,
				collectibleItemId = v.itemId,
				ordering = v.itemRecency
			})
		else
			local itemData

			if v.itemType == Enum.AvatarItemType.Asset.Name then
				itemData = assetInfos[v.itemId]
			else
				itemData = bundleInfos[v.itemId]
			end

			local collectibleItemId

			if itemData then
				collectibleItemId = itemData.collectibleItemId
			end

			local collectibleItemInfo

			if collectibleItemId and collectibles.CollectiblesItemInfo then
				collectibleItemInfo = collectibles.CollectiblesItemInfo[collectibleItemId]
			end

			if itemData and collectibleItemId and collectibleItemInfo then
				local resellableInstances

				if collectibles.CollectiblesResellableInstances then
					resellableInstances = collectibles.CollectiblesResellableInstances[collectibleItemId]
				end

				local v2 = {
					itemId = v.itemId,
					itemType = v.itemType,
					itemData = itemData,
					collectibleItemId = collectibleItemId,
					ordering = v.itemRecency,
					collectibleItemInfo = collectibleItemInfo,
					resellableInstances = resellableInstances,
					selectedTimedOptionIndex = 0
				}
				local selectedTimedOptionIndex

				if FFlagAXDurablesForMIS then
					selectedTimedOptionIndex = v.selectedTimedOptionIndex
				end

				v2.selectedTimedOptionIndex = selectedTimedOptionIndex
				table.insert(itemInfoForTryOnItems, v2)
			end
		end
	end

	return itemInfoForTryOnItems
end

local function fn5(items, discountedItemsFromOffers)
	local clones = {}

	for _, item in items do
		local clone = table.clone(item)

		if discountedItemsFromOffers[clone.collectibleItemId] then
			clone.discountInformation = discountedItemsFromOffers[clone.collectibleItemId].discountInformation or {}
			clone.priceInRobuxDiscountedByOffers = discountedItemsFromOffers[clone.collectibleItemId].priceInRobux
			local offerApplied

			if FFlagAXMISOffersChip then
				offerApplied = #discountedItemsFromOffers[clone.collectibleItemId].offerIdsApplied > 0
			end

			clone.offerApplied = offerApplied
		end

		table.insert(clones, clone)
	end

	return clones
end

local function useCheckoutPageViewModel(data)
	local PurchasePromptLite = require(parent.PurchasePromptLite)

	local shoppingCartStore = useAXCatalogStoreContext().shoppingCartStore

	local v = useNavigation()
	local v2 = useAvatarRoute()
	local networkImpl = useNetworking()
	local v3 = useDispatch()
	local v4

	if FFlagAXMISWithOffers then
		v4 = useSaveOptionsStoredValues()
	else
		v4 = nil
	end

	local v5 = useSignalState(shoppingCartStore.getItems)
	local v6

	if FFlagAXUnifiedEventStrictPayloads then
		v6 = useSelector(selectScreenSize)
	else
		v6 = nil
	end

	local v7

	if FFlagAXMISWithBlackbird then
		v7 = useSignalState(shoppingCartStore.getDiscounts)
	else
		v7 = nil
	end

	local canPurchase = useSignalState(shoppingCartStore.getCanPurchase)
	local priceInRobux = useSignalState(shoppingCartStore.getPurchasableItemsTotalPriceInRobux)

	local v8 = useSignalState(shoppingCartStore.getPurchasableItemsTotalOriginalPriceInRobux)
	local erroredItemCount = useSignalState(shoppingCartStore.getErroredItemCount)
	local state, setState

	if FFlagAXMISWithOffers then
		state, setState = React.useState(false)
	else
		setState = nil
		state = nil
	end

	local state2, setState2 = React.useState(not (FFlagAXMISWithOffers and v4) or v4.getWearAfterPurchase())

	local useState = React.useState
	local v9

	if FFlagAXMISWithOffers and v4 then
		v9 = v4.getAddToAvatars()
	else
		v9 = false
	end

	local state3, setState3 = useState(v9)

	local state4, setState4 = React.useState(false)
	local state5, setState5

	if FFlagAXMISWithBlackbird then
		state5, setState5 = React.useState({})
	else
		setState5 = nil
	end

	local state6, setState6

	if FFlagAXMISWithOffers then
		state6, setState6 = React.useState(false)
	else
		setState6 = nil
	end

	local v10 = useSelector(selectTryOnItems, tutils.deepEqual)
	local v11 = useSelector(selectTryOnBodyColor3s, tutils.deepEqual)
	local v12 = useSelector(selectTryOnBodyScales, tutils.deepEqual)
	local v13 = useSelector(selectTryOnBodyPartColorRangeIds, tutils.deepEqual)
	local v14 = useSelector(selectTryOnLookId)
	local itemId

	if FFlagAXCatalogMakeupSupport then
		itemId = useSelector(fn)
	else
		itemId = nil
	end

	local v15

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v15 = useSelector(fn2)
	else
		v15 = nil
	end

	local v16

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v16 = useSelector(fn3)
	else
		v16 = nil
	end

	local v17 = useSelector(selectAvatarSceneLooks, tutils.deepEqual)
	local v18 = useSelector(selectItemInfoForTryOnItems, tutils.deepEqual)
	local v19 = useSelector(selectShouldTryOnWithoutEquippedItems)
	local userId = useSelector(selectLocalUserId)
	local v20 = useSelector(selectUserRobux)
	local v21

	if FFlagAXMISWithBlackbird then
		v21 = useSelector(fn4)
	else
		v21 = nil
	end

	local v22 = useLocalization({
		purchaseFailedTitle = "Feature.Catalog.Title.Checkout.PurchaseFailedSingular",
		purchaseFailedTitlePlural = {
			"Feature.Catalog.Title.Checkout.PurchaseFailedPlural",
			count = #v5
		},
		purchaseFailedUnknownError = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		purchaseFailedButton = "Feature.Avatar.Action.GotIt",
		characterSavedHeading = "Feature.Avatar.Heading.LooksAvatarSaved",
		characterSavedMsg = "Feature.Avatar.Message.LooksAvatarSaved"
	})

	local v23 = React.useContext(LocalizationRoactContext)
	local v24 = useAppPolicy(function(p)
		return p.getDisableResellingCollectiblesForCompliance()
	end)
	local v25

	if FFlagAXMISWithBlackbird then
		v25 = useAppPolicy(function(p)
			return p.getDisableBlackbirdEntrypoints()
		end)
	else
		v25 = nil
	end

	local ref = React.useRef(false)

	local v26 = useNavigationFocus()
	local ref2

	if FFlagAXEnableExpiredUserLookCheckout then
		local v27 = React.useMemo(function()
			return RobloxEventReceiver.new(NotificationService)
		end, {})
		ref2 = React.useRef(nil)

		if v27 ~= nil then
			ref2.current = v27:observeEvent("AvatarAssetOwnershipNotifications", function()
				local v28

				if FFlagAXEnableExpiredUserLookCheckout then
					v28 = v2 and v2.current and v2.current.name
				end

				if v28 == AvatarScreen.ExpiredUserLookCheckout then
					v.pop(2)
				end
			end)
		end
	else
		ref2 = nil
	end

	React.useEffect(function()
		if data.fetchUserRobux and not v20 then
			data.fetchUserRobux()
		end

		if FFlagAXMISWithBlackbird then
			getRobloxSubscriptionProducts():andThen(function(p)
				setState5(p)
			end):catch(function(p)
				mutedError("CheckoutPageViewModel", "Failed to fetch Roblox subscription products: " .. tostring(p))
			end)
		end

		return function()
			if FFlagAXEnableExpiredUserLookCheckout and ref2.current ~= nil then
				ref2.current:disconnect()
				ref2.current = nil
			end
		end
	end, {})

	React.useEffect(function()
		if v26 and ref.current and data.fetchUserRobux then
			data.fetchUserRobux()
			ref.current = false
		end
	end, { v26, data.fetchUserRobux })

	local useLayoutEffect = React.useLayoutEffect
	local function fn6()
		shoppingCartStore.syncFromTryOns(v18, v24)

		if FFlagAXMISWithOffers then
			setState6(true)
		end

		local name

		if FFlagAXEnableExpiredUserLookCheckout then
			name = v2 and v2.current and v2.current.name
		end

		if FFlagAXEnableExpiredUserLookCheckout then
			if
				v18
				and #v18 <= 0
				and (name == AvatarScreen.Checkout or name == AvatarScreen.ExpiredUserLookCheckout)
			then
				v.goBack()
			end
		elseif v18 and #v18 <= 0 then
			v.goBack()
		end
	end

	local v27

	if FFlagAXEnableExpiredUserLookCheckout then
		v27 = v2
	end

	useLayoutEffect(fn6, { shoppingCartStore, v18, v24, v, v27 })

	local isVisible = React.useMemo(function(): boolean
		local name = v2 and v2.current and v2.current.name

		if FFlagAXEnableExpiredUserLookCheckout then
			return name == AvatarScreen.ExpiredUserLookCheckout or name == AvatarScreen.Checkout
		end

		return name == AvatarScreen.Checkout
	end, { v2 })
	local v28

	if FFlagAXMISWithOffers then
		v28 = useOffersCartPricingCalculationsForCartItems(v5, isVisible, state6)
	else
		v28 = nil
	end

	local useMemo = React.useMemo
	local function fn7()
		local result = {}

		for k, v29 in v5 do
			table.insert(result, Cryo.Dictionary.join(v29, {
				onActivated = function()
					if v29.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
						return
					end

					if data.onOpenItemDetailsPage then
						data.onOpenItemDetailsPage(v29.itemId, v29.itemType, v29.itemSubType)
					end
				end,
				onRemove = function()
					if data.onRemoveItem then
						if FFlagAXBackgroundsEquipTryOnCounters then
							reportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset(
								"RemoveTryOn",
								v29.itemType,
								v29.itemSubType
							)
						end

						data.onRemoveItem(v29.itemId, v29.itemType)

						if FFlagAXMISEnableMultiShoppingUnifiedEvents then
							local itemType = nil

							if v29.itemType == "Asset" then
								itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
							elseif v29.itemType == "Bundle" then
								itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
							end

							local v30 = nil
							local v31 = nil
							local elementSizeHeight = nil
							local elementSizeWidth = nil
							local screenSizeHeight = nil
							local screenSizeWidth = nil

							if FFlagAXUnifiedEventStrictPayloads then
								local ATTRIBUTE_PREFIX = UnifiedEventLogConstants.ATTRIBUTE_PREFIX
								local v32 = ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ITEM_ID
								local v46 = ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ITEM_TYPE

								for _, v48 in UnifiedSelectionListStore.getSelectionList() do
									if
										tostring(v48[v32]) == tostring(v29.itemId)
										and tostring(v48[v46]) == tostring(itemType)
									then
										v30 = v48[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_GRID_POSITION_ROW]

										v31 = v48[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_GRID_POSITION_COLUMN]

										elementSizeHeight = v48[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ELEMENT_SIZE_HEIGHT]

										elementSizeWidth = v48[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_ELEMENT_SIZE_WIDTH]

										screenSizeHeight = v48[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_SCREEN_SIZE_HEIGHT]

										screenSizeWidth = v48[ATTRIBUTE_PREFIX .. UnifiedEventLogConstants.FIELD_SCREEN_SIZE_WIDTH]
										break
									end
								end
							end

							local v32 = {
								action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
								cartId = CartIdService.getCartId(),
								itemId = v29.itemId,
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

							if FFlagAXUnifiedEventStrictPayloads then
								if v29.itemType == "Asset" then
									itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
								else
									itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
								end
							end

							v32.itemType = itemType
							local assetType

							if v29.itemType == "Asset" then
								if FFlagAXUnifiedEventStrictPayloads then
									assetType = getMarketplaceUnifiedAssetType(v29.itemSubType)
								else
									assetType = v29.itemSubType
								end
							end

							v32.assetType = assetType
							local bundleType

							if v29.itemType ~= "Asset" then
								if FFlagAXUnifiedEventStrictPayloads then
									bundleType = getMarketplaceUnifiedBundleType(v29.itemSubType)
								else
									bundleType = v29.itemSubType
								end
							end

							v32.bundleType = bundleType
							local gridPositionRow

							if FFlagAXUnifiedEventStrictPayloads then
								gridPositionRow = v30 or k
							end

							v32.gridPositionRow = gridPositionRow

							v32.gridPositionColumn = FFlagAXUnifiedEventStrictPayloads and (v31 or 1) or nil

							if not FFlagAXUnifiedEventStrictPayloads then
								elementSizeHeight = nil
							end

							v32.elementSizeHeight = elementSizeHeight

							if not FFlagAXUnifiedEventStrictPayloads then
								elementSizeWidth = nil
							end

							v32.elementSizeWidth = elementSizeWidth

							if FFlagAXUnifiedEventStrictPayloads then
								if not screenSizeHeight then
									if v6 then
										screenSizeHeight = math.round(v6.Y)
									else
										screenSizeHeight = nil
									end
								end
							else
								screenSizeHeight = nil
							end

							v32.screenSizeHeight = screenSizeHeight

							if FFlagAXUnifiedEventStrictPayloads then
								if not screenSizeWidth then
									if v6 then
										screenSizeWidth = math.round(v6.X)
									else
										screenSizeWidth = nil
									end
								end
							else
								screenSizeWidth = nil
							end

							v32.screenSizeWidth = screenSizeWidth

							sendUnifiedEventForDeferredAction(
								v32,
								FFlagAXUnifiedEventStrictPayloads and {
									surface = getUnifiedLoggingSurface(v2)
								} or nil
							)
						end
					end
				end,
				onTimedOptionPriceChanged = FFlagAXDurablesForMIS and function(p: number, p2: number?)
					if shoppingCartStore.updateItemPrice then
						if v29.timedOptions then
							local selectedTimedOptionIndex = Cryo.List.findWhere(v29.timedOptions, function(p3): boolean
								return p3.days == p2
							end) or #v29.timedOptions

							v3(SetSelectedTimedOption({
								itemId = v29.itemId,
								itemType = v29.itemType,
								selectedTimedOptionIndex = selectedTimedOptionIndex
							}))
						end

						shoppingCartStore.updateItemPrice(v29.itemId, v29.itemType, p, p2)
					end
				end or nil
			}))
		end

		if
			FFlagAXMISWithOffers
			and v28.discountedItemsFromOffers
			and #Cryo.Dictionary.keys(v28.discountedItemsFromOffers) > 0
		then
			result = fn5(result, v28.discountedItemsFromOffers)
		end

		return result
	end

	local v29

	if FFlagAXUnifiedEventStrictPayloads then
		v29 = v6
	end

	local v30

	if FFlagAXUnifiedEventStrictPayloads then
		v30 = v2
	end

	local onOpenItemDetailsPage = data.onOpenItemDetailsPage
	local onRemoveItem = data.onRemoveItem
	local v31

	if FFlagAXDurablesForMIS then
		v31 = shoppingCartStore
	end

	local v32

	if FFlagAXDurablesForMIS then
		v32 = v3
	end

	local v42

	if FFlagAXMISWithOffers then
		v42 = v28.discountedItemsFromOffers
	end

	local cartItems = useMemo(fn7, {
		v5,
		v29,
		v30,
		onOpenItemDetailsPage,
		onRemoveItem,
		v31,
		v32,
		v42
	})
	local hideBuyOptions

	if FFlagAXEnableExpiredUserLookCheckout then
		hideBuyOptions = React.useMemo(function(): boolean
			return (v2 and v2.current and v2.current.name) == AvatarScreen.ExpiredUserLookCheckout
		end, { v2 })
	end

	local shouldShowBlackbirdUpsellBanner

	if FFlagAXMISWithBlackbird then
		local useMemo2 = React.useMemo
		local function fn8(): boolean
			if
				v21
				or v25
				or FFlagAXMISWithOffers
				and (not FFlagAXMISWithOffers or #Cryo.Dictionary.keys(v28.offersAvailable) ~= 0)
			then
				return false
			end

			for _, v46 in v5 do
				if
					FIntBlackbirdUpsellMinPriceForDiscountInclusive <= v46.priceInRobux
					and v46.priceInRobux <= FIntBlackbirdUpsellMaxPriceForDiscountInclusive
					and (not v46.isOwned or v46.isOwned and v46.expirationTime)
				then
					return true
				end
			end

			return false
		end

		local v47

		if FFlagAXMISWithOffers then
			v47 = v28.offersAvailable
		end

		shouldShowBlackbirdUpsellBanner = useMemo2(fn8, { v21, v25, v5, v47 })
	end

	local onRemoveItem3 = React.useCallback(function(p: string, p2: string, _: string)
		if data.onRemoveItem then
			data.onRemoveItem(p, p2)
		end
	end, { data.onRemoveItem, v10, v })

	local onOpenItemDetailsPage2 = React.useCallback(function(p: string, p2: string, p3: string)
		if data.onOpenItemDetailsPage then
			data.onOpenItemDetailsPage(p, p2, p3)
		end
	end, { data.onOpenItemDetailsPage })

	local onUnavailableButtonActivated = React.useCallback(function()
		v.navigate(AvatarScreen.CartUnavailableItemsPrompt)
	end, { v })

	local useCallback = React.useCallback
	local function fn8()
		setState2(not state2)

		if FFlagAXMISWithOffers and v4 then
			v4.setWearAfterPurchase(not state2)
		end
	end

	local v50

	if FFlagAXMISWithOffers then
		v50 = v4
	end

	local onWearAfterPurchaseToggle = useCallback(fn8, { state2, v50 })

	local useCallback2 = React.useCallback
	local function fn9()
		setState3(not state3)

		if FFlagAXMISWithOffers and v4 then
			v4.setAddToAvatars(not state3)
		end
	end

	local v53

	if FFlagAXMISWithOffers then
		v53 = v4
	end

	local onAddToMyAvatarsToggle = useCallback2(fn9, { state3, v53 })
	local onSaveOptionsOpenToggle

	if FFlagAXMISWithOffers then
		onSaveOptionsOpenToggle = React.useCallback(function()
			setState(not state)
		end, { state })
	end

	local useCallback3 = React.useCallback
	local function fn10()
		local result = {}

		for _, v56 in v5 do
			if v56.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
				continue
			end

			local v57

			if FFlagAXMISWithOffers then
				v57 = v28.discountedItemsFromOffers[v56.collectibleItemId]
			end

			local agreedPriceRobux

			if FFlagAXMISWithOffers and v57 then
				agreedPriceRobux = v57.priceInRobux
			else
				agreedPriceRobux = v56.priceInRobux
			end

			local v58 = {
				agreedPriceRobux = agreedPriceRobux,
				collectibleProductId = v56.collectibleProductId,
				collectibleItemId = 0,
				rentalOption = 0,
				offerIds = 0
			}
			local collectibleItemId

			if FFlagAXMISWithOffers then
				collectibleItemId = v56.collectibleItemId
			end

			v58.collectibleItemId = collectibleItemId
			v58.rentalOption = FFlagAXDurablesForMIS
				and v56.selectedTimedOptionDays
				and v56.selectedTimedOptionDays > 0
				and { durationDays = v56.selectedTimedOptionDays }
				or nil
			local offerIds

			if FFlagAXMISWithOffers and v57 then
				offerIds = v57.offerIdsApplied
			end

			v58.offerIds = offerIds
			table.insert(result, v58)
		end

		return result
	end

	local v57

	if FFlagAXMISWithOffers then
		v57 = v28
	end

	local v58 = useCallback3(fn10, { v5, v57 })

	local v59 = React.useCallback(function()
		v3(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v22.characterSavedHeading,
			toastSubMessage = v22.characterSavedMsg,
			toastType = ToastType.SuccessConfirmation
		}))
	end, { v3, v22 })

	local useCallback4 = React.useCallback
	local function fn11(p)
		if FFlagAXCatalogMakeupSupport then
			local tryOnItemsContainsOnlyMakeupTypes = getTryOnItemsContainsOnlyMakeupTypes(p)

			local v60 = not (v17 and v17[itemId] and v17[itemId].name)
				and (tryOnItemsContainsOnlyMakeupTypes and "Makeup" or "Avatar")
				or v17[itemId].name

			if v17 and v17[v14] and v17[v14].name then
				v60 = v17[v14].name
			end

			if not tryOnItemsContainsOnlyMakeupTypes then
				v3(SaveAsAvatarThunk(v60, data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn, p, v59))
			elseif FFlagAXMISSaveWearFix then
				v3(SaveAsMakeupLookThunk(
					networkImpl,
					v60,
					p,
					nil,
					data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn
				))
			else
				v3(SaveAsMakeupLookThunk(networkImpl, v60, p))
			end
		else
			v3(SaveAsAvatarThunk(
				not (v17 and v17[v14] and v17[v14].name) and "Avatar" or v17[v14].name,
				data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
				p,
				v59
			))
		end
	end

	local getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn = data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn
	local v61

	if FFlagAXCatalogMakeupSupport then
		v61 = networkImpl
	end

	local v62

	if FFlagAXCatalogMakeupSupport then
		v62 = itemId
	end

	local v63 = useCallback4(fn11, {
		v3,
		v59,
		getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
		v17,
		v14,
		v61,
		v62
	})

	local useCallback5 = React.useCallback
	local function fn12(p, p2)
		local v64 = shoppingCartStore.updateCartFromPurchaseResponse(p)
		local boughtItems = v64.boughtItems
		local equippableItems = v64.equippableItems
		local needDataRefeshItems = v64.needDataRefeshItems
		local clone, clone2

		if FFlagAXMISEnableMultiShoppingUnifiedEvents then
			clone = v17[v14]

			if clone ~= nil then
				clone = table.clone(clone)
				clone.itemId = v14
			end

			clone2 = v17[itemId]

			if clone2 ~= nil then
				clone2 = table.clone(clone2)
				clone2.itemId = itemId
			end
		end

		for _, needDataRefeshItem in needDataRefeshItems do
			if data.fetchItemData then
				data.fetchItemData(needDataRefeshItem.itemId, needDataRefeshItem.itemType)
			end
		end

		v3(SetCurrentToastMessage({
			toastMessage = v23:Format("Feature.Catalog.Title.Checkout.ItemsPurchased", {
				count = #boughtItems
			}),
			isLocalized = true,
			toastType = ToastType.InformationMessage
		}))

		local v65 = {}

		for _, equippableItem in equippableItems do
			local v66 = p2[getTryOnItemReducerKey(equippableItem.itemId, equippableItem.itemType)]

			if v66 then
				table.insert(v65, v66)
			end
		end

		if state3 then
			v63(v65)
		end

		if not FFlagAXMISSaveWearFix then
			for _, equippableItem in equippableItems do
				if data.onRemoveItem then
					data.onRemoveItem(equippableItem.itemId, equippableItem.itemType)
				end
			end
		end

		local v66 = {}

		if not FFlagAXMISSaveWearFix and FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
			avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
		end

		if state2 then
			v66 = getEquippableAssetsFromTryOnItems(v65)
		end

		local v67 = itemId ~= nil
		local getBundleOutfitInfoFromProvidedTryOns = data.getBundleOutfitInfoFromProvidedTryOns

		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then
			clone = nil
		end

		if not FFlagAXMISEnableMultiShoppingUnifiedEvents then
			clone2 = nil
		end

		local v68

		if FFlagAXMISSaveWearFix then
			v68 = data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn
		end

		v3(PurchaseItemsSuccessThunk(
			boughtItems,
			v66,
			v19,
			v11,
			v12,
			v13,
			v65,
			getBundleOutfitInfoFromProvidedTryOns,
			v67,
			clone,
			clone2,
			v68
		))

		if FFlagAXMISSaveWearFix then
			for _, equippableItem in equippableItems do
				if data.onRemoveItem then
					data.onRemoveItem(equippableItem.itemId, equippableItem.itemType)
				end
			end

			if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
				avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
			end
		end
	end

	local updateCartFromPurchaseResponse = shoppingCartStore.updateCartFromPurchaseResponse

	local onRemoveItem2 = data.onRemoveItem
	local fetchItemData = data.fetchItemData
	local getBundleOutfitInfoFromProvidedTryOns = data.getBundleOutfitInfoFromProvidedTryOns
	local v65

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v65 = v14
	end

	local v66

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v66 = v17
	end

	local v67

	if FFlagAXMISSaveWearFix then
		v67 = data.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn
	end

	local v68 = useCallback5(fn12, {
		v3,
		updateCartFromPurchaseResponse,
		state2,
		state3,
		v11,
		v12,
		v13,
		v19,
		v63,
		onRemoveItem2,
		fetchItemData,
		getBundleOutfitInfoFromProvidedTryOns,
		itemId,
		v65,
		v66,
		v67
	})
	local v69

	if FFlagAXMISWithBlackbird then
		v69 = React.useCallback(function()
			local v70 = nil

			if v7 then
				for _, v72 in v7 do
					if v72.discountCampaign == DiscountTypeEnum.RobloxPlusSubscription then
						v70 = v72
						break
					end
				end
			end

			local v71 = {}

			if v70 then
				table.insert(v71, 1, {
					Type = DiscountTypeEnum.RobloxPlusSubscription,
					AmountInRobux = v8 - priceInRobux,
					Percent = v70.robuxDiscountPercentage
				})
			end

			if v28.discountSummaryEntriesFromOffers then
				for _, discountSummaryEntriesFromOffer in v28.discountSummaryEntriesFromOffers do
					table.insert(v71, {
						Type = discountSummaryEntriesFromOffer.type,
						AmountInRobux = discountSummaryEntriesFromOffer.amountInRobux,
						Percent = discountSummaryEntriesFromOffer.percent,
						LocalizedDiscountAttribution = discountSummaryEntriesFromOffer.localizedDiscountAttribution
					})
				end
			end

			v3(PurchasePromptLite.Thunks.OpenCentralOverlayForUnifiedPurchasePrompt({
				productPayload = { kind = "RobuxUpsell" },
				purchaseCallbacks = {
					onFlowComplete = function()
						v3(CloseCentralOverlay())
					end,
					fetchProductInfo = function()
						local resolve = Promise.resolve
						local robuxUpsell = {
							PriceInRobux = priceInRobux - v28.totalSelectedOffersDiscount,
							IsForSale = true,
							Name = "RobuxUpsell",
							SavingsSummaryOverride = 0,
							BasePriceInRobux = 0,
							PriceDiscountDetails = 0
						}
						local savingsSummaryOverride

						if v70 then
							savingsSummaryOverride = v28.savingsSummary
						end

						robuxUpsell.SavingsSummaryOverride = savingsSummaryOverride
						local basePriceInRobux

						if v70 then
							basePriceInRobux = v8
						end

						robuxUpsell.BasePriceInRobux = basePriceInRobux
						local priceDiscountDetails

						if v70 then
							priceDiscountDetails = v71
						end

						robuxUpsell.PriceDiscountDetails = priceDiscountDetails
						return resolve(robuxUpsell)
					end
				}
			}))

			ref.current = true
		end, { v, v3, priceInRobux, v8, v7, v28 })
	else
		v69 = React.useCallback(function()
			v.navigate(AvatarScreen.InsufficientRobuxPrompt)

			ref.current = true
		end, { v })
	end

	local discountSummaryProps

	if FFlagAXMISWithBlackbird then
		local useMemo2 = React.useMemo
		local function fn13()
			local v71 = nil

			if v7 then
				for _, v73 in v7 do
					if v73.discountCampaign == DiscountTypeEnum.RobloxPlusSubscription then
						v71 = v73
						break
					end
				end
			end

			if FFlagAXMISWithOffers then
				local clone = table.clone(v28.discountSummaryEntriesFromOffers)

				if v71 then
					table.insert(clone, 1, {
						type = DiscountTypeEnum.RobloxPlusSubscription,
						amountInRobux = v8 - priceInRobux,
						percent = v71.robuxDiscountPercentage
					})
				end

				return {
					itemPrice = {
						basePriceInRobux = v8,
						priceInRobux = math.max(priceInRobux - v28.totalSelectedOffersDiscount, 0),
						discounts = clone
					},
					savingsSummary = v28.savingsSummary
				}
			elseif v71 and v8 and priceInRobux then
				return {
					itemPrice = {
						basePriceInRobux = v8,
						priceInRobux = priceInRobux,
						discounts = {
							{
								type = DiscountTypeEnum.RobloxPlusSubscription,
								amountInRobux = v8 - priceInRobux,
								percent = v71.robuxDiscountPercentage
							}
						}
					}
				}
			else
				return nil
			end
		end

		local discountSummaryEntriesFromOffers

		if FFlagAXMISWithOffers then
			discountSummaryEntriesFromOffers = v28.discountSummaryEntriesFromOffers
		end

		local totalSelectedOffersDiscount

		if FFlagAXMISWithOffers then
			totalSelectedOffersDiscount = v28.totalSelectedOffersDiscount
		end

		local v72

		if FFlagAXMISWithOffers then
			v72 = v28.savingsSummary
		end

		discountSummaryProps = useMemo2(fn13, {
			v8,
			priceInRobux,
			v7,
			discountSummaryEntriesFromOffers,
			totalSelectedOffersDiscount,
			v72
		})
	end

	local useCallback6 = React.useCallback
	local function fn13()
		setState4(true)

		if FFlagAXMISEnableMultiShoppingUnifiedEvents and not pcall(function()
			local clone = v17[v14]

			if clone ~= nil then
				clone = table.clone(clone)
				clone.itemId = v14
			end

			local clone2 = v17[itemId]

			if clone2 ~= nil then
				clone2 = table.clone(clone2)
				clone2.itemId = itemId
			end

			if clone then
				clone.isOrganicLook = v15 == nil
			end

			if clone2 then
				clone2.isOrganicLook = v16 == nil
			end

			local name = v2 and v2.current and v2.current.name
			local avatarScreenProperty = AvatarScreenProperties[name]
			local unifiedLoggingSurface

			if avatarScreenProperty and avatarScreenProperty.analyticsData then
				unifiedLoggingSurface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			end

			if not FFlagAXUnifiedEventStrictPayloads then
				sendUnifiedEventsForMultiItemShopping(
					getUnifiedEventsForMIS(
						v5,
						v10,
						clone,
						clone2,
						UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT
					),
					unifiedLoggingSurface
				)

				return
			end

			local unifiedEventsForMIS, v71 = getUnifiedEventsForMIS(
				v5,
				v10,
				clone,
				clone2,
				UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
				unifiedLoggingSurface,
				v15,
				v16
			)

			sendUnifiedEventsForMultiItemShopping(unifiedEventsForMIS, unifiedLoggingSurface, v71)
		end) then
			mutedError("Failed to send unified events for multi-item shopping purchase attempt")
		end

		local v71 = {
			networkImpl = networkImpl,
			userId = userId,
			lookId = v14,
			makeupLookId = nil,
			lineItems = 0
		}
		local makeupLookId

		if FFlagAXMISEnableMultiShoppingUnifiedEvents then
			makeupLookId = itemId
		end

		v71.makeupLookId = makeupLookId
		v71.lineItems = v58()
		PurchaseItems(v71):andThen(function(data2)
			if data2.isJSONValid and data2.responseCode == 200 then
				v68(mapPurchaseItemsResponse(data2.responseBody), tutils.deepCopy(v10))

				PurchasePromptLite.Events.firePurchaseCompleted()

				if data.fetchUserRobux then
					data.fetchUserRobux()
				end
			end
		end):catch(function(p)
			if getIsInsufficientRobuxError(p) then
				v69()
				return
			end

			local navigate = v.navigate
			local genericPrompt = AvatarScreen.GenericPrompt
			local titleText

			if #v5 == 1 then
				titleText = v22.purchaseFailedTitle
			else
				titleText = v22.purchaseFailedTitlePlural
			end

			navigate(genericPrompt, {
				titleText = titleText,
				bodyText = v22.purchaseFailedUnknownError,
				buttonText = v22.purchaseFailedButton
			})
		end):finally(function()
			setState4(false)
		end)
	end

	local fetchUserRobux = data.fetchUserRobux
	local v72

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v72 = itemId
	end

	local v73

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v73 = v17
	end

	local v74

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v74 = v10
	end

	local v75

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v75 = v15
	end

	local v76

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v76 = v16
	end

	local v77

	if FFlagAXMISEnableMultiShoppingUnifiedEvents then
		v77 = v2
	end

	local v78 = useCallback6(fn13, {
		v58,
		userId,
		networkImpl,
		v69,
		fetchUserRobux,
		v68,
		v5,
		v22,
		v,
		v14,
		v72,
		v73,
		v74,
		v75,
		v76,
		v77,
		PurchasePromptLite.Events.firePurchaseCompleted
	})

	local useCallback7 = React.useCallback
	local function fn14()
		local v79

		if FFlagAXMISWithOffers then
			v79 = priceInRobux - v28.totalSelectedOffersDiscount
		else
			v79 = priceInRobux
		end

		if v20 and v20 < v79 then
			v69()
		else
			v78()
		end
	end

	local v80

	if FFlagAXMISWithOffers then
		v80 = v28.totalSelectedOffersDiscount
	end

	local onCheckoutButtonActivated = useCallback7(fn14, { v20, priceInRobux, v78, v69, v80 })
	local discounts

	if FFlagAXMISWithBlackbird then
		discounts = v7
	end

	if not FFlagAXEnableExpiredUserLookCheckout then
		hideBuyOptions = nil
	end

	if not FFlagAXMISWithBlackbird then
		shouldShowBlackbirdUpsellBanner = nil
	end

	local v82 = {
		canPurchase = canPurchase,
		cartItems = cartItems,
		discounts = discounts,
		erroredItemCount = erroredItemCount,
		isPurchasing = state4,
		isVisible = isVisible,
		hideBuyOptions = hideBuyOptions,
		shouldShowBlackbirdUpsellBanner = shouldShowBlackbirdUpsellBanner,
		isWearAfterPurchaseChecked = state2,
		isAddToMyAvatarsChecked = state3,
		isSaveOptionsOpen = state,
		onCheckoutButtonActivated = onCheckoutButtonActivated,
		onOpenItemDetailsPage = onOpenItemDetailsPage2,
		onRemoveItem = onRemoveItem3,
		onUnavailableButtonActivated = onUnavailableButtonActivated,
		onWearAfterPurchaseToggle = onWearAfterPurchaseToggle,
		onAddToMyAvatarsToggle = onAddToMyAvatarsToggle,
		onSaveOptionsOpenToggle = onSaveOptionsOpenToggle,
		purchasableItemsTotalPriceInRobux = 0,
		purchasableItemsTotalOriginalPriceInRobux = 0,
		robloxSubscriptionProducts = 0,
		discountSummaryProps = 0,
		offersAvailable = 0,
		handleDeselectOfferId = 0
	}
	local purchasableItemsTotalPriceInRobux

	if FFlagAXMISWithOffers then
		purchasableItemsTotalPriceInRobux = math.max(priceInRobux - v28.totalSelectedOffersDiscount, 0)
	else
		purchasableItemsTotalPriceInRobux = priceInRobux
	end

	v82.purchasableItemsTotalPriceInRobux = purchasableItemsTotalPriceInRobux

	v82.purchasableItemsTotalOriginalPriceInRobux = v8

	if not FFlagAXMISWithBlackbird then
		state5 = nil
	end

	v82.robloxSubscriptionProducts = state5

	if not FFlagAXMISWithBlackbird then
		discountSummaryProps = nil
	end

	v82.discountSummaryProps = discountSummaryProps
	local offersAvailable

	if FFlagAXMISWithOffers then
		offersAvailable = v28.offersAvailable
	end

	v82.offersAvailable = offersAvailable
	local handleDeselectOfferId

	if FFlagAXMISWithOffers then
		handleDeselectOfferId = v28.handleDeselectOfferId
	end

	v82.handleDeselectOfferId = handleDeselectOfferId
	return v82
end

return useCheckoutPageViewModel
