local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local initiatePurchase = require(PurchasePrompt.Thunks.initiatePurchase)
local initiateBundlePurchase = require(PurchasePrompt.Thunks.initiateBundlePurchase)
local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(PurchasePrompt.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function dispatchPurchaseForProductPayload(p1: ((...any) -> ...any), p2, _, b1: boolean) -- line: 18
	-- upvalues: ProductTypeEnum (copy), initiatePurchase (copy), initiateBundlePurchase (copy), FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell (copy), FFlagAXMISWithBlackbird (copy)
	if p2.kind == ProductTypeEnum.Asset then
		p1(initiatePurchase(p2.id, Enum.InfoType.Asset, p2.equipIfPurchased, p2.isRobloxPurchase, p2.idempotencyKey, nil, p2.collectibleItemId, p2.collectibleItemInstanceId, p2.collectibleProductId, p2.expectedPrice, nil, b1))

		return
	end

	if p2.kind == ProductTypeEnum.Gamepass then
		p1(initiatePurchase(p2.id, Enum.InfoType.GamePass, nil, nil, nil, nil, nil, nil, nil, nil, nil, b1))

		return
	end

	if p2.kind == ProductTypeEnum.Product then
		p1(initiatePurchase(p2.id, Enum.InfoType.Product, p2.equipIfPurchased, nil, nil, nil, nil, nil, nil, nil, nil, b1))

		return
	end

	if p2.kind == ProductTypeEnum.Bundle then
		p1(initiateBundlePurchase(p2.id, p2.idempotencyKey, nil, p2.collectibleItemId, p2.collectibleItemInstanceId, p2.collectibleProductId, p2.expectedPrice, b1))

		return
	end

	if p2.kind == ProductTypeEnum.Experience then
		p1(initiatePurchase(p2.universeId, ProductTypeEnum.Experience, nil, nil, nil, nil, nil, nil, nil, nil, {
			name = p2.experienceName,
			imageUrl = p2.experienceIconUrl
		}, b1))

		return
	end

	if p2.kind == ProductTypeEnum.Look then
		p1(initiatePurchase(p2.id, ProductTypeEnum.Look, nil, nil, nil, nil, nil, nil, nil, nil, if not FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then {
			expectedPrice = p2.expectedPrice
		} else {
			excludedAssetIds = p2.excludedAssetIds,
			excludedBundleIds = p2.excludedBundleIds,
			timedOptions = p2.timedOptions
		}, b1))

		return
	end

	if FFlagAXMISWithBlackbird and p2.kind == ProductTypeEnum.RobuxUpsell then
		p1(initiatePurchase(p2.id, ProductTypeEnum.RobuxUpsell, nil, nil, nil, nil, nil, nil, nil, nil, nil, false))

		return
	end

	if p2.kind == ProductTypeEnum.DeveloperSubscription then
		p1(initiatePurchase(p2.subscriptionId, ProductTypeEnum.DeveloperSubscription, nil, nil, nil, nil, nil, nil, nil, p2.expectedPrice, {
			expectedPrice = p2.expectedPrice,
			name = p2.name,
			iconImageAssetId = p2.iconImageAssetId,
			displayPrice = p2.displayPrice
		}, b1))
	end
end

return dispatchPurchaseForProductPayload
