local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)

require(AvatarExperienceInspectAndBuy.Types)

local FIntBulkPurchaseRequestLimit = require(AvatarExperienceInspectAndBuyParent.SharedFlags).FIntBulkPurchaseRequestLimit
local useSelector = require(AvatarExperienceInspectAndBuyParent.RoactUtils).Hooks.RoactRodux.useSelector
local bulkPurchaseUtils = require(AvatarExperienceInspectAndBuy.Utils.bulkPurchaseUtils)
local buildBulkPurchaseAnalyticsPayload = require(AvatarExperienceInspectAndBuy.Utils.buildBulkPurchaseAnalyticsPayload)
local tutils = require(AvatarExperienceInspectAndBuyParent.tutils)
local ItemTypeEnum = require(AvatarExperienceInspectAndBuyParent.AXCommon).Enums.ItemTypeEnum
local AvatarExperienceFlags = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags)
local FFlagAXFixBulkPurchaseFreeItems = AvatarExperienceFlags.FFlagAXFixBulkPurchaseFreeItems
local FFlagAXEnableIaBTimedOptionsBulkPurchase = AvatarExperienceFlags.FFlagAXEnableIaBTimedOptionsBulkPurchase
local useSignalState = require(AvatarExperienceInspectAndBuyParent.SignalsReact).useSignalState
local useItemSelectionStore = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext).useItemSelectionStore

require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local function v16(p1) -- line: 47
	return {
		assets = p1.assets,
		bundles = p1.bundles
	}
end
local function v17(p2) -- line: 54
	return p2.collectibleResellableInstances
end

return function(t1: {[any]: any}?, p3) -- line: 58
	-- upvalues: useSelector (copy), v16 (copy), tutils (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v17 (copy), useItemSelectionStore (copy), useSignalState (copy), React (copy), bulkPurchaseUtils (copy), RobloxReplicatedStorage (copy), ItemTypeEnum (copy), buildBulkPurchaseAnalyticsPayload (copy), FFlagAXFixBulkPurchaseFreeItems (copy), FIntBulkPurchaseRequestLimit (copy)
	local v22 = useSelector(v16, tutils.deepEqual)
	local v23 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSelector(v17, tutils.deepEqual)
	local v24 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useItemSelectionStore()
	local v25 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSignalState(v24.getItemDataMap)
	local v26 = React.useMemo(function() -- line: 69
		-- upvalues: bulkPurchaseUtils (copy), t1 (copy), v22 (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v25 (copy)
		return bulkPurchaseUtils.getBulkPurchaseEligibleItems(t1, v22, if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v25)
	end, {
		t1,
		v22,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v25
	})

	return React.useCallback(function() -- line: 79
		-- upvalues: RobloxReplicatedStorage (copy), v26 (copy), ItemTypeEnum (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v25 (copy), buildBulkPurchaseAnalyticsPayload (copy), v22 (copy), v23 (copy), p3 (copy)
		coroutine.wrap(function() -- line: 80
			-- upvalues: RobloxReplicatedStorage (copy), v26 (copy), ItemTypeEnum (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v25 (copy), buildBulkPurchaseAnalyticsPayload (copy), v22 (copy), v23 (copy), p3 (copy)
			RobloxReplicatedStorage:WaitForChild("ServerSideBulkPurchaseEvent", 1e999):FireServer(v26.requestedItems)

			for _, v28 in v26.requestedItems do
				local v29 = if v28.itemType ~= Enum.AvatarItemType.Asset.Value then ItemTypeEnum.Bundle else ItemTypeEnum.Asset
				local str = tostring(v28.id)

				if FFlagAXEnableIaBTimedOptionsBulkPurchase then
					local v31 = v25 and v25[str]
					local v32 = buildBulkPurchaseAnalyticsPayload({
						itemId = str,
						itemType = v29,
						assetsMap = v22.assets,
						bundlesMap = v22.bundles,
						collectibleResellableInstances = v23,
						storedData = v31
					})

					if v32 then
						p3.reportPurchaseAttemptUnifiedEvent(v29, str, v32)
					end
				else
					p3.reportPurchaseAttempt(v29, str)
				end
			end
		end)()
	end, {
		v26,
		p3.reportPurchaseAttempt,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v25,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v22,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v23,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else p3.reportPurchaseAttemptUnifiedEvent
	}), React.useMemo(function() -- line: 123
		-- upvalues: FFlagAXFixBulkPurchaseFreeItems (copy), v26 (copy), FIntBulkPurchaseRequestLimit (copy)
		if FFlagAXFixBulkPurchaseFreeItems then
			if v26.requestedItems then
				return #v26.requestedItems <= FIntBulkPurchaseRequestLimit and #v26.requestedItems > 0
			end

			return false
		end

		if v26.requestedItems then
			return #v26.requestedItems <= FIntBulkPurchaseRequestLimit
		end

		return false
	end, { v26 }), v26.totalPrice or 0
end
