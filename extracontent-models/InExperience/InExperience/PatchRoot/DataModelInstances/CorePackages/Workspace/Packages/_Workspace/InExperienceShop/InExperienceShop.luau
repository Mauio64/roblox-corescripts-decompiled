local FFlagEnableExperienceShopGlobalIcon = require(script.Flags.FFlagEnableExperienceShopGlobalIcon)

local InExperienceShop = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	["jest.main.config"] = script["jest.main.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"],
	ShopContainer = require(script.Components.ShopContainerWrapper.ShopContainer)
}
local shopGlobalIcon

if FFlagEnableExperienceShopGlobalIcon then
	shopGlobalIcon = require(script.Components.ShopGlobalIcon)
end

InExperienceShop.ShopGlobalIcon = shopGlobalIcon
InExperienceShop.initiateShopItemPurchase = require(script.initiateShopItemPurchase)
local initShopGlobalIcon

if FFlagEnableExperienceShopGlobalIcon then
	initShopGlobalIcon = require(script.initShopGlobalIcon)
end

InExperienceShop.initShopGlobalIcon = initShopGlobalIcon
local getShopGlobalIconStore

if FFlagEnableExperienceShopGlobalIcon then
	getShopGlobalIconStore = require(script.Stores.GetShopGlobalIconStore)
end

InExperienceShop.GetShopGlobalIconStore = getShopGlobalIconStore

InExperienceShop.requestOpenToRobuxTab = require(script.Utils.requestOpenToRobuxTab)
InExperienceShop.setOpenedFromBuyRobux = require(script.Utils.setOpenedFromBuyRobux)

InExperienceShop.FFlagEnableExperienceShopGlobalIcon = FFlagEnableExperienceShopGlobalIcon
InExperienceShop.FFlagEnableShopPrefetch = require(script.Flags.FFlagEnableShopPrefetch)
InExperienceShop.FFlagHideShopMenuOnFailure = require(script.Flags.FFlagHideShopMenuOnFailure)
InExperienceShop.FFlagCenterInExperienceShopWindow = require(script.Flags.FFlagCenterInExperienceShopWindow)
InExperienceShop.FFlagFixInExperienceShopCursorLock = require(script.Flags.FFlagFixInExperienceShopCursorLock)
InExperienceShop.FFlagExperienceShopNewIconography = require(script.Flags.FFlagExperienceShopNewIconography)
InExperienceShop.FFlagEnableFreeTrialShopMenuBadge = require(script.Flags.FFlagEnableFreeTrialShopMenuBadge)
InExperienceShop.FFlagMenuBadgePreferFreeTrialOverOffer = require(script.Flags.FFlagMenuBadgePreferFreeTrialOverOffer)
InExperienceShop.FFlagEnableFreeTrialBlueDot = require(script.Flags.FFlagEnableFreeTrialBlueDot)
return InExperienceShop
