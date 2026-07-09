local Parent = script:FindFirstAncestor("Ads").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local IconWithTooltip = require(Parent.AppBlox).IconWithTooltip

local function SponsoredTooltipHover(t1: {[any]: any}) -- line: 20
	-- upvalues: useLocalization (copy), React (copy), IconWithTooltip (copy), Cryo (copy)
	local v8 = useLocalization({
		SponsoredDisclosure = "CoreScripts.Ads.Label.SponsoredAdsDisclosureStatic"
	})

	return React.createElement(IconWithTooltip, Cryo.Dictionary.join(t1, {
		triggerPointName = "SponsoredTooltip",
		hoverText = v8.SponsoredDisclosure
	}))
end

return SponsoredTooltipHover
