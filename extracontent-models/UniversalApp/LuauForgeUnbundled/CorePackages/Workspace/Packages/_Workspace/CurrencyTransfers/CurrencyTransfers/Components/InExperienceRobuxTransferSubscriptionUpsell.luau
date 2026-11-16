local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local AmpWizardTransferConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/AmpWizardTransferConstants")

local inExpAmpWizardController = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/AmpUpsell").InExpAmpWizardController

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/RobloxSubscriptionPurchaseApp")
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext

local function InExperienceRobuxTransferSubscriptionUpsell(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.SubscriptionUpsellContainer)
	local onClose = p2.onClose
	local upsellSubscriptionTitle = v5.UpsellSubscriptionTitle or ""

	React.useEffect(function()
		local v6 = {
			purchaseUIOptions = { title = upsellSubscriptionTitle },
			surfaceName = surfaceName.RobuxTransferUpsell,
			surfaceContext = surfaceContext.InGame
		}

		inExpAmpWizardController.OpenAmpWizardContainerInExp("CanInitiateRobuxTransfer", function()
			onClose()
		end, v6, AmpWizardTransferConstants.ENTRY_POINT_EVENT_CTX, nil, AmpWizardTransferConstants.NAMESPACE_NAME)
	end, {})

	return React.createElement(React.Fragment, {})
end

return InExperienceRobuxTransferSubscriptionUpsell
