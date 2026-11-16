local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Common.Types)
local useInspectAvatarData = require(ProfilePlatform.Components.InspectAvatar.useInspectAvatarData)

local useRecentActivityPurchase = require(script.Parent.useRecentActivityPurchase)

local function useRecentActivityInspectAndBuyViewModel(p)
	local assetIds = p.assetIds
	local v = useInspectAvatarData((React.useMemo(function()
		local result = {}

		for _, assetId in assetIds do
			table.insert(result, { assetId = assetId, itemType = Enums.ItemTypes.Asset })
		end

		return result
	end, { assetIds })))
	local displayItems = v.displayItems

	local v2 = useRecentActivityPurchase({
		displayItems = displayItems,
		localUserId = v.localUserId,
		onClose = p.onClose
	})

	local openItemDetails = React.useCallback(function(_: string, _: string, _: number?) end, {})

	return {
		displayItems = displayItems,
		selectedItems = v2.selectedItems,
		isLoading = v.isLoading,
		purchaseSummary = v2.purchaseSummary,
		isPurchasing = v2.isPurchasing,
		isConfirmingPurchase = v2.isConfirmingPurchase,
		isShowingInsufficientRobux = v2.isShowingInsufficientRobux,
		robuxBalance = v2.robuxBalance,
		onToggleItem = v2.onToggleItem,
		onBuyAll = v2.onBuyAll,
		onConfirmPurchase = v2.onConfirmPurchase,
		onCancelPurchase = v2.onCancelPurchase,
		onDismissInsufficientRobux = v2.onDismissInsufficientRobux,
		onClose = p.onClose,
		openItemDetails = openItemDetails
	}
end

return useRecentActivityInspectAndBuyViewModel
