local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface

local FFlagEnforceRobloxShopForAllSurfaces = require(PurchasePrompt.Flags.FFlagEnforceRobloxShopForAllSurfaces)

local v = {
	ProductPurchaseSurface.InExperienceShopHome,
	ProductPurchaseSurface.InExperienceShopSearch,
	ProductPurchaseSurface.InExperienceShopDetails
}

local function getFeatureKeyForSurface(p): string
	if FFlagEnforceRobloxShopForAllSurfaces then
		return "ROBLOX_SHOP"
	end

	if p == nil or table.find(v, p) == nil then
		return "DEVELOPER_SHOP"
	end

	return "ROBLOX_SHOP"
end

return getFeatureKeyForSurface
