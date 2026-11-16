local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local RequestType = require(PurchasePrompt.Enums.RequestType)
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum

local v = {
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

function getProductTypeFromRequestType(p)
	return v[p] or productTypeEnum.Unknown
end

return getProductTypeFromRequestType
