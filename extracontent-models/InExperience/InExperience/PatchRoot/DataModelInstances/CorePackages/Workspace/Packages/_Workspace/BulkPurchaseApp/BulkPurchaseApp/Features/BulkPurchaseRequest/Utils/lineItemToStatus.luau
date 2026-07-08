local t1 = {
	INSUFFICIENT_ROBUX = Enum.MarketplaceItemPurchaseStatus.InsufficientRobux,
	QUOTA_EXCEEDED = Enum.MarketplaceItemPurchaseStatus.QuotaExceeded,
	NOT_FOR_SALE = Enum.MarketplaceItemPurchaseStatus.NotForSale,
	NOT_AVAILABLE_FOR_PURCHASER = Enum.MarketplaceItemPurchaseStatus.NotAvailableForPurchaser,
	PRICE_MISMATCH = Enum.MarketplaceItemPurchaseStatus.PriceMismatch,
	SOLD_OUT = Enum.MarketplaceItemPurchaseStatus.SoldOut,
	PURCHASER_IS_SELLER = Enum.MarketplaceItemPurchaseStatus.PurchaserIsSeller,
	QUANTITY_LIMIT_EXCEEDED = Enum.MarketplaceItemPurchaseStatus.QuantityLimitExceeded,
	ALREADY_OWNED = Enum.MarketplaceItemPurchaseStatus.AlreadyOwned,
	INSUFFICIENT_MEMBERSHIP = Enum.MarketplaceItemPurchaseStatus.InsufficientMembership,
	PURCHASE_PLACE_INVALID = Enum.MarketplaceItemPurchaseStatus.PlaceInvalid
}

local function lineItemToStatus(t2: {[any]: any}) -- line: 20
	-- upvalues: t1 (copy)
	local v4 = t1[t2.errorReason]

	if t2.status == "SUCCEEDED" then
		return Enum.MarketplaceItemPurchaseStatus.Success
	end

	if v4 then
		return v4
	end

	return Enum.MarketplaceItemPurchaseStatus.SystemError
end

return lineItemToStatus
