local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local localizeStrings = require(Parent.Localization).localizeStrings
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local Responsive = require(Parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local OpenInfoPeekView = require(Parent.DiscoveryRouting).OpenInfoPeekView
local OpenCloseOnlyInteractiveAlert = require(Parent.DiscoveryRouting).OpenCloseOnlyInteractiveAlert
local SduiResponsiveHelpers = require(Parent.SduiCoreSystem).SduiResponsiveHelpers

return function(_, _, p3) -- line: 19
	-- upvalues: localizeStrings (copy), SduiResponsiveHelpers (copy), GetInputModeStore (copy), Responsive (copy), OpenInfoPeekView (copy), OpenCloseOnlyInteractiveAlert (copy), CloseCentralOverlay (copy)
	local dispatch = p3.dependencies.dispatch
	local localization = p3.dependencies.localization
	local v14 = localizeStrings(localization, {
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})
	local v15 = SduiResponsiveHelpers.isPortraitOrientation()
	local v16 = GetInputModeStore(false).getLastInputType(false)
	local SponsoredDisclosure = v14.SponsoredDisclosure
	local SponsoredTitle = v14.SponsoredTitle

	if v16 == Responsive.Input.Touch and v15 then
		dispatch(OpenInfoPeekView(SponsoredTitle, SponsoredDisclosure))

		return
	end

	dispatch(OpenCloseOnlyInteractiveAlert(SponsoredTitle, SponsoredDisclosure, function() -- line: 38
		-- upvalues: dispatch (copy), CloseCentralOverlay (copy)
		return dispatch(CloseCentralOverlay())
	end))
end
