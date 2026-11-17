local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local UserLib = require(parent.UserLib)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants2 = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local useAvatarBackgroundFromWrapper = require(ProfilePlatform.Hooks.useAvatarBackgroundFromWrapper)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useMarketplaceAnalyticsContext = require(ProfilePlatform.Hooks.useMarketplaceAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)

local ProfilePlatformCommon = require(parent.ProfilePlatformCommon)
local useProfileCardWidth = ProfilePlatformCommon.Hooks.useProfileCardWidth
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = SharedFlags.FFlagSocialEnableProfileInspectAndBuyAnalytics
local FFlagProfileInspectAvatarBackground = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarBackground)
local FFlagProfileUnifiedPurchaseLogging = require(ProfilePlatform.Flags.FFlagProfileUnifiedPurchaseLogging)

local useInspectAvatarData = require(script.Parent.useInspectAvatarData)
local InspectAvatarUtils = require(script.Parent.InspectAvatarUtils)
local InspectAvatarSheet = require(script.Parent.InspectAvatarSheet)
require(ProfilePlatform.Common.Types)
require(ProfilePlatform.Analytics.sendProfilePurchaseEvents)

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable
local getPriceStatus = InspectAvatarUtils.getPriceStatus
local PriceStatusEnum = InspectAvatarUtils.PriceStatusEnum

local function InspectAvatarSheetContainer(p)
	local v = useProfileWrapperContext()
	local v2 = useProfileAnalyticsContext()
	local v3 = useMarketplaceAnalyticsContext()
	local robuxBalance = RobloxAppHooks.useLocalRobuxBalance()
	local v4 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	local profileId = v.profileId

	local v5 = useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)

	local cardWidth = useProfileCardWidth()

	local avatarViewportHeight = v4 and 400 or math.floor(cardWidth * 0.75)

	local v6 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local username = v6.names and v6.names.username or ""

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		profileId,
		Constants.RbxthumbTypes.Avatar,
		Constants2.AVATAR_THUMBNAIL_SIZE
	)
	local avatarBackgroundImage

	if FFlagProfileInspectAvatarBackground then
		avatarBackgroundImage = useAvatarBackgroundFromWrapper()
	end

	local assets = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}

	local v7 = useInspectAvatarData(assets)
	local displayItems = v7.displayItems

	local state, setState = React.useState({})
	local ref = React.useRef({})

	React.useEffect(function()
		if #displayItems == 0 then
			return
		end

		local idSet = {}
		local v8 = false

		for _, displayItem in displayItems do
			local id = displayItem.id

			if not isItemPurchasable(displayItem) or ref.current[id] then
				continue
			end

			ref.current[id] = true
			idSet[id] = true
			v8 = true
		end

		if not v8 then
			return
		end

		setState(function(p2)
			return Dash.join(p2, idSet)
		end)
	end, { displayItems })

	local onToggleItem = React.useCallback(function(p2: string)
		setState(function(p3)
			return Dash.join(p3, {
				[p2] = not p3[p2]
			})
		end)
	end, {})

	local v8 = React.useMemo(function()
		local purchasedItems = FFlagProfileUnifiedPurchaseLogging and {} or nil
		local lineItems = {}
		local total = 0
		local count = 0
		local ids = {}
		local ids2 = {}

		local set = {}
		local purchasedWearIds = {}

		for _, displayItem in displayItems do
			if not displayItem.id then
				continue
			end

			local id = displayItem.id

			if not (state[id] and isItemPurchasable(displayItem)) then
				continue
			end

			local effectivePrice = InspectAvatarUtils.getEffectivePrice(displayItem)
			local collectibleProductId

			if
				getPriceStatus(displayItem) == PriceStatusEnum.PurchaseFromResale
				and displayItem.collectibleItemDetails
			then
				collectibleProductId = displayItem.collectibleItemDetails.collectibleLowestAvailableResaleProductId
					or displayItem.collectibleProductId
			else
				collectibleProductId = displayItem.collectibleProductId
			end

			table.insert(lineItems, {
				collectibleProductId = collectibleProductId,
				agreedPriceRobux = effectivePrice
			})

			total += effectivePrice
			count += 1
			table.insert(ids, id)

			if FFlagProfileUnifiedPurchaseLogging and purchasedItems then
				table.insert(purchasedItems, {
					itemId = id,
					itemType = displayItem.itemType,
					itemSubType = tonumber(displayItem.itemSubType),
					priceInRobux = effectivePrice
				})
			end

			if displayItem.itemType == Enums.ItemTypes.Bundle then
				table.insert(ids2, id)
			end

			if #displayItem.bundleAssetIds > 0 then
				for _, bundleAssetId in displayItem.bundleAssetIds do
					if set[bundleAssetId] then
						continue
					end

					set[bundleAssetId] = true
					table.insert(purchasedWearIds, bundleAssetId)
				end
			else
				local id2 = tonumber(displayItem.id)

				if id2 and not set[id2] then
					set[id2] = true
					table.insert(purchasedWearIds, id2)
				end
			end
		end

		return {
			lineItems = lineItems,
			totalPrice = total,
			count = count,
			purchasedWearIds = purchasedWearIds,
			purchasedItemIds = ids,
			purchasedBundleIds = ids2,
			purchasedItems = purchasedItems
		}
	end, { displayItems, state })

	local wearTypeMap = React.useMemo(function()
		local result = {}

		for _, displayItem in displayItems do
			local id = tonumber(displayItem.id)
			local itemSubType = tonumber(displayItem.itemSubType)

			if id and itemSubType then
				result[id] = itemSubType
			end

			if not displayItem.assetsInBundle then
				continue
			end

			for _, v9 in displayItem.assetsInBundle do
				local id2 = tonumber(v9.id)
				local assetType = tonumber(v9.assetType)

				if id2 and assetType then
					result[id2] = assetType
				end
			end
		end

		return result
	end, { displayItems })

	local useCallback = React.useCallback
	local function fn()
		if #v8.lineItems == 0 or not v7.localUserId then
			return
		end

		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v2.fireAnalyticsEvent(EventNames.InspectAvatarBuyClicked, {
				profileSessionId = v.profileSessionId,
				itemIds = table.concat(v8.purchasedItemIds, ","),
				totalPrice = v8.totalPrice
			})
		end

		if robuxBalance ~= nil and robuxBalance < v8.totalPrice then
			p.navigation.navigate(Enums.Screens.InsufficientRobuxDialog, {
				totalPrice = v8.totalPrice,
				robuxBalance = robuxBalance
			})

			return
		end

		local navigate = p.navigation.navigate
		local purchaseConfirmationModal = Enums.Screens.PurchaseConfirmationModal
		local v9 = {
			totalPrice = v8.totalPrice,
			itemCount = v8.count,
			purchasableLineItems = v8.lineItems,
			userId = v7.localUserId,
			purchasedWearIds = v8.purchasedWearIds,
			ownedAssetIds = v7.ownedAssetIds,
			purchasedItemIds = v8.purchasedItemIds,
			purchasedBundleIds = v8.purchasedBundleIds,
			purchasedItems = 0,
			wearTypeMap = 0,
			robuxBalance = 0
		}
		local purchasedItems

		if FFlagProfileUnifiedPurchaseLogging then
			purchasedItems = v8.purchasedItems
		end

		v9.purchasedItems = purchasedItems

		v9.wearTypeMap = wearTypeMap
		v9.robuxBalance = robuxBalance
		navigate(purchaseConfirmationModal, v9)
	end

	local localUserId = v7.localUserId
	local ownedAssetIds = v7.ownedAssetIds
	local navigation = p.navigation
	local v9

	if FFlagSocialEnableProfileInspectAndBuyAnalytics then
		v9 = v2
	end

	local v10

	if FFlagSocialEnableProfileInspectAndBuyAnalytics then
		v10 = v.profileSessionId
	end

	local onBuyAll = useCallback(fn, {
		v8,
		localUserId,
		ownedAssetIds,
		navigation,
		wearTypeMap,
		robuxBalance,
		v9,
		v10
	})

	local onClose = React.useCallback(function()
		p.navigation.pop()
	end, { p.navigation })

	local onDismiss = React.useCallback(function()
		p.navigation.pop()
		task.defer(function()
			v.navigateTo.previousView(false)
		end)
	end, { p.navigation, v.navigateTo })

	local openItemDetails = React.useCallback(function(p2: string, p3: string, p4: number?)
		v.navigateTo.itemOrBundleDetails(p2, p3)
		v2.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
			btnContext = "InspectAvatar",
			btnUnitId = tostring(p2),
			btnSortPosition = tostring(p4)
		})

		v.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v3, p2, p3, "InspectAvatar", p4)
	end, { v.navigateTo.itemOrBundleDetails, v.externalAnalytics.catalogAnalytics, v2, v3 })

	local createElement = React.createElement
	local v11 = {
		displayItems = displayItems,
		selectedItems = state,
		isLoading = v7.isLoading,
		username = username,
		profileId = profileId,
		avatarThumbnail = rbxthumbWithTypeSizeAndOptions,
		avatarBackgroundImage = 0,
		avatarViewportHeight = 0,
		cardWidth = 0,
		topOffset = 0,
		purchaseSummary = 0,
		onToggleItem = 0,
		onBuyAll = 0,
		onClose = 0,
		onDismiss = 0,
		openItemDetails = 0
	}

	if not FFlagProfileInspectAvatarBackground then
		avatarBackgroundImage = nil
	end

	v11.avatarBackgroundImage = avatarBackgroundImage
	v11.avatarViewportHeight = avatarViewportHeight
	v11.cardWidth = cardWidth
	v11.topOffset = v4 and 0 or v5
	v11.purchaseSummary = { totalPrice = v8.totalPrice, count = v8.count }

	v11.onToggleItem = onToggleItem
	v11.onBuyAll = onBuyAll
	v11.onClose = onClose
	v11.onDismiss = onDismiss
	v11.openItemDetails = openItemDetails
	return createElement(InspectAvatarSheet, v11)
end

return InspectAvatarSheetContainer
