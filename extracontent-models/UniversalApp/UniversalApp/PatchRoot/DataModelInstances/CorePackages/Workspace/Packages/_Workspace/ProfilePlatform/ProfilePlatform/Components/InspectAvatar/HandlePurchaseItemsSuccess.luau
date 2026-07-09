local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local CatalogNetworking = require(ProfilePlatformParent.CatalogNetworking)
local PurchaseDetailsStore = CatalogNetworking.PurchaseDetailsStore
local BundleOwnershipStore = CatalogNetworking.BundleOwnershipStore

require(ProfilePlatform.Contexts.ProfileWrapperContext)

local function buildEquippableAssets(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 57
	local t4 = {}
	local t5 = {}

	local function append(t6: {[any]: any}) -- line: 65
		-- upvalues: t5 (copy), t3 (copy), t4 (copy)
		for _, v33 in t6 do
			if not t5[v33] then
				local v34 = t3[v33]

				if v34 then
					t5[v33] = true
					table.insert(t4, {
						assetTypeId = tostring(v34),
						assetId = tostring(v33)
					})
				end
			end
		end
	end

	append(t1)
	append(t2)

	return t4
end
local function parseLineItems(t7: {[any]: any}) -- line: 88
	local t8 = {}
	local t9 = {}
	local n1 = 0

	for _, v21 in t7 do
		if v21.status == "SUCCEEDED" then
			if v21.bundleId then
				table.insert(t9, (tostring(v21.bundleId)))
				table.insert(t8, (tostring(v21.bundleId)))
			elseif v21.assetId then
				table.insert(t8, (tostring(v21.assetId)))
			end
		else
			n1 += 1
		end
	end

	return t8, t9, n1
end
local function HandlePurchaseItemsSuccess(t10: {[any]: any}) -- line: 109
	-- upvalues: parseLineItems (copy), PurchaseDetailsStore (copy), BundleOwnershipStore (copy), buildEquippableAssets (copy), SetCurrentToastMessage (copy)
	local v23 = t10.result and t10.result.responseBody
	local v24 = v23 and v23.fulfillmentGroups
	local v25 = v24 and (not not v24[1] and v24[1].lineItems) or {}
	local v26, v27, v28 = parseLineItems(v25)

	PurchaseDetailsStore.markItemsOwned(v26)

	if #v27 > 0 then
		BundleOwnershipStore.markOwned(v27)
	end

	if t10.isWearAfterPurchaseChecked and t10.profileWrapperContext.postPurchase then
		local v29 = buildEquippableAssets(t10.purchasedWearIds, t10.ownedAssetIds, t10.wearTypeMap)

		if #v29 > 0 then
			if t10.avatarSaveContext and t10.avatarSaveContext.autoSaveNextNewSaveData then
				t10.avatarSaveContext.autoSaveNextNewSaveData()
			end

			t10.profileWrapperContext.postPurchase.wearAfterPurchase(v29)
		end
	end

	local v30 = if v28 ~= 0 then {
		isLocalized = true,
		toastType = "PurchaseMessage",
		toastMessage = t10.localized.purchasePartialFailure
	} else {
		isLocalized = true,
		toastType = "PurchaseMessage",
		toastMessage = if #v26 ~= 1 then t10.localized.purchaseSuccessPlural else t10.localized.purchaseSuccessSingular
	}

	t10.dispatch(SetCurrentToastMessage(v30))
end

return HandlePurchaseItemsSuccess
