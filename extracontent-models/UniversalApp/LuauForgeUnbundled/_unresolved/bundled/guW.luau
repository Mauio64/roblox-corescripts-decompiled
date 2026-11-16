local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local module3 = require("@luauforge/bundled/fue")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local linkingProtocol = require("@luauforge/bundled/bXh").LinkingProtocol
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local fFlagPhoneUpsellLegalLinkPolicy = SharedFlags.FFlagPhoneUpsellLegalLinkPolicy
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

return function(p2, p3)
	return function(object)
		function p2.closeUpsell()
			return object:dispatch(closeCentralOverlay())
		end

		function p2.showWebpage(p4)
			if fFlagPhoneUpsellLegalLinkPolicy then
				local appFeaturePolicies = getAppFeaturePolicies()

				if
					appFeaturePolicies.shouldUseExternalBrowserForDisclaimerLinks()
					or not appFeaturePolicies.getWebViewSupport()
				then
					linkingProtocol.default:openURL(p4)
					return
				end
			end

			local v5 = {
				name = appPage.GenericWebPage,
				detail = p4,
				extraProps = {
					title = "",
					transitionAnimation = module3.SlideInFromBottom
				}
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			end

			return object:dispatch(navigateDown(v5))
		end

		if p3 then
			object:dispatch(module2(module.VoicePhoneVerificationUpsellOverlayWrapper, p2))
		else
			object:dispatch(module2(module.PhoneVerificationUpsellOverlayWrapper, p2))
		end
	end
end
