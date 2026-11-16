local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage

local CatalogNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CatalogNetworking")
local purchaseDetailsStore = CatalogNetworking.PurchaseDetailsStore
local bundleOwnershipStore = CatalogNetworking.BundleOwnershipStore

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileWrapperContext")

local marketplaceUnifiedAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceAnalytics").UnifiedEventLogEnums.MarketplaceUnifiedAction

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local sendProfilePurchaseEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/sendProfilePurchaseEvents")

local FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase")
local FFlagProfileUnifiedPurchaseLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileUnifiedPurchaseLogging")

local function buildEquippableAssets(purchasedWearIds, ownedAssetIds, wearTypeMap)
	local equippableAssets = {}
	local set = {}

	local function append(items)
		for k, item in items do
			if set[item] then
				continue
			end

			local v5 = wearTypeMap[item]

			if not v5 then
				continue
			end

			set[item] = true
			table.insert(equippableAssets, {
				assetTypeId = tostring(v5),
				assetId = tostring(item)
			})
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

	for k, item in lineItems do
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
		for k, item in purchasedItems do
			if item.itemSubType then
				itemSubTypesByItemId[item.itemId] = item.itemSubType
			end
		end
	end

	local purchasedItems2 = {}

	for k, item in lineItems do
		if item.status ~= "SUCCEEDED" then
			continue
		end

		local v5

		if item.bundleId then
			v5 = tostring(item.bundleId)
		elseif item.assetId then
			v5 = tostring(item.assetId)
		end

		if not v5 then
			continue
		end

		local v7 = if item.bundleId then Enums.ItemTypes.Bundle else Enums.ItemTypes.Asset
		local v6 = {
			itemId = v5,
			itemType = v7,
			itemSubType = itemSubTypesByItemId[v5],
			priceInRobux = item.agreedPriceRobux
		}
		table.insert(purchasedItems2, v6)
	end

	return purchasedItems2
end

local function HandlePurchaseItemsSuccess(data)
	local responseBody = data.result and data.result.responseBody
	local fulfillmentGroups = responseBody and responseBody.fulfillmentGroups

	local lineItems = fulfillmentGroups and fulfillmentGroups[1] and fulfillmentGroups[1].lineItems or {}

	local v5, v6, v7 = parseLineItems(lineItems)

	if FFlagProfileUnifiedPurchaseLogging then
		sendProfilePurchaseEvents(
			marketplaceUnifiedAction.PURCHASE_SUCCESS,
			buildPurchasedItems(lineItems, data.purchasedItems),
			data.profileWrapperContext.profileType
		)
	end

	purchaseDetailsStore.markItemsOwned(v5)

	if #v6 > 0 then
		bundleOwnershipStore.markOwned(v6)
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

	if FFlagProfileInspectAndBuyRefreshBalanceAfterPurchase and #v5 > 0 then
		local postPurchase = data.profileWrapperContext.postPurchase

		if postPurchase and postPurchase.refreshRobuxBalance then
			postPurchase.refreshRobuxBalance()
		end
	end

	local v8

	if v7 == 0 then
		v8 = { toastMessage = 0, isLocalized = true, toastType = "PurchaseMessage" }
		local v9 = if #v5 == 1 then data.localized.purchaseSuccessSingular else data.localized.purchaseSuccessPlural
		v8.toastMessage = v9
	else
		v8 = {
			toastMessage = data.localized.purchasePartialFailure,
			isLocalized = true,
			toastType = "PurchaseMessage"
		}
	end

	data.dispatch(setCurrentToastMessage(v8))
end

return HandlePurchaseItemsSuccess
