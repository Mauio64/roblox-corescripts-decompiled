local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")
local productPurchaseSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptLite").Enums.ProductPurchaseSurface

local function getPurchaseSurface(p2)
	if p2 and p2.surface then
		return p2.surface
	end

	if AppContext.get() == AppContext.Enum.IN_EXPERIENCE then
		return productPurchaseSurface.InExperience
	end

	return productPurchaseSurface.Unknown
end

return getPurchaseSurface
