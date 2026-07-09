local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSocialOnboardingButtons = require(CorePackages.Workspace.Packages.SocialOnboardingButtons).Hooks.useSocialOnboardingButtons
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer
local SetHomePageUpsellCardVariation = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.SetHomePageUpsellCardVariation
local OpenPhoneUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenPhoneUpsellModal)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local OpenCentralOverlayForDiscoverabilityUpsell = require(Modules.LuaApp.Thunks.OpenCentralOverlayForDiscoverabilityUpsell)
local FFlagSocialCarouselShareQREnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSocialCarouselShareQREnabled

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useDispatch (copy), useNavigation (copy), SetCurrentToastMessage (copy), SetHomePageUpsellCardVariation (copy), OpenContactImporterLearnMoreLink (copy), OpenAmpWizardContainer (copy), NavigateDownTo3DQRCodePage (copy), FFlagSocialCarouselShareQREnabled (copy), OpenCentralOverlayForDiscoverabilityUpsell (copy), CloseCentralOverlay (copy), OpenPhoneUpsellModal (copy), AppPage (copy), OpenProfilePeekView (copy), useSocialOnboardingButtons (copy)
	local v18 = useDispatch()
	local v19 = useNavigation()

	return useSocialOnboardingButtons(t1, {
		openPhoneVerificationModal = function(p1) -- line: 68
			-- upvalues: v18 (copy), OpenPhoneUpsellModal (copy)
			return v18(OpenPhoneUpsellModal({
				eventContext = "verificationUpsell",
				origin = "friendsCarousel",
				shouldAutofillAndroidPhoneNumberAtLaunch = true,
				addPhoneTitleKey = "Feature.ContactUpsell.Header.UnlockVoiceChat",
				onSuccess = p1
			}, true))
		end,
		openLearnMoreLink = function() -- line: 45
			-- upvalues: v18 (copy), OpenContactImporterLearnMoreLink (copy)
			v18(OpenContactImporterLearnMoreLink())
		end,
		openAmpUpsell = function(p2, p3) -- line: 49
			-- upvalues: v18 (copy), OpenAmpWizardContainer (copy)
			v18(OpenAmpWizardContainer(p2, p3))
		end,
		navigateToQRCodePage = function() -- line: 53
			-- upvalues: v18 (copy), NavigateDownTo3DQRCodePage (copy), t1 (copy), FFlagSocialCarouselShareQREnabled (copy)
			v18(NavigateDownTo3DQRCodePage({
				source = t1.entryPoint,
				onClose = not FFlagSocialCarouselShareQREnabled and function() -- line: 56
				end or nil
			}))
		end,
		navigateToSearchFriends = function() -- line: 78
			-- upvalues: v19 (copy), AppPage (copy), t1 (copy)
			v19.navigate(AppPage.UserSearch, {
				shouldShowUserSearchLandingPage = true,
				entryPoint = t1.entryPoint
			})
		end,
		openProfilePeekView = function(p4) -- line: 85
			-- upvalues: v18 (copy), OpenProfilePeekView (copy)
			v18(OpenProfilePeekView(p4, {}))
		end,
		hideUpsellCard = function() -- line: 41
			-- upvalues: v18 (copy), SetHomePageUpsellCardVariation (copy)
			v18(SetHomePageUpsellCardVariation("", "", ""))
		end,
		openDiscoverabilityModal = function(p5) -- line: 60
			-- upvalues: v18 (copy), OpenCentralOverlayForDiscoverabilityUpsell (copy)
			v18(OpenCentralOverlayForDiscoverabilityUpsell(p5))
		end,
		closeCentralOverlay = function() -- line: 64
			-- upvalues: v18 (copy), CloseCentralOverlay (copy)
			v18(CloseCentralOverlay())
		end,
		showToast = function(p6) -- line: 35
			-- upvalues: v18 (copy), SetCurrentToastMessage (copy)
			v18(SetCurrentToastMessage({
				toastMessage = p6
			}))
		end
	})
end
