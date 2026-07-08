local FFlagEnableExperienceShopGlobalIcon = require(script.Flags.FFlagEnableExperienceShopGlobalIcon)

return {
	["jest.config"] = script["jest.config"],
	["jest.main.config"] = script["jest.main.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"],
	ShopContainer = require(script.Components.ShopContainerWrapper.ShopContainer),
	ShopGlobalIcon = if not FFlagEnableExperienceShopGlobalIcon then nil else require(script.Components.ShopGlobalIcon),
	initiateShopItemPurchase = require(script.initiateShopItemPurchase),
	initShopGlobalIcon = if not FFlagEnableExperienceShopGlobalIcon then nil else require(script.initShopGlobalIcon),
	GetShopGlobalIconStore = if not FFlagEnableExperienceShopGlobalIcon then nil else require(script.Stores.GetShopGlobalIconStore),
	FFlagEnableExperienceShopGlobalIcon = FFlagEnableExperienceShopGlobalIcon,
	FFlagEnableShopPrefetch = require(script.Flags.FFlagEnableShopPrefetch),
	FFlagHideShopMenuOnFailure = require(script.Flags.FFlagHideShopMenuOnFailure),
	FFlagCenterInExperienceShopWindow = require(script.Flags.FFlagCenterInExperienceShopWindow),
	FFlagExperienceShopNewIconography = require(script.Flags.FFlagExperienceShopNewIconography)
}
