local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local infoPeekView = require("@game/CorePackages/Workspace/Packages/AppBlox").InfoPeekView

local function SponsoredTooltipPeekView()
	local v5 = useLocalization({
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds",
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic"
	})

	return React.createElement(infoPeekView, {
		title = v5.SponsoredTitle,
		body = v5.SponsoredDisclosure
	})
end

return SponsoredTooltipPeekView
