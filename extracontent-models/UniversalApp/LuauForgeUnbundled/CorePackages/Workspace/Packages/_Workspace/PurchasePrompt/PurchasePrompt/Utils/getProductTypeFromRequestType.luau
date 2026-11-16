local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum

local v5 = {
	[RequestType.Asset] = productTypeEnum.Asset,
	[RequestType.Bundle] = productTypeEnum.Bundle,
	[RequestType.GamePass] = productTypeEnum.Gamepass,
	[RequestType.Product] = productTypeEnum.Product,
	[RequestType.AvatarCreationFee] = productTypeEnum.AvatarCreationFee,
	[RequestType.Experience] = productTypeEnum.Experience,
	[RequestType.Look] = productTypeEnum.Look,
	[RequestType.DeveloperSubscription] = productTypeEnum.DeveloperSubscription,
	[RequestType.VIPServer] = productTypeEnum.VIPServer
}

function LUAUFORGE_MODULE_GLOBALS_bfx_getProductTypeFromRequestType(p2)
	return v5[p2] or productTypeEnum.Unknown
end

return LUAUFORGE_MODULE_GLOBALS_bfx_getProductTypeFromRequestType
