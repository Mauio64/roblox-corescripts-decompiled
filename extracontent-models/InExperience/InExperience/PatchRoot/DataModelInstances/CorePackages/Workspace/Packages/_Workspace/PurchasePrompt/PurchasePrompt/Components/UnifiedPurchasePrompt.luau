local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local React = require(PurchasePromptParent.React)

require(PurchasePromptParent.IAPExperience)

local PurchasePromptApp = require(PurchasePrompt.Components.PurchasePromptApp)
local SetPurchaseCallbacks = require(PurchasePrompt.Actions.SetPurchaseCallbacks)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local SetPurchaseOptions = require(PurchasePrompt.Actions.SetPurchaseOptions)
local initiatePurchase = require(PurchasePrompt.Thunks.initiatePurchase)
local initiateBundlePurchase = require(PurchasePrompt.Thunks.initiateBundlePurchase)
local dispatchPurchaseForProductPayload = require(PurchasePrompt.Utils.dispatchPurchaseForProductPayload)
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions
local _ = SharedFlags.FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal
local FFlagRefactorUnifiedPurchasePrompt = require(PurchasePrompt.Flags.FFlagRefactorUnifiedPurchasePrompt)
local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(PurchasePrompt.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)

require(PurchasePrompt.types)

local function UnifiedPurchasePrompt(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), SetProductPayload (copy), SetPurchaseCallbacks (copy), SetPostPurchaseActions (copy), SetPurchaseAnalyticsMetadata (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), SetPurchaseOptions (copy), FFlagRefactorUnifiedPurchasePrompt (copy), dispatchPurchaseForProductPayload (copy), ProductTypeEnum (copy), initiatePurchase (copy), initiateBundlePurchase (copy), FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell (copy), FFlagAXMISWithBlackbird (copy), PurchasePromptApp (copy), FFlagPurchasePromptCartPricingEnabled (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy)
	local store = t1.store

	React.useEffect(function() -- line: 44
		-- upvalues: t1 (copy), store (copy), SetProductPayload (copy), SetPurchaseCallbacks (copy), SetPostPurchaseActions (copy), SetPurchaseAnalyticsMetadata (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), SetPurchaseOptions (copy), FFlagRefactorUnifiedPurchasePrompt (copy), dispatchPurchaseForProductPayload (copy), ProductTypeEnum (copy), initiatePurchase (copy), initiateBundlePurchase (copy), FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell (copy), FFlagAXMISWithBlackbird (copy)
		local productPayload = t1.productPayload

		store:dispatch(SetProductPayload(productPayload))

		if t1.purchaseCallbacks then
			store:dispatch(SetPurchaseCallbacks(t1.purchaseCallbacks))
		end

		if t1.postPurchaseActions then
			store:dispatch(SetPostPurchaseActions(t1.postPurchaseActions))
		end

		if t1.purchaseAnalyticsMetadata then
			store:dispatch(SetPurchaseAnalyticsMetadata({
				surface = t1.purchaseAnalyticsMetadata.surface,
				productUniverseId = t1.purchaseAnalyticsMetadata.productUniverseId
			}))
		end

		if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and t1.purchaseOptions then
			store:dispatch(SetPurchaseOptions(t1.purchaseOptions))
		end

		if FFlagRefactorUnifiedPurchasePrompt then
			dispatchPurchaseForProductPayload(function(p1) -- line: 69
				-- upvalues: store (copy)
				store:dispatch(p1)
			end, productPayload, nil, false)

			return
		end

		if productPayload.kind == ProductTypeEnum.Asset then
			store:dispatch(initiatePurchase(productPayload.id, Enum.InfoType.Asset, productPayload.equipIfPurchased, productPayload.isRobloxPurchase, productPayload.idempotencyKey, nil, productPayload.collectibleItemId, productPayload.collectibleItemInstanceId, productPayload.collectibleProductId, productPayload.expectedPrice))

			return
		end

		if productPayload.kind == ProductTypeEnum.Gamepass then
			store:dispatch(initiatePurchase(productPayload.id, Enum.InfoType.GamePass))

			return
		end

		if productPayload.kind == ProductTypeEnum.Product then
			store:dispatch(initiatePurchase(productPayload.id, Enum.InfoType.Product, productPayload.equipIfPurchased))

			return
		end

		if productPayload.kind == ProductTypeEnum.Bundle then
			store:dispatch(initiateBundlePurchase(productPayload.id, productPayload.idempotencyKey, nil, productPayload.collectibleItemId, productPayload.collectibleItemInstanceId, productPayload.collectibleProductId, productPayload.expectedPrice))

			return
		end

		if productPayload.kind == ProductTypeEnum.Experience then
			store:dispatch(initiatePurchase(productPayload.universeId, ProductTypeEnum.Experience, nil, nil, nil, nil, nil, nil, nil, nil, {
				name = productPayload.experienceName,
				imageUrl = productPayload.experienceIconUrl
			}))

			return
		end

		if productPayload.kind == ProductTypeEnum.Look then
			store:dispatch(initiatePurchase(productPayload.id, ProductTypeEnum.Look, nil, nil, nil, nil, nil, nil, nil, nil, if not FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then {
				expectedPrice = productPayload.expectedPrice
			} else {
				expectedPrice = productPayload.expectedPrice,
				excludedAssetIds = productPayload.excludedAssetIds,
				excludedBundleIds = productPayload.excludedBundleIds,
				timedOptions = productPayload.timedOptions
			}))

			return
		end

		if FFlagAXMISWithBlackbird and productPayload.kind == ProductTypeEnum.RobuxUpsell then
			store:dispatch(initiatePurchase(nil, ProductTypeEnum.RobuxUpsell, nil, nil, nil, nil, nil, nil, nil, nil, nil))

			return
		end

		if productPayload.kind == ProductTypeEnum.DeveloperSubscription then
			store:dispatch(initiatePurchase(productPayload.subscriptionId, ProductTypeEnum.DeveloperSubscription, nil, nil, nil, nil, nil, nil, nil, productPayload.expectedPrice, {
				expectedPrice = productPayload.expectedPrice,
				name = productPayload.name,
				iconImageAssetId = productPayload.iconImageAssetId,
				displayPrice = productPayload.displayPrice
			}))
		end
	end, {
		t1.productPayload,
		t1.purchaseCallbacks,
		t1.postPurchaseActions
	})

	return React.createElement(PurchasePromptApp, {
		store = store,
		network = if not FFlagPurchasePromptCartPricingEnabled then nil else t1.network,
		subtitleView = if not FFlagPurchasePromptSubtitleForTimedOptions then nil else t1.subtitleView
	})
end

return UnifiedPurchasePrompt
