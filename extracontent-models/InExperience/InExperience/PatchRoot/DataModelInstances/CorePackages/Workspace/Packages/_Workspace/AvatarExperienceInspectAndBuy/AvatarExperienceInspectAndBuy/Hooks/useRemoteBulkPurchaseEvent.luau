local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
require(AvatarExperienceInspectAndBuy.Types)
local SharedFlags = require(parent.SharedFlags)
local FIntBulkPurchaseRequestLimit = SharedFlags.FIntBulkPurchaseRequestLimit
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local bulkPurchaseUtils = require(AvatarExperienceInspectAndBuy.Utils.bulkPurchaseUtils)
local buildBulkPurchaseAnalyticsPayload = require(AvatarExperienceInspectAndBuy.Utils.buildBulkPurchaseAnalyticsPayload)
local tutils = require(parent.tutils)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local ItemSelectionStoreContext = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext)
local useItemSelectionStore = ItemSelectionStoreContext.useItemSelectionStore
require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local function fn(p)
	return { assets = p.assets, bundles = p.bundles }
end

local function fn2(p)
	return p.collectibleResellableInstances
end

return function(p, p2)
	local v = useSelector(fn, tutils.deepEqual)
	local collectibleResellableInstances = useSelector(fn2, tutils.deepEqual)

	local v2 = useSignalState(useItemSelectionStore().getItemDataMap)

	local v3 = React.useMemo(function()
		return bulkPurchaseUtils.getBulkPurchaseEligibleItems(p, v, v2)
	end, { p, v, v2 })

	return React.useCallback(function()
		coroutine.wrap(function()
			RobloxReplicatedStorage:WaitForChild("ServerSideBulkPurchaseEvent", 1e999):FireServer(v3.requestedItems)

			for _, requestedItem in v3.requestedItems do
				local itemType

				if requestedItem.itemType == Enum.AvatarItemType.Asset.Value then
					itemType = ItemTypeEnum.Asset
				else
					itemType = ItemTypeEnum.Bundle
				end

				local id = tostring(requestedItem.id)

				local storedData = v2 and v2[id]
				local bulkPurchaseAnalyticsPayload = buildBulkPurchaseAnalyticsPayload({
					itemId = id,
					itemType = itemType,
					assetsMap = v.assets,
					bundlesMap = v.bundles,
					collectibleResellableInstances = collectibleResellableInstances,
					storedData = storedData
				})

				if bulkPurchaseAnalyticsPayload then
					p2.reportPurchaseAttemptUnifiedEvent(itemType, id, bulkPurchaseAnalyticsPayload)
				end
			end
		end)()
	end, { v3, v2, v, collectibleResellableInstances, p2.reportPurchaseAttemptUnifiedEvent }), React.useMemo(function(): boolean
		if v3.requestedItems and #v3.requestedItems <= FIntBulkPurchaseRequestLimit then
			return #v3.requestedItems > 0
		end

		return false
	end, { v3 }), v3.totalPrice or 0
end
