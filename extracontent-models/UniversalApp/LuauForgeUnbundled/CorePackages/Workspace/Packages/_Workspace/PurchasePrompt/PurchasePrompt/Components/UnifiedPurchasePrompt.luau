local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")

local PurchasePromptApp = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/PurchasePromptApp")
local SetPurchaseCallbacks = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseCallbacks")
local SetPostPurchaseActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPostPurchaseActions")
local SetProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetProductPayload")
local SetPurchaseAnalyticsMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseAnalyticsMetadata")
local SetPurchaseOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseOptions")
local dispatchPurchaseForProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/dispatchPurchaseForProductPayload")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local fFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

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

		if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and props.purchaseOptions then
			store:dispatch(SetPurchaseOptions(props.purchaseOptions))
		end

		dispatchPurchaseForProductPayload(function(p2)
			store:dispatch(p2)
		end, productPayload, nil, false)
	end, { props.productPayload, props.purchaseCallbacks, props.postPurchaseActions })

	local createElement = React.createElement
	local v6 = { store = store, network = props.network, subtitleView = 0 }
	local v7 = if fFlagPurchasePromptSubtitleForTimedOptions then props.subtitleView else nil
	v6.subtitleView = v7
	return createElement(PurchasePromptApp, v6)
end

return UnifiedPurchasePrompt
