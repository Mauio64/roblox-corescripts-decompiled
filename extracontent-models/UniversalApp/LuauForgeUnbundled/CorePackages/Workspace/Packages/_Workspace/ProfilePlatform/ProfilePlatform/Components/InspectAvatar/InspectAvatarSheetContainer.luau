local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")

local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useAvatarBackgroundFromWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAvatarBackgroundFromWrapper")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useMarketplaceAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useMarketplaceAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")

local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatformCommon").Hooks.useProfileCardWidth
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")

local fFlagSocialEnableProfileInspectAndBuyAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuyAnalytics
local FFlagProfileInspectAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAvatarBackground")
local FFlagProfileUnifiedPurchaseLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileUnifiedPurchaseLogging")

local useInspectAvatarData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/useInspectAvatarData")
local InspectAvatarUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarUtils")
local InspectAvatarSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarSheet")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/sendProfilePurchaseEvents")

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable
local getPriceStatus = InspectAvatarUtils.getPriceStatus
local priceStatusEnum = InspectAvatarUtils.PriceStatusEnum

local function InspectAvatarSheetContainer(p2)
	local v5 = useProfileWrapperContext()
	local v6 = useProfileAnalyticsContext()
	local v7 = useMarketplaceAnalyticsContext()
	local v8 = RobloxAppHooks.useLocalRobuxBalance()
	local v9 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	local profileId = v5.profileId

	local v10 = useSelector(function(p3)
		return p3.TopBar.statusBarHeight
	end)

	local v12 = useProfileCardWidth()

	local v13 = v9 and 400 or math.floor(v12 * 0.75)

	local v14 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local username = v14.names and v14.names.username or ""

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		profileId,
		constants.RbxthumbTypes.Avatar,
		Constants.AVATAR_THUMBNAIL_SIZE
	)

	local v15 = if FFlagProfileInspectAvatarBackground then useAvatarBackgroundFromWrapper() else nil

	local assets = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}

	local v16 = useInspectAvatarData(assets)
	local displayItems = v16.displayItems

	local state, setState = React.useState({})
	local ref = React.useRef({})

	React.useEffect(function()
		if #displayItems == 0 then
			return
		end

		local idSet = {}
		local v17 = false

		for k, displayItem in displayItems do
			local id = displayItem.id

			if not isItemPurchasable(displayItem) or ref.current[id] then
				continue
			end

			ref.current[id] = true
			idSet[id] = true
			v17 = true
		end

		if not v17 then
			return
		end

		setState(function(p3)
			return Dash.join(p3, idSet)
		end)
	end, { displayItems })

	local v17 = React.useCallback(function(p3)
		setState(function(p4)
			return Dash.join(p4, {
				[p3] = not p4[p3]
			})
		end)
	end, {})

	local v18 = React.useMemo(function()
		local v19 = FFlagProfileUnifiedPurchaseLogging and {} or nil
		local v20 = {}
		local total = 0
		local count = 0
		local ids = {}
		local ids2 = {}

		local set = {}
		local v21 = {}

		for k, displayItem in displayItems do
			if not displayItem.id then
				continue
			end

			local id = displayItem.id

			if not (state[id] and isItemPurchasable(displayItem)) then
				continue
			end

			local effectivePrice = InspectAvatarUtils.getEffectivePrice(displayItem)
			local v22 = if getPriceStatus(displayItem) == priceStatusEnum.PurchaseFromResale and displayItem.collectibleItemDetails then displayItem.collectibleItemDetails.collectibleLowestAvailableResaleProductId or displayItem.collectibleProductId else displayItem.collectibleProductId
			table.insert(v20, {
				collectibleProductId = v22,
				agreedPriceRobux = effectivePrice
			})

			total += effectivePrice
			count += 1
			table.insert(ids, id)

			if FFlagProfileUnifiedPurchaseLogging and v19 then
				table.insert(v19, {
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
				for k2, bundleAssetId in displayItem.bundleAssetIds do
					if set[bundleAssetId] then
						continue
					end

					set[bundleAssetId] = true
					table.insert(v21, bundleAssetId)
				end
			else
				local id2 = tonumber(displayItem.id)

				if id2 and not set[id2] then
					set[id2] = true
					table.insert(v21, id2)
				end
			end
		end

		return {
			lineItems = v20,
			totalPrice = total,
			count = count,
			purchasedWearIds = v21,
			purchasedItemIds = ids,
			purchasedBundleIds = ids2,
			purchasedItems = v19
		}
	end, { displayItems, state })

	local v19 = React.useMemo(function()
		local result = {}

		for k, displayItem in displayItems do
			local id = tonumber(displayItem.id)
			local itemSubType = tonumber(displayItem.itemSubType)

			if id and itemSubType then
				result[id] = itemSubType
			end

			if not displayItem.assetsInBundle then
				continue
			end

			for k2, v20 in displayItem.assetsInBundle do
				local id2 = tonumber(v20.id)
				local assetType = tonumber(v20.assetType)

				if id2 and assetType then
					result[id2] = assetType
				end
			end
		end

		return result
	end, { displayItems })

	local useCallback = React.useCallback
	local function fn()
		if #v18.lineItems == 0 or not v16.localUserId then
			return
		end

		if fFlagSocialEnableProfileInspectAndBuyAnalytics then
			v6.fireAnalyticsEvent(EventNames.InspectAvatarBuyClicked, {
				profileSessionId = v5.profileSessionId,
				itemIds = table.concat(v18.purchasedItemIds, ","),
				totalPrice = v18.totalPrice
			})
		end

		if v8 ~= nil and v8 < v18.totalPrice then
			p2.navigation.navigate(Enums.Screens.InsufficientRobuxDialog, {
				totalPrice = v18.totalPrice,
				robuxBalance = v8
			})

			return
		end

		local navigate = p2.navigation.navigate
		local purchaseConfirmationModal = Enums.Screens.PurchaseConfirmationModal
		local v20 = {
			totalPrice = v18.totalPrice,
			itemCount = v18.count,
			purchasableLineItems = v18.lineItems,
			userId = v16.localUserId,
			purchasedWearIds = v18.purchasedWearIds,
			ownedAssetIds = v16.ownedAssetIds,
			purchasedItemIds = v18.purchasedItemIds,
			purchasedBundleIds = v18.purchasedBundleIds,
			purchasedItems = 0,
			wearTypeMap = 0,
			robuxBalance = 0
		}

		local v21 = if FFlagProfileUnifiedPurchaseLogging then v18.purchasedItems else nil
		v20.purchasedItems = v21

		v20.wearTypeMap = v19
		v20.robuxBalance = v8
		navigate(purchaseConfirmationModal, v20)
	end

	local localUserId = v16.localUserId
	local ownedAssetIds = v16.ownedAssetIds
	local navigation = p2.navigation
	local v21 = if fFlagSocialEnableProfileInspectAndBuyAnalytics then v6 else nil
	local v22 = if fFlagSocialEnableProfileInspectAndBuyAnalytics then v5.profileSessionId else nil
	local v23 = useCallback(fn, {
		v18,
		localUserId,
		ownedAssetIds,
		navigation,
		v19,
		v8,
		v21,
		v22
	})

	local v24 = React.useCallback(function()
		p2.navigation.pop()
	end, { p2.navigation })

	local v25 = React.useCallback(function()
		p2.navigation.pop()
		task.defer(function()
			v5.navigateTo.previousView(false)
		end)
	end, { p2.navigation, v5.navigateTo })

	local v26 = React.useCallback(function(p3, p4, p5)
		v5.navigateTo.itemOrBundleDetails(p3, p4)
		v6.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
			btnContext = "InspectAvatar",
			btnUnitId = tostring(p3),
			btnSortPosition = tostring(p5)
		})

		v5.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v7, p3, p4, "InspectAvatar", p5)
	end, {
		v5.navigateTo.itemOrBundleDetails,
		v5.externalAnalytics.catalogAnalytics,
		v6,
		v7
	})

	local createElement = React.createElement
	local v28 = {
		displayItems = displayItems,
		selectedItems = state,
		isLoading = v16.isLoading,
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
		v15 = nil
	end

	v28.avatarBackgroundImage = v15
	v28.avatarViewportHeight = v13
	v28.cardWidth = v12
	v28.topOffset = v9 and 0 or v10
	v28.purchaseSummary = { totalPrice = v18.totalPrice, count = v18.count }

	v28.onToggleItem = v17
	v28.onBuyAll = v23
	v28.onClose = v24
	v28.onDismiss = v25
	v28.openItemDetails = v26
	return createElement(InspectAvatarSheet, v28)
end

return InspectAvatarSheetContainer
