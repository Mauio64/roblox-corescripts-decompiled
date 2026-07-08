local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local _ = PurchasePrompt.Parent
local RequestType = require(PurchasePrompt.Enums.RequestType)
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local t1 = {
	[RequestType.Asset] = ProductTypeEnum.Asset,
	[RequestType.Bundle] = ProductTypeEnum.Bundle,
	[RequestType.GamePass] = ProductTypeEnum.Gamepass,
	[RequestType.Product] = ProductTypeEnum.Product,
	[RequestType.AvatarCreationFee] = ProductTypeEnum.AvatarCreationFee,
	[RequestType.Experience] = ProductTypeEnum.Experience,
	[RequestType.Look] = ProductTypeEnum.Look,
	[RequestType.DeveloperSubscription] = ProductTypeEnum.DeveloperSubscription
}

function getProductTypeFromRequestType(p1) -- line: 21
	-- upvalues: t1 (copy), ProductTypeEnum (copy)
	return t1[p1] or ProductTypeEnum.Unknown
end

return getProductTypeFromRequestType
