local parent = script:FindFirstAncestor("AdPlayer").Parent
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text

local v = {
	eligibleDisclaimer = "CoreScripts.Ads.Label.RewardedVideoEligibleDisclaimer",
	ineligibleDisclaimer = "CoreScripts.Ads.Label.RewardedVideoIneligibleDisclaimer"
}

local function TestAdDisclaimerComponent(p)
	local v2 = useLocalization(v)
	local v3 = useTokens()

	local createElement = React.createElement
	local v4 = {
		tag = "bg-over-media-0 padding-medium radius-medium auto-xy text-body-large anchor-top-center",
		Position = UDim2.new(0.5, 0, 0, v3.Gap.XLarge),
		Text = 0
	}
	local text

	if p.isEligible then
		text = v2.eligibleDisclaimer
	else
		text = v2.ineligibleDisclaimer
	end

	v4.Text = text
	return createElement(Text, v4)
end

return TestAdDisclaimerComponent
