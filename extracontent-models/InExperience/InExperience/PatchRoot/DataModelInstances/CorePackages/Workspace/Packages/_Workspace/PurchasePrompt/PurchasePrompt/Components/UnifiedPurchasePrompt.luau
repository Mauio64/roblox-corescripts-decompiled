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
local dispatchPurchaseForProductPayload = require(PurchasePrompt.Utils.dispatchPurchaseForProductPayload)

require(PurchasePrompt.types)

local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions
local _ = SharedFlags.FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)

require(PurchasePrompt.types)

local function UnifiedPurchasePrompt(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), SetProductPayload (copy), SetPurchaseCallbacks (copy), SetPostPurchaseActions (copy), SetPurchaseAnalyticsMetadata (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), SetPurchaseOptions (copy), dispatchPurchaseForProductPayload (copy), PurchasePromptApp (copy), FFlagPurchasePromptCartPricingEnabled (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy)
	local store = t1.store

	React.useEffect(function() -- line: 37
		-- upvalues: t1 (copy), store (copy), SetProductPayload (copy), SetPurchaseCallbacks (copy), SetPostPurchaseActions (copy), SetPurchaseAnalyticsMetadata (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), SetPurchaseOptions (copy), dispatchPurchaseForProductPayload (copy)
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

		dispatchPurchaseForProductPayload(function(p1) -- line: 61
			-- upvalues: store (copy)
			store:dispatch(p1)
		end, productPayload, nil, false)
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
