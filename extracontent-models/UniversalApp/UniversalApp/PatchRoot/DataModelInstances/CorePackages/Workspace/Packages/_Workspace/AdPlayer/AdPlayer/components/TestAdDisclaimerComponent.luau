local Parent = script:FindFirstAncestor("AdPlayer").Parent
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local t1 = {
	eligibleDisclaimer = "CoreScripts.Ads.Label.RewardedVideoEligibleDisclaimer",
	ineligibleDisclaimer = "CoreScripts.Ads.Label.RewardedVideoIneligibleDisclaimer"
}

local function TestAdDisclaimerComponent(t2: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), t1 (copy), useTokens (copy), React (copy), FoundationText (copy)
	local v10 = useLocalization(t1)
	local v11 = useTokens()

	return React.createElement(FoundationText, {
		tag = "bg-over-media-0 padding-medium radius-medium auto-xy text-body-large anchor-top-center",
		Position = UDim2.new(0.5, 0, 0, v11.Gap.XLarge),
		Text = if not t2.isEligible then v10.ineligibleDisclaimer else v10.eligibleDisclaimer
	})
end

return TestAdDisclaimerComponent
