local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local AppContext = require(PurchasePrompt.Utils.AppContext)
local ProductPurchaseSurface = require(PurchasePromptParent.PurchasePromptLite).Enums.ProductPurchaseSurface

local function getPurchaseSurface(p1) -- line: 6
	-- upvalues: AppContext (copy), ProductPurchaseSurface (copy)
	if p1 and p1.surface then
		return p1.surface
	end

	if AppContext.get() == AppContext.Enum.IN_EXPERIENCE then
		return ProductPurchaseSurface.InExperience
	end

	return ProductPurchaseSurface.Unknown
end

return getPurchaseSurface
