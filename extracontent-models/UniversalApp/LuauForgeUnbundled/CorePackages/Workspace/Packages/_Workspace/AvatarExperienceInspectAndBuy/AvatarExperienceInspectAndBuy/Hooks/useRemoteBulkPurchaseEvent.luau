local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local fIntBulkPurchaseRequestLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SharedFlags").FIntBulkPurchaseRequestLimit
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils").Hooks.RoactRodux.useSelector
local bulkPurchaseUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/bulkPurchaseUtils")
local buildBulkPurchaseAnalyticsPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/buildBulkPurchaseAnalyticsPayload")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel").Enums.ItemTypeEnum
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SignalsReact").useSignalState
local useItemSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Contexts/ItemSelectionStoreContext").useItemSelectionStore
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Stores/createItemSelectionStore")

local function fn(p2)
	return { assets = p2.assets, bundles = p2.bundles }
end

local function fn2(p2)
	return p2.collectibleResellableInstances
end

return function(p2, p3)
	local v5 = useSelector(fn, tutils.deepEqual)
	local v6 = useSelector(fn2, tutils.deepEqual)

	local v8 = useSignalState(useItemSelectionStore().getItemDataMap)

	local v9 = React.useMemo(function()
		return bulkPurchaseUtils.getBulkPurchaseEligibleItems(p2, v5, v8)
	end, { p2, v5, v8 })

	return React.useCallback(function()
		coroutine.wrap(function()
			RobloxReplicatedStorage:WaitForChild("ServerSideBulkPurchaseEvent", 1e999):FireServer(v9.requestedItems)

			for k, requestedItem in v9.requestedItems do
				local v10

				if requestedItem.itemType == Enum.AvatarItemType.Asset.Value then
					v10 = itemTypeEnum.Asset
				else
					v10 = itemTypeEnum.Bundle
				end

				local id = tostring(requestedItem.id)

				local v11 = v8 and v8[id]
				local v12 = buildBulkPurchaseAnalyticsPayload({
					itemId = id,
					itemType = v10,
					assetsMap = v5.assets,
					bundlesMap = v5.bundles,
					collectibleResellableInstances = v6,
					storedData = v11
				})

				if v12 then
					p3.reportPurchaseAttemptUnifiedEvent(v10, id, v12)
				end
			end
		end)()
	end, { v9, v8, v5, v6, p3.reportPurchaseAttemptUnifiedEvent }), React.useMemo(function(): boolean
		if v9.requestedItems and #v9.requestedItems <= fIntBulkPurchaseRequestLimit then
			return #v9.requestedItems > 0
		end

		return false
	end, { v9 }), v9.totalPrice or 0
end
