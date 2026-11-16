local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local AppContext = require(PurchasePrompt.Utils.AppContext)
local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface

local function getPurchaseSurface(p)
	if p and p.surface then
		return p.surface
	end

	if AppContext.get() == AppContext.Enum.IN_EXPERIENCE then
		return ProductPurchaseSurface.InExperience
	end

	return ProductPurchaseSurface.Unknown
end

return getPurchaseSurface
