local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local React = require(parent.React)
require(parent.IAPExperience)

local PurchasePromptApp = require(PurchasePrompt.Components.PurchasePromptApp)
local SetPurchaseCallbacks = require(PurchasePrompt.Actions.SetPurchaseCallbacks)
local SetPostPurchaseActions = require(PurchasePrompt.Actions.SetPostPurchaseActions)
local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)
local SetPurchaseAnalyticsMetadata = require(PurchasePrompt.Actions.SetPurchaseAnalyticsMetadata)
local SetPurchaseOptions = require(PurchasePrompt.Actions.SetPurchaseOptions)
local dispatchPurchaseForProductPayload = require(PurchasePrompt.Utils.dispatchPurchaseForProductPayload)
require(PurchasePrompt.types)
local SharedFlags = require(parent.SharedFlags)

local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions

require(PurchasePrompt.types)

local function UnifiedPurchasePrompt(props)
	local store = props.store
	React.useEffect(function()
		local productPayload = props.productPayload

		store:dispatch(SetProductPayload(productPayload))

		if props.purchaseCallbacks then
			store:dispatch(SetPurchaseCallbacks(props.purchaseCallbacks))
		end

		if props.postPurchaseActions then
			store:dispatch(SetPostPurchaseActions(props.postPurchaseActions))
		end

		if props.purchaseAnalyticsMetadata then
			store:dispatch(SetPurchaseAnalyticsMetadata({
				surface = props.purchaseAnalyticsMetadata.surface,
				productUniverseId = props.purchaseAnalyticsMetadata.productUniverseId
			}))
		end

		if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and props.purchaseOptions then
			store:dispatch(SetPurchaseOptions(props.purchaseOptions))
		end

		dispatchPurchaseForProductPayload(function(p)
			store:dispatch(p)
		end, productPayload, nil, false)
	end, { props.productPayload, props.purchaseCallbacks, props.postPurchaseActions })

	local createElement = React.createElement
	local v = { store = store, network = props.network, subtitleView = 0 }
	local subtitleView

	if FFlagPurchasePromptSubtitleForTimedOptions then
		subtitleView = props.subtitleView
	end

	v.subtitleView = subtitleView
	return createElement(PurchasePromptApp, v)
end

return UnifiedPurchasePrompt
