local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Dash = require(ProfilePlatformParent.Dash)
local UserLib = require(ProfilePlatformParent.UserLib)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants2 = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useMarketplaceAnalyticsContext = require(ProfilePlatform.Hooks.useMarketplaceAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileCardWidth = require(ProfilePlatformParent.ProfilePlatformCommon).Hooks.useProfileCardWidth
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuyAnalytics
local useInspectAvatarData = require(script.Parent.useInspectAvatarData)
local InspectAvatarUtils = require(script.Parent.InspectAvatarUtils)
local InspectAvatarSheet = require(script.Parent.InspectAvatarSheet)

require(ProfilePlatform.Common.Types)

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable
local getPriceStatus = InspectAvatarUtils.getPriceStatus
local PriceStatusEnum = InspectAvatarUtils.PriceStatusEnum

local function InspectAvatarSheetContainer(t1: {[any]: any}) -- line: 47
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useMarketplaceAnalyticsContext (copy), RobloxAppHooks (copy), useProfileFormFactor (copy), Enums (copy), useSelector (copy), useProfileCardWidth (copy), useProfileJsonComponent (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Constants2 (copy), useInspectAvatarData (copy), React (copy), isItemPurchasable (copy), Dash (copy), InspectAvatarUtils (copy), getPriceStatus (copy), PriceStatusEnum (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), EventNames (copy), InspectAvatarSheet (copy)
	local v29 = useProfileWrapperContext()
	local v30 = useProfileAnalyticsContext()
	local v31 = useMarketplaceAnalyticsContext()
	local v32 = RobloxAppHooks.useLocalRobuxBalance()
	local v33 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local profileId = v29.profileId
	local v35 = useSelector(function(p1) -- line: 57
		return p1.TopBar.statusBarHeight
	end)
	local v36 = useProfileCardWidth()
	local v37 = if not v33 then math.floor(v36 * 0.75) else 400
	local v38 = useProfileJsonComponent(Enums.Components.UserProfileHeader)
	local v39 = v38.names and v38.names.username or ""
	local v40 = getRbxthumbWithTypeSizeAndOptions(profileId, Constants.RbxthumbTypes.Avatar, Constants2.AVATAR_THUMBNAIL_SIZE)
	local v41 = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}
	local v42 = useInspectAvatarData(v41)
	local displayItems = v42.displayItems
	local v44, v45 = React.useState({})
	local v46 = React.useRef({})

	React.useEffect(function() -- line: 85
		-- upvalues: displayItems (copy), isItemPurchasable (copy), v46 (copy), v45 (copy), Dash (copy)
		if #displayItems == 0 then
			return
		end

		local t2 = {}
		local v57 = false

		for _, v59 in displayItems do
			local id = v59.id

			if isItemPurchasable(v59) and not v46.current[id] then
				v46.current[id] = true
				t2[id] = true
				v57 = true
			end
		end

		if not v57 then
			return
		end

		v45(function(p2) -- line: 102
			-- upvalues: Dash (copy), t2 (copy)
			return Dash.join(p2, t2)
		end)
	end, { displayItems })

	local v47 = React.useCallback(function(s1: string) -- line: 107
		-- upvalues: v45 (copy), Dash (copy)
		v45(function(p3) -- line: 108
			-- upvalues: Dash (copy), s1 (copy)
			return Dash.join(p3, {
				[s1] = not p3[s1]
			})
		end)
	end, {})
	local v48 = React.useMemo(function() -- line: 114
		-- upvalues: displayItems (copy), v44 (copy), isItemPurchasable (copy), InspectAvatarUtils (copy), getPriceStatus (copy), PriceStatusEnum (copy), Enums (copy)
		local t3 = {}
		local n1 = 0
		local n2 = 0
		local t4 = {}
		local t5 = {}
		local t6 = {}
		local t7 = {}

		for _, v70 in displayItems do
			if v70.id then
				local id = v70.id

				if v44[id] and isItemPurchasable(v70) then
					local v72 = InspectAvatarUtils.getEffectivePrice(v70)

					table.insert(t3, {
						collectibleProductId = if getPriceStatus(v70) ~= PriceStatusEnum.PurchaseFromResale or not v70.collectibleItemDetails then v70.collectibleProductId else v70.collectibleItemDetails.collectibleLowestAvailableResaleProductId or v70.collectibleProductId,
						agreedPriceRobux = v72
					})
					n1 += v72
					n2 += 1
					table.insert(t5, id)

					if v70.itemType == Enums.ItemTypes.Bundle then
						table.insert(t6, id)
					end

					if #v70.bundleAssetIds > 0 then
						for _, v74 in v70.bundleAssetIds do
							if not t7[v74] then
								t7[v74] = true
								table.insert(t4, v74)
							end
						end
					else
						local num = tonumber(v70.id)

						if num and not t7[num] then
							t7[num] = true
							table.insert(t4, num)
						end
					end
				end
			end
		end

		return {
			lineItems = t3,
			totalPrice = n1,
			count = n2,
			purchasedWearIds = t4,
			purchasedItemIds = t5,
			purchasedBundleIds = t6
		}
	end, {
		displayItems,
		v44
	})
	local v49 = React.useMemo(function() -- line: 171
		-- upvalues: displayItems (copy)
		local t8 = {}

		for _, v78 in displayItems do
			local num = tonumber(v78.id)
			local num2 = tonumber(v78.itemSubType)

			if num and num2 then
				t8[num] = num2
			end

			if v78.assetsInBundle then
				for _, v82 in v78.assetsInBundle do
					local num3 = tonumber(v82.id)
					local num4 = tonumber(v82.assetType)

					if num3 and num4 then
						t8[num3] = num4
					end
				end
			end
		end

		return t8
	end, { displayItems })
	local v50 = React.useCallback(function() -- line: 193
		-- upvalues: v48 (copy), v42 (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), v30 (copy), EventNames (copy), v29 (copy), t1 (copy), Enums (copy), v49 (copy)
		if #v48.lineItems == 0 or not v42.localUserId then
			return
		end

		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v30.fireAnalyticsEvent(EventNames.InspectAvatarBuyClicked, {
				profileSessionId = v29.profileSessionId,
				itemIds = table.concat(v48.purchasedItemIds, ","),
				totalPrice = v48.totalPrice
			})
		end

		t1.navigation.navigate(Enums.Screens.PurchaseConfirmationModal, {
			totalPrice = v48.totalPrice,
			itemCount = v48.count,
			purchasableLineItems = v48.lineItems,
			userId = v42.localUserId,
			purchasedWearIds = v48.purchasedWearIds,
			ownedAssetIds = v42.ownedAssetIds,
			purchasedItemIds = v48.purchasedItemIds,
			purchasedBundleIds = v48.purchasedBundleIds,
			wearTypeMap = v49
		})
	end, {
		v48,
		v42.localUserId,
		v42.ownedAssetIds,
		t1.navigation,
		v49,
		if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else v30,
		if not FFlagSocialEnableProfileInspectAndBuyAnalytics then nil else v29.profileSessionId
	})
	local v51 = React.useCallback(function() -- line: 227
		-- upvalues: t1 (copy)
		t1.navigation.pop()
	end, { t1.navigation })
	local v52 = React.useCallback(function() -- line: 231
		-- upvalues: t1 (copy), v29 (copy)
		t1.navigation.pop()
		task.defer(function() -- line: 233
			-- upvalues: v29 (copy)
			v29.navigateTo.previousView(false)
		end)
	end, {
		t1.navigation,
		v29.navigateTo
	})
	local v53 = React.useCallback(function(s2: string, s3: string, n3: number?) -- line: 239
		-- upvalues: v29 (copy), v30 (copy), EventNames (copy), v31 (copy)
		v29.navigateTo.itemOrBundleDetails(s2, s3)
		v30.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
			btnContext = "InspectAvatar",
			btnUnitId = tostring(s2),
			btnSortPosition = tostring(n3)
		})
		v29.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v31, s2, s3, "InspectAvatar", n3)
	end, {
		v29.navigateTo.itemOrBundleDetails,
		v29.externalAnalytics.catalogAnalytics,
		v30,
		v31
	})
	local v54 = v32 ~= nil and v32 < v48.totalPrice

	return React.createElement(InspectAvatarSheet, {
		displayItems = displayItems,
		selectedItems = v44,
		isLoading = v42.isLoading,
		username = v39,
		profileId = profileId,
		avatarThumbnail = v40,
		avatarViewportHeight = v37,
		cardWidth = v36,
		topOffset = if not v33 then v35 else 0,
		purchaseSummary = {
			totalPrice = v48.totalPrice,
			count = v48.count
		},
		hasInsufficientFunds = v54,
		onToggleItem = v47,
		onBuyAll = v50,
		onClose = v51,
		onDismiss = v52,
		openItemDetails = v53
	})
end

return InspectAvatarSheetContainer
