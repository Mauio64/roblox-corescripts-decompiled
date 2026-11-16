local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Localization = require(parent.Localization)
local localizeStrings = Localization.localizeStrings
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local DiscoveryRouting = require(parent.DiscoveryRouting)
local OpenInfoPeekView = DiscoveryRouting.OpenInfoPeekView
local DiscoveryRouting2 = require(parent.DiscoveryRouting)
local OpenCloseOnlyInteractiveAlert = DiscoveryRouting2.OpenCloseOnlyInteractiveAlert

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiResponsiveHelpers = SduiCoreSystem.SduiResponsiveHelpers

return function(_, _, p)
	local dispatch = p.dependencies.dispatch
	local v = localizeStrings(p.dependencies.localization, {
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})

	local portraitOrientation = SduiResponsiveHelpers.isPortraitOrientation()
	local lastInputType = GetInputModeStore(false).getLastInputType(false)
	local sponsoredDisclosure = v.SponsoredDisclosure
	local sponsoredTitle = v.SponsoredTitle

	if lastInputType == Responsive.Input.Touch and portraitOrientation then
		dispatch(OpenInfoPeekView(sponsoredTitle, sponsoredDisclosure))
	else
		dispatch(OpenCloseOnlyInteractiveAlert(sponsoredTitle, sponsoredDisclosure, function()
			return dispatch(CloseCentralOverlay())
		end))
	end
end
