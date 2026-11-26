local selectProductPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectProductPrice")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function selectVIPServerOfferType(p2): string
	if p2.productInfo.isFreeWithRobloxPlus then
		return "plus_included"
	end

	if selectProductPrice(p2) == 0 then
		return "free"
	end

	return "paid"
end

return selectVIPServerOfferType
