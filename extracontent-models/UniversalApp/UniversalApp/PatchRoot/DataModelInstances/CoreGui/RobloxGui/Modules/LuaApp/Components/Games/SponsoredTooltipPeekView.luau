local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local InfoPeekView = require(CorePackages.Workspace.Packages.AppBlox).InfoPeekView

local function SponsoredTooltipPeekView() -- line: 6
	-- upvalues: useLocalization (copy), React (copy), InfoPeekView (copy)
	local v6 = useLocalization({
		SponsoredTitle = "CoreScripts.Ads.Label.SponsoredAds",
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic"
	})

	return React.createElement(InfoPeekView, {
		title = v6.SponsoredTitle,
		body = v6.SponsoredDisclosure
	})
end

return SponsoredTooltipPeekView
