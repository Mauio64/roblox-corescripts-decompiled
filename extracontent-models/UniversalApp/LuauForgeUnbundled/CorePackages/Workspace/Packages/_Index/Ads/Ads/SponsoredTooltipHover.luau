local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Ads/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Ads/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Ads/Localization").Hooks.useLocalization
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/Ads/AppBlox").IconWithTooltip

local function SponsoredTooltipHover(p2)
	local v5 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic"
	})

	return React.createElement(
		iconWithTooltip,
		Cryo.Dictionary.join(p2, {
			hoverText = v5.SponsoredDisclosure,
			triggerPointName = "SponsoredTooltip"
		})
	)
end

return SponsoredTooltipHover
