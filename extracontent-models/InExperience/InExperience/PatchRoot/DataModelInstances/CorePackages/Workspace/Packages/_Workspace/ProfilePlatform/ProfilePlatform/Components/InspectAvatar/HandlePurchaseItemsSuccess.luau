local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local CatalogNetworking = require(parent.CatalogNetworking)
local PurchaseDetailsStore = CatalogNetworking.PurchaseDetailsStore
local BundleOwnershipStore = CatalogNetworking.BundleOwnershipStore

require(ProfilePlatform.Contexts.ProfileWrapperContext)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local MarketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction

local Enums = require(ProfilePlatform.Common.Enums)
local sendProfilePurchaseEvents = require(ProfilePlatform.Analytics.sendProfilePurchaseEvents)

local FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase)
local FFlagProfileUnifiedPurchaseLogging = require(ProfilePlatform.Flags.FFlagProfileUnifiedPurchaseLogging)

local function buildEquippableAssets(purchasedWearIds, ownedAssetIds, wearTypeMap)
	local equippableAssets = {}
	local set = {}

	local function append(items)
		for _, item in items do
			if set[item] then
				continue
			end

			local v = wearTypeMap[item]

			if not v then
				continue
			end

			set[item] = true
			table.insert(equippableAssets, { assetTypeId = tostring(v), assetId = tostring(item) })
		end
	end

	append(purchasedWearIds)
	append(ownedAssetIds)

	return equippableAssets
end

local function parseLineItems(lineItems)
	local count = 0
	local bundleIds = {}
	local result = {}

	for _, item in lineItems do
		if item.status == "SUCCEEDED" then
			if item.bundleId then
				table.insert(bundleIds, (tostring(item.bundleId)))
				table.insert(result, (tostring(item.bundleId)))
			elseif item.assetId then
				table.insert(result, (tostring(item.assetId)))
			end
		else
			count += 1
		end
	end

	return result, bundleIds, count
end

local function buildPurchasedItems(lineItems, purchasedItems)
	local itemSubTypesByItemId = {}

	if purchasedItems then
		for _, item in purchasedItems do
			if item.itemSubType then
				itemSubTypesByItemId[item.itemId] = item.itemSubType
			end
		end
	end

	local purchasedItems2 = {}

	for _, item in lineItems do
		if item.status ~= "SUCCEEDED" then
			continue
		end

		local itemId

		if item.bundleId then
			itemId = tostring(item.bundleId)
		elseif item.assetId then
			itemId = tostring(item.assetId)
		end

		if not itemId then
			continue
		end

		local itemType

		if item.bundleId then
			itemType = Enums.ItemTypes.Bundle
		else
			itemType = Enums.ItemTypes.Asset
		end

		local v = {
			itemId = itemId,
			itemType = itemType,
			itemSubType = itemSubTypesByItemId[itemId],
			priceInRobux = item.agreedPriceRobux
		}
		table.insert(purchasedItems2, v)
	end

	return purchasedItems2
end

local function HandlePurchaseItemsSuccess(data)
	local responseBody = data.result and data.result.responseBody
	local fulfillmentGroups = responseBody and responseBody.fulfillmentGroups

	local lineItems = fulfillmentGroups and fulfillmentGroups[1] and fulfillmentGroups[1].lineItems or {}

	local v, v2, v3 = parseLineItems(lineItems)

	if FFlagProfileUnifiedPurchaseLogging then
		sendProfilePurchaseEvents(
			MarketplaceUnifiedAction.PURCHASE_SUCCESS,
			buildPurchasedItems(lineItems, data.purchasedItems),
			data.profileWrapperContext.profileType
		)
	end

	PurchaseDetailsStore.markItemsOwned(v)

	if #v2 > 0 then
		BundleOwnershipStore.markOwned(v2)
	end

	if data.isWearAfterPurchaseChecked and data.profileWrapperContext.postPurchase then
		local equippableAssets = buildEquippableAssets(
			data.purchasedWearIds or {},
			data.ownedAssetIds or {},
			data.wearTypeMap or {}
		)

		if #equippableAssets > 0 then
			if data.avatarSaveContext and data.avatarSaveContext.autoSaveNextNewSaveData then
				data.avatarSaveContext.autoSaveNextNewSaveData()
			end

			data.profileWrapperContext.postPurchase.wearAfterPurchase(equippableAssets)
		end
	end

	if FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase and #v > 0 then
		local postPurchase = data.profileWrapperContext.postPurchase

		if postPurchase and postPurchase.refreshRobuxBalance then
			postPurchase.refreshRobuxBalance()
		end
	end

	local v4

	if v3 == 0 then
		v4 = { toastMessage = 0, isLocalized = true, toastType = "PurchaseMessage" }
		local toastMessage

		if #v == 1 then
			toastMessage = data.localized.purchaseSuccessSingular
		else
			toastMessage = data.localized.purchaseSuccessPlural
		end

		v4.toastMessage = toastMessage
	else
		v4 = {
			toastMessage = data.localized.purchasePartialFailure,
			isLocalized = true,
			toastType = "PurchaseMessage"
		}
	end

	data.dispatch(SetCurrentToastMessage(v4))
end

return HandlePurchaseItemsSuccess
