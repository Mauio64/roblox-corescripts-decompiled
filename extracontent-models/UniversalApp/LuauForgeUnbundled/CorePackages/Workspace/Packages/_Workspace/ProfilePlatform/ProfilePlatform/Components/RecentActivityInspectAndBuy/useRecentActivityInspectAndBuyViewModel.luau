local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local useInspectAvatarData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/useInspectAvatarData")

local useRecentActivityPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/useRecentActivityPurchase")

local function useRecentActivityInspectAndBuyViewModel(p2)
	local assetIds = p2.assetIds
	local v6 = useInspectAvatarData((React.useMemo(function()
		local result = {}

		for k, assetId in assetIds do
			table.insert(result, {
				assetId = assetId,
				itemType = Enums.ItemTypes.Asset
			})
		end

		return result
	end, { assetIds })))
	local displayItems = v6.displayItems

	local v7 = useRecentActivityPurchase({
		displayItems = displayItems,
		localUserId = v6.localUserId,
		onClose = p2.onClose
	})

	local v8 = React.useCallback(function(p3, p4, p5) end, {})

	return {
		displayItems = displayItems,
		selectedItems = v7.selectedItems,
		isLoading = v6.isLoading,
		purchaseSummary = v7.purchaseSummary,
		isPurchasing = v7.isPurchasing,
		isConfirmingPurchase = v7.isConfirmingPurchase,
		isShowingInsufficientRobux = v7.isShowingInsufficientRobux,
		robuxBalance = v7.robuxBalance,
		onToggleItem = v7.onToggleItem,
		onBuyAll = v7.onBuyAll,
		onConfirmPurchase = v7.onConfirmPurchase,
		onCancelPurchase = v7.onCancelPurchase,
		onDismissInsufficientRobux = v7.onDismissInsufficientRobux,
		onClose = p2.onClose,
		openItemDetails = v8
	}
end

return useRecentActivityInspectAndBuyViewModel
