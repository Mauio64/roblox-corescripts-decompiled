local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local function buildProductPayloadFromInitiateArgs(universeId, p, flag: boolean?, flag2: boolean?, value: string?, value2: string?, value3: string?, value4: string?, value5: string?, value6: number?, options)
	local v = options or {}

	if p == Enum.InfoType.Asset then
		return {
			kind = productTypeEnum.Asset,
			id = tostring(universeId),
			equipIfPurchased = flag or false,
			isRobloxPurchase = flag2 or false,
			idempotencyKey = value or "",
			purchaseAuthToken = value2 or "",
			collectibleItemId = value3 or "",
			collectibleItemInstanceId = value4 or "",
			collectibleProductId = value5 or "",
			expectedPrice = value6 or 0
		}
	end

	if p == Enum.InfoType.GamePass then
		return { kind = productTypeEnum.Gamepass, id = tostring(universeId) }
	end

	if p == Enum.InfoType.Product then
		return {
			kind = productTypeEnum.Product,
			id = tostring(universeId),
			equipIfPurchased = flag or false,
			universeId = nil
		}
	end

	if p == Enum.InfoType.Bundle then
		return {
			kind = productTypeEnum.Bundle,
			id = tostring(universeId),
			idempotencyKey = value or "",
			collectibleItemId = value3 or "",
			collectibleItemInstanceId = value4 or "",
			collectibleProductId = value5 or "",
			expectedPrice = value6 or 0
		}
	end

	if p == productTypeEnum.Experience then
		return {
			kind = productTypeEnum.Experience,
			universeId = tostring(universeId),
			experienceName = v.name or "",
			experienceIconUrl = v.imageUrl or ""
		}
	end

	if p == productTypeEnum.Look then
		return {
			kind = productTypeEnum.Look,
			id = tostring(universeId),
			expectedPrice = v.expectedPrice or value6 or 0,
			salesLocationId = 0,
			excludedAssetIds = {},
			excludedBundleIds = {}
		}
	end

	if FFlagLuaAppsEnablePromptVIPServerPurchase and p == productTypeEnum.VIPServer then
		return { kind = productTypeEnum.VIPServer, universeId = universeId }
	end

	return nil
end

return buildProductPayloadFromInitiateArgs
