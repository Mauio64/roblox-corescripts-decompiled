local module = require("@luauforge/bundled/hTI")
local module2 = require("@luauforge/bundled/hTJ")
local module3 = require("@luauforge/bundled/hTK")
local module4 = require("@luauforge/bundled/hTF")
local linkingProtocol = require("@luauforge/bundled/hTL").LinkingProtocol
local getAppFeaturePolicies = require("@luauforge/bundled/hTM").getAppFeaturePolicies

local closeCentralOverlay = module.Thunks.CloseCentralOverlay
local setCentralOverlay = module.Actions.SetCentralOverlay
local navigateDown = module2.Thunks.NavigateDown
local appPage = module3.AppPage
local centralOverlayType = module3.CentralOverlayType

local fFlagPhoneUpsellLegalLinkPolicy = module4.FFlagPhoneUpsellLegalLinkPolicy
local fFlagSignalsNavP3Dispatch = module4.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/hTN").NavigationCommands else nil

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
				extraProps = { title = "", transitionAnimation = "SlideInFromBottom" }
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			end

			return object:dispatch(navigateDown(v5))
		end

		if p3 then
			object:dispatch(setCentralOverlay(
				centralOverlayType.VoicePhoneVerificationUpsellOverlayWrapper,
				p2
			))
		else
			object:dispatch(setCentralOverlay(centralOverlayType.PhoneVerificationUpsellOverlayWrapper, p2))
		end
	end
end
