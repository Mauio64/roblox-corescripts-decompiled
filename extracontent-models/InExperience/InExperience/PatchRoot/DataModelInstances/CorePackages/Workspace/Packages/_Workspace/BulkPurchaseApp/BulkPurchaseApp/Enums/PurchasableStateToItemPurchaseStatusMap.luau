local PurchasableStateEnum = require(script.Parent.PurchasableStateEnum)

return {
	[PurchasableStateEnum.Unknown] = Enum.MarketplaceItemPurchaseStatus.SystemError,
	[PurchasableStateEnum.AlreadyOwned] = Enum.MarketplaceItemPurchaseStatus.AlreadyOwned,
	[PurchasableStateEnum.QuantityLimitExceeded] = Enum.MarketplaceItemPurchaseStatus.QuantityLimitExceeded,
	[PurchasableStateEnum.NotForSale] = Enum.MarketplaceItemPurchaseStatus.NotForSale,
	[PurchasableStateEnum.SoldOut] = Enum.MarketplaceItemPurchaseStatus.NotForSale
}
