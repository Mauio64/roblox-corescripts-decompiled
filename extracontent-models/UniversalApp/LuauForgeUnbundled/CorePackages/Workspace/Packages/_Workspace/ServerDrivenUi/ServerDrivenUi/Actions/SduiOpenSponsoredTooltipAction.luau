local localizeStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").localizeStrings
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")
local getInputModeStore = Responsive.GetInputModeStore
local openInfoPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryRouting").OpenInfoPeekView
local openCloseOnlyInteractiveAlert = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryRouting").OpenCloseOnlyInteractiveAlert

local sduiResponsiveHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiResponsiveHelpers

return function(p2, p3, p4)
	local dispatch = p4.dependencies.dispatch
	local v5 = localizeStrings(p4.dependencies.localization, {
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic",
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds"
	})

	local portraitOrientation = sduiResponsiveHelpers.isPortraitOrientation()
	local lastInputType = getInputModeStore(false).getLastInputType(false)
	local sponsoredDisclosure = v5.SponsoredDisclosure
	local sponsoredTitle = v5.SponsoredTitle

	if lastInputType == Responsive.Input.Touch and portraitOrientation then
		dispatch(openInfoPeekView(sponsoredTitle, sponsoredDisclosure))
	else
		dispatch(openCloseOnlyInteractiveAlert(sponsoredTitle, sponsoredDisclosure, function()
			return dispatch(closeCentralOverlay())
		end))
	end
end
