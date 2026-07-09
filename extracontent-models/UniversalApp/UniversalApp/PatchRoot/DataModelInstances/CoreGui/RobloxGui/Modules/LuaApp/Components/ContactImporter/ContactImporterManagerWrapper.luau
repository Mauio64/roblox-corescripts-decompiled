local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NavigateToRoute = require(Modules.LuaApp.Thunks.NavigateToRoute)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local OpenCentralOverlayForDiscoverabilityUpsell = require(Modules.LuaApp.Thunks.OpenCentralOverlayForDiscoverabilityUpsell)
local OpenPhoneUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenPhoneUpsellModal)
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local ContactImporterManager = require(CorePackages.Workspace.Packages.ContactImporter).ContactImporterManager
local OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer
local SetHomePageUpsellCardVariation = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.SetHomePageUpsellCardVariation
local WaitUntilIXPUserInit = require(Modules.LuaApp.Thunks.WaitUntilIXPUserInit)

local function ContactImporterManagerWrapper() -- line: 21
	-- upvalues: useDispatch (copy), OpenAmpWizardContainer (copy), NavigateToRoute (copy), Dash (copy), OpenCentralOverlayForDiscoverabilityUpsell (copy), CloseCentralOverlay (copy), SetHomePageUpsellCardVariation (copy), WaitUntilIXPUserInit (copy), IXPService (copy), React (copy), ContactImporterManager (copy), OpenPhoneUpsellModal (copy), OpenContactImporterLearnMoreLink (copy), OpenProfilePeekView (copy)
	local v18 = useDispatch()

	return React.createElement(ContactImporterManager, {
		openAmpUpsell = function(p1, p2) -- line: 24
			-- upvalues: v18 (copy), OpenAmpWizardContainer (copy)
			v18(OpenAmpWizardContainer(p1, p2))
		end,
		navigate = function(p3, p4) -- line: 28
			-- upvalues: v18 (copy), NavigateToRoute (copy), Dash (copy)
			v18(NavigateToRoute({ Dash.join({
				name = p3
			}, p4) }))
		end,
		openDiscoverabilityModal = function(p5) -- line: 32
			-- upvalues: v18 (copy), OpenCentralOverlayForDiscoverabilityUpsell (copy)
			v18(OpenCentralOverlayForDiscoverabilityUpsell(p5))
		end,
		onCloseDiscoverabilityModal = function() -- line: 36
			-- upvalues: v18 (copy), CloseCentralOverlay (copy)
			v18(CloseCentralOverlay())
		end,
		openPhoneUpsellModal = OpenPhoneUpsellModal,
		closeCentralOverlay = CloseCentralOverlay,
		openContactImporterLearnMoreLink = OpenContactImporterLearnMoreLink,
		openProfilePeekView = OpenProfilePeekView,
		hideUpsellCard = function() -- line: 40
			-- upvalues: v18 (copy), SetHomePageUpsellCardVariation (copy)
			v18(SetHomePageUpsellCardVariation("", "", ""))
		end,
		waitUntilIXPUserInit = function(p6) -- line: 44
			-- upvalues: v18 (copy), WaitUntilIXPUserInit (copy), IXPService (copy)
			return v18(WaitUntilIXPUserInit(IXPService, p6))
		end
	})
end

return ContactImporterManagerWrapper
