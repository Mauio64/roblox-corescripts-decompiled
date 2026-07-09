local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)
local InExpAmpWizardController = require(CurrencyTransfersParent.AmpUpsell).InExpAmpWizardController
local RobloxSubscriptionPurchaseApp = require(CurrencyTransfersParent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local function InExperienceRobuxTransferSubscriptionUpsell(t1: {[any]: any}) -- line: 32
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), React (copy), SurfaceName (copy), SurfaceContext (copy), InExpAmpWizardController (copy), AmpWizardTransferConstants (copy)
	local v13 = useLocalization(TransferLocalizationKeys.Presets.SubscriptionUpsellContainer)
	local onClose = t1.onClose
	local v15 = v13.UpsellSubscriptionTitle or ""

	React.useEffect(function() -- line: 43
		-- upvalues: v15 (copy), SurfaceName (copy), SurfaceContext (copy), InExpAmpWizardController (copy), onClose (copy), AmpWizardTransferConstants (copy)
		local t2 = {
			purchaseUIOptions = {
				title = v15
			},
			surfaceName = SurfaceName.RobuxTransferUpsell,
			surfaceContext = SurfaceContext.InGame
		}

		InExpAmpWizardController.OpenAmpWizardContainerInExp("CanInitiateRobuxTransfer", function() -- line: 57
			-- upvalues: onClose (copy)
			onClose()
		end, t2, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, nil, AmpWizardTransferConstants.NAMESPACE_NAME)
	end, {})

	return React.createElement(React.Fragment, {})
end

return InExperienceRobuxTransferSubscriptionUpsell
