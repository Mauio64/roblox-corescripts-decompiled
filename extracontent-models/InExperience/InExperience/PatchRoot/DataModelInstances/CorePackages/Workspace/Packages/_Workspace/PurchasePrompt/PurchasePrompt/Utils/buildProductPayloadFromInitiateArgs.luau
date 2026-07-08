local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum

local function buildProductPayloadFromInitiateArgs(s1: string, p1, b1: boolean?, b2: boolean?, s2: string?, s3: string?, s4: string?, s5: string?, s6: string?, n1: number?, p2) -- line: 10
	-- upvalues: ProductTypeEnum (copy)
	local v15 = p2 or {}

	if p1 == Enum.InfoType.Asset then
		return {
			kind = ProductTypeEnum.Asset,
			id = tostring(s1),
			equipIfPurchased = b1 or false,
			isRobloxPurchase = b2 or false,
			idempotencyKey = s2 or "",
			purchaseAuthToken = s3 or "",
			collectibleItemId = s4 or "",
			collectibleItemInstanceId = s5 or "",
			collectibleProductId = s6 or "",
			expectedPrice = n1 or 0
		}
	end

	if p1 == Enum.InfoType.GamePass then
		return {
			kind = ProductTypeEnum.Gamepass,
			id = tostring(s1)
		}
	end

	if p1 == Enum.InfoType.Product then
		return {
			universeId = nil,
			kind = ProductTypeEnum.Product,
			id = tostring(s1),
			equipIfPurchased = b1 or false
		}
	end

	if p1 == Enum.InfoType.Bundle then
		return {
			kind = ProductTypeEnum.Bundle,
			id = tostring(s1),
			idempotencyKey = s2 or "",
			collectibleItemId = s4 or "",
			collectibleItemInstanceId = s5 or "",
			collectibleProductId = s6 or "",
			expectedPrice = n1 or 0
		}
	end

	if p1 == ProductTypeEnum.Experience then
		return {
			kind = ProductTypeEnum.Experience,
			universeId = tostring(s1),
			experienceName = v15.name or "",
			experienceIconUrl = v15.imageUrl or ""
		}
	end

	if p1 == ProductTypeEnum.Look then
		return {
			salesLocationId = 0,
			kind = ProductTypeEnum.Look,
			id = tostring(s1),
			expectedPrice = v15.expectedPrice or (n1 or 0),
			excludedAssetIds = {},
			excludedBundleIds = {}
		}
	end

	return nil
end

return buildProductPayloadFromInitiateArgs
