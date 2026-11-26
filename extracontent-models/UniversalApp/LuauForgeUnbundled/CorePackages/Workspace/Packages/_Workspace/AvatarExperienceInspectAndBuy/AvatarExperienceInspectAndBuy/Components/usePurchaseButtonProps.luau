local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local useConvertedItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useConvertedItemData")
local useItemStatusLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useItemStatusLocalization")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local itemDetailsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils")
local isCollectible = itemDetailsUtils.isCollectible
local calculatePurchaseStatusForItem = itemDetailsUtils.calculatePurchaseStatusForItem
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/formatNumber")

local function usePurchaseButtonProps(data)
	local v5 = useConvertedItemData(data.selectedItem)
	local v6 = getPriceStatus(v5)
	local v7 = useItemStatusLocalization(v5)

	local v8 = React.useMemo(function()
		return {
			purchaseButtonText = data.purchaseButtonText,
			onPurchase = data.onBulkPurchase,
			isDisabled = data.isDisabled,
			showRobuxIcon = false,
			variant = Foundation.Enums.ButtonVariant.Emphasis
		}
	end, { data })

	local v9 = React.useMemo(function()
		local v10 = v6 == PriceStatus.Free
			or v6 == PriceStatus.PurchaseFromRoblox
			or v6 == PriceStatus.PurchaseFromResale

		local v11 = {
			purchaseButtonText = v7[v6],
			isDisabled = not v10,
			variant = 0,
			onPurchase = 0
		}

		local v12 = if v10 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard
		v11.variant = v12

		function v11.onPurchase()
			if v5 then
				local collectible = isCollectible(v5)
				local v13 = calculatePurchaseStatusForItem(v5, v6)
				data.onPromptPurchase(
					v5.id,
					v5.itemType,
					v13.collectibleItemId,
					v13.collectibleLowestAvailableResaleProductId,
					v13.collectibleLowestAvailableResaleItemInstanceId,
					v13.collectibleLowestResalePrice,
					collectible
				)
			end
		end

		return v11
	end, { data, v6, v5 })

	if data.selectedItem then
		return {
			purchaseButtonProps = v9,
			priceLabel = {
				leftLabel = data.localizedStrings.total or "",
				priceInRobux = formatNumber(getPriceInRobux(v5, v6))
			},
			priceStatus = v6
		}
	end

	return {
		purchaseButtonProps = v8,
		priceLabel = {
			leftLabel = data.localizedStrings.totalItems or "",
			priceInRobux = data.formattedTotalPrice
		}
	}
end

return usePurchaseButtonProps
