local parent = script:FindFirstAncestor("Ads").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AppBlox = require(parent.AppBlox)
local IconWithTooltip = AppBlox.IconWithTooltip

local function SponsoredTooltipHover(p)
	local v = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic"
	})

	return React.createElement(
		IconWithTooltip,
		Cryo.Dictionary.join(p, {
			hoverText = v.SponsoredDisclosure,
			triggerPointName = "SponsoredTooltip"
		})
	)
end

return SponsoredTooltipHover
