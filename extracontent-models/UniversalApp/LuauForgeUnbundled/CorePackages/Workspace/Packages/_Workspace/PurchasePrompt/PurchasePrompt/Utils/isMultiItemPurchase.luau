local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

function LUAUFORGE_MODULE_GLOBALS_bhG_isMultiItemPurchase(p2): boolean
	return p2 == RequestType.Look
end

return LUAUFORGE_MODULE_GLOBALS_bhG_isMultiItemPurchase
