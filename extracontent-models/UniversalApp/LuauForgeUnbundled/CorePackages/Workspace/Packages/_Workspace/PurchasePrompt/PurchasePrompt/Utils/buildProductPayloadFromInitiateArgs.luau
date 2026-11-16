local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local function buildProductPayloadFromInitiateArgs(p2, p3, p4, p5, value, value2, value3, value4, value5, value6, options)
	local v5 = options or {}

	if p3 == Enum.InfoType.Asset then
		return {
			kind = productTypeEnum.Asset,
			id = tostring(p2),
			equipIfPurchased = p4 or false,
			isRobloxPurchase = p5 or false,
			idempotencyKey = value or "",
			purchaseAuthToken = value2 or "",
			collectibleItemId = value3 or "",
			collectibleItemInstanceId = value4 or "",
			collectibleProductId = value5 or "",
			expectedPrice = value6 or 0
		}
	end

	if p3 == Enum.InfoType.GamePass then
		return { kind = productTypeEnum.Gamepass, id = tostring(p2) }
	end

	if p3 == Enum.InfoType.Product then
		return {
			kind = productTypeEnum.Product,
			id = tostring(p2),
			equipIfPurchased = p4 or false,
			universeId = nil
		}
	end

	if p3 == Enum.InfoType.Bundle then
		return {
			kind = productTypeEnum.Bundle,
			id = tostring(p2),
			idempotencyKey = value or "",
			collectibleItemId = value3 or "",
			collectibleItemInstanceId = value4 or "",
			collectibleProductId = value5 or "",
			expectedPrice = value6 or 0
		}
	end

	if p3 == productTypeEnum.Experience then
		return {
			kind = productTypeEnum.Experience,
			universeId = tostring(p2),
			experienceName = v5.name or "",
			experienceIconUrl = v5.imageUrl or ""
		}
	end

	if p3 == productTypeEnum.Look then
		return {
			kind = productTypeEnum.Look,
			id = tostring(p2),
			expectedPrice = v5.expectedPrice or value6 or 0,
			salesLocationId = 0,
			excludedAssetIds = {},
			excludedBundleIds = {}
		}
	end

	if fFlagLuaAppsEnablePromptVIPServerPurchase and p3 == productTypeEnum.VIPServer then
		return { kind = productTypeEnum.VIPServer, universeId = p2 }
	end

	return nil
end

return buildProductPayloadFromInitiateArgs
