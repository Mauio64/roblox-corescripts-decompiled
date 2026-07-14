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
local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase
local useSignalState = require(AvatarExperienceInspectAndBuyParent.SignalsReact).useSignalState
local useItemSelectionStore = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext).useItemSelectionStore

require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local function v14(p1) -- line: 46
	return {
		assets = p1.assets,
		bundles = p1.bundles
	}
end
local function v15(p2) -- line: 53
	return p2.collectibleResellableInstances
end

return function(t1: {[any]: any}?, p3) -- line: 57
	-- upvalues: useSelector (copy), v14 (copy), tutils (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v15 (copy), useItemSelectionStore (copy), useSignalState (copy), React (copy), bulkPurchaseUtils (copy), RobloxReplicatedStorage (copy), ItemTypeEnum (copy), buildBulkPurchaseAnalyticsPayload (copy), FIntBulkPurchaseRequestLimit (copy)
	local v20 = useSelector(v14, tutils.deepEqual)
	local v21 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSelector(v15, tutils.deepEqual)
	local v22 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useItemSelectionStore()
	local v23 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useSignalState(v22.getItemDataMap)
	local v24 = React.useMemo(function() -- line: 68
		-- upvalues: bulkPurchaseUtils (copy), t1 (copy), v20 (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v23 (copy)
		return bulkPurchaseUtils.getBulkPurchaseEligibleItems(t1, v20, if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v23)
	end, {
		t1,
		v20,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v23
	})

	return React.useCallback(function() -- line: 78
		-- upvalues: RobloxReplicatedStorage (copy), v24 (copy), ItemTypeEnum (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v23 (copy), buildBulkPurchaseAnalyticsPayload (copy), v20 (copy), v21 (copy), p3 (copy)
		coroutine.wrap(function() -- line: 79
			-- upvalues: RobloxReplicatedStorage (copy), v24 (copy), ItemTypeEnum (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v23 (copy), buildBulkPurchaseAnalyticsPayload (copy), v20 (copy), v21 (copy), p3 (copy)
			RobloxReplicatedStorage:WaitForChild("ServerSideBulkPurchaseEvent", 1e999):FireServer(v24.requestedItems)

			for _, v27 in v24.requestedItems do
				local v28 = if v27.itemType ~= Enum.AvatarItemType.Asset.Value then ItemTypeEnum.Bundle else ItemTypeEnum.Asset
				local str = tostring(v27.id)

				if FFlagAXEnableIaBTimedOptionsBulkPurchase then
					local v30 = v23 and v23[str]
					local v31 = buildBulkPurchaseAnalyticsPayload({
						itemId = str,
						itemType = v28,
						assetsMap = v20.assets,
						bundlesMap = v20.bundles,
						collectibleResellableInstances = v21,
						storedData = v30
					})

					if v31 then
						p3.reportPurchaseAttemptUnifiedEvent(v28, str, v31)
					end
				else
					p3.reportPurchaseAttempt(v28, str)
				end
			end
		end)()
	end, {
		v24,
		p3.reportPurchaseAttempt,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v23,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v20,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else v21,
		if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else p3.reportPurchaseAttemptUnifiedEvent
	}), React.useMemo(function() -- line: 122
		-- upvalues: v24 (copy), FIntBulkPurchaseRequestLimit (copy)
		local v25

		if v24.requestedItems then
			v25 = false

			if #v24.requestedItems <= FIntBulkPurchaseRequestLimit then
				return #v24.requestedItems > 0
			end
		else
			v25 = false
		end

		return v25
	end, { v24 }), v24.totalPrice or 0
end
