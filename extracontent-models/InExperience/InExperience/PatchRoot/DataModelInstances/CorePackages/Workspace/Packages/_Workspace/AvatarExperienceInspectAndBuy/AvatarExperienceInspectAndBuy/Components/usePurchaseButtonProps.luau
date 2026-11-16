local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local useConvertedItemData = require(AvatarExperienceInspectAndBuy.Hooks.useConvertedItemData)
local useItemStatusLocalization = require(AvatarExperienceInspectAndBuy.Hooks.useItemStatusLocalization)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
local Foundation = require(parent.Foundation)
require(AvatarExperienceInspectAndBuy.Types)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local isCollectible = itemDetailsUtils.isCollectible
local calculatePurchaseStatusForItem = itemDetailsUtils.calculatePurchaseStatusForItem
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local formatNumber = require(AvatarExperienceInspectAndBuy.Utils.formatNumber)

local function usePurchaseButtonProps(data)
	local v = useConvertedItemData(data.selectedItem)
	local priceStatus = getPriceStatus(v)
	local v2 = useItemStatusLocalization(v)

	local purchaseButtonProps = React.useMemo(function()
		return {
			purchaseButtonText = data.purchaseButtonText,
			onPurchase = data.onBulkPurchase,
			isDisabled = data.isDisabled,
			showRobuxIcon = false,
			variant = Foundation.Enums.ButtonVariant.Emphasis
		}
	end, { data })

	local purchaseButtonProps2 = React.useMemo(function()
		local v3 = priceStatus == PriceStatus.Free
			or priceStatus == PriceStatus.PurchaseFromRoblox
			or priceStatus == PriceStatus.PurchaseFromResale

		local v4 = {
			purchaseButtonText = v2[priceStatus],
			isDisabled = not v3,
			variant = 0,
			onPurchase = 0
		}
		local variant

		if v3 then
			variant = Foundation.Enums.ButtonVariant.Emphasis
		else
			variant = Foundation.Enums.ButtonVariant.Standard
		end

		v4.variant = variant

		function v4.onPurchase()
			if v then
				local collectible = isCollectible(v)
				local v5 = calculatePurchaseStatusForItem(v, priceStatus)
				data.onPromptPurchase(
					v.id,
					v.itemType,
					v5.collectibleItemId,
					v5.collectibleLowestAvailableResaleProductId,
					v5.collectibleLowestAvailableResaleItemInstanceId,
					v5.collectibleLowestResalePrice,
					collectible
				)
			end
		end

		return v4
	end, { data, priceStatus, v })

	if data.selectedItem then
		return {
			purchaseButtonProps = purchaseButtonProps2,
			priceLabel = {
				leftLabel = data.localizedStrings.total or "",
				priceInRobux = formatNumber(getPriceInRobux(v, priceStatus))
			},
			priceStatus = priceStatus
		}
	end

	return {
		purchaseButtonProps = purchaseButtonProps,
		priceLabel = {
			leftLabel = data.localizedStrings.totalItems or "",
			priceInRobux = data.formattedTotalPrice
		}
	}
end

return usePurchaseButtonProps
