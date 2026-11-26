local productPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite").Enums.ProductPurchaseSurface

local FFlagEnforceRobloxShopForAllSurfaces = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnforceRobloxShopForAllSurfaces")

local v5 = {
	productPurchaseSurface.InExperienceShopHome,
	productPurchaseSurface.InExperienceShopSearch,
	productPurchaseSurface.InExperienceShopDetails
}

local function getFeatureKeyForSurface(p2): string
	if FFlagEnforceRobloxShopForAllSurfaces then
		return "ROBLOX_SHOP"
	end

	if p2 == nil or table.find(v5, p2) == nil then
		return "DEVELOPER_SHOP"
	end

	return "ROBLOX_SHOP"
end

return getFeatureKeyForSurface
