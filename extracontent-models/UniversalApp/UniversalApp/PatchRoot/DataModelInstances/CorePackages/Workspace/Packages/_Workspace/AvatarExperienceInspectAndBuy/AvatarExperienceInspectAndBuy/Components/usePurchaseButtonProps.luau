local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local useConvertedItemData = require(AvatarExperienceInspectAndBuy.Hooks.useConvertedItemData)
local useItemStatusLocalization = require(AvatarExperienceInspectAndBuy.Hooks.useItemStatusLocalization)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)

require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)

local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)

require(AvatarExperienceInspectAndBuy.Types)

local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local isCollectible = itemDetailsUtils.isCollectible
local calculatePurchaseStatusForItem = itemDetailsUtils.calculatePurchaseStatusForItem
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local formatNumber = require(AvatarExperienceInspectAndBuy.Utils.formatNumber)

local function usePurchaseButtonProps(t1: {[any]: any}) -- line: 40
	-- upvalues: useConvertedItemData (copy), getPriceStatus (copy), useItemStatusLocalization (copy), React (copy), Foundation (copy), PriceStatus (copy), isCollectible (copy), calculatePurchaseStatusForItem (copy), formatNumber (copy), getPriceInRobux (copy)
	local v16 = useConvertedItemData(t1.selectedItem)
	local v17 = getPriceStatus(v16)
	local v18 = useItemStatusLocalization(v16)
	local v19 = React.useMemo(function() -- line: 46
		-- upvalues: t1 (copy), Foundation (copy)
		return {
			showRobuxIcon = false,
			purchaseButtonText = t1.purchaseButtonText,
			onPurchase = t1.onBulkPurchase,
			isDisabled = t1.isDisabled,
			variant = Foundation.Enums.ButtonVariant.Emphasis
		}
	end, { t1 })
	local v20 = React.useMemo(function() -- line: 57
		-- upvalues: v17 (copy), PriceStatus (copy), v18 (copy), Foundation (copy), v16 (copy), isCollectible (copy), calculatePurchaseStatusForItem (copy), t1 (copy)
		local v21 = v17 == PriceStatus.Free or (v17 == PriceStatus.PurchaseFromRoblox or v17 == PriceStatus.PurchaseFromResale)

		return {
			purchaseButtonText = v18[v17],
			isDisabled = not v21,
			variant = if v21 then Foundation.Enums.ButtonVariant.Emphasis else Foundation.Enums.ButtonVariant.Standard,
			onPurchase = function() -- line: 70
				-- upvalues: v16 (copy), isCollectible (copy), calculatePurchaseStatusForItem (copy), v17 (copy), t1 (copy)
				if v16 then
					local v22 = isCollectible(v16)
					local v23 = calculatePurchaseStatusForItem(v16, v17)

					t1.onPromptPurchase(v16.id, v16.itemType, v23.collectibleItemId, v23.collectibleLowestAvailableResaleProductId, v23.collectibleLowestAvailableResaleItemInstanceId, v23.collectibleLowestResalePrice, v22)
				end
			end
		}
	end, {
		t1,
		v17,
		v16
	})

	if t1.selectedItem then
		return {
			purchaseButtonProps = v20,
			priceLabel = {
				leftLabel = t1.localizedStrings.total or "",
				priceInRobux = formatNumber(getPriceInRobux(v16, v17))
			},
			priceStatus = v17
		}
	end

	return {
		purchaseButtonProps = v19,
		priceLabel = {
			leftLabel = t1.localizedStrings.totalItems or "",
			priceInRobux = t1.formattedTotalPrice
		}
	}
end

return usePurchaseButtonProps
