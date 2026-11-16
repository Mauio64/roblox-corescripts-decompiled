local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)

local function setOpenedFromBuyRobux(flag: boolean)
	getInExperienceShopStore(false).setOpenedFromBuyRobux(flag)
end

return setOpenedFromBuyRobux
