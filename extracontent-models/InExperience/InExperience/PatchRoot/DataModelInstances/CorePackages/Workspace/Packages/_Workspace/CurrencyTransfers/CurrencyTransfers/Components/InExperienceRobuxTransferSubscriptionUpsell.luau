local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)

local AmpUpsell = require(parent.AmpUpsell)
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local function InExperienceRobuxTransferSubscriptionUpsell(p)
	local v = useLocalization(TransferLocalizationKeys.Presets.SubscriptionUpsellContainer)
	local onClose = p.onClose
	local upsellSubscriptionTitle = v.UpsellSubscriptionTitle or ""

	React.useEffect(function()
		local v2 = {
			purchaseUIOptions = { title = upsellSubscriptionTitle },
			surfaceName = SurfaceName.RobuxTransferUpsell,
			surfaceContext = SurfaceContext.InGame
		}

		InExpAmpWizardController.OpenAmpWizardContainerInExp("CanInitiateRobuxTransfer", function()
			onClose()
		end, v2, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, nil, AmpWizardTransferConstants.NAMESPACE_NAME)
	end, {})

	return React.createElement(React.Fragment, {})
end

return InExperienceRobuxTransferSubscriptionUpsell
