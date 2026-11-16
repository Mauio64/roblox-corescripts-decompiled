local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local useFlyoutItemNavigation = require(script.Parent.Parent.Hooks.useFlyoutItemNavigation)

local function TermsPrivacyFooter(p)
	local v = FlyoutContentSettings.ItemInfo[FlyoutContentSettings.ItemType.Terms]
	local v2 = FlyoutContentSettings.ItemInfo[FlyoutContentSettings.ItemType.Privacy]

	local onActivated = useFlyoutItemNavigation(v, p.closeDrawer)
	local onActivated2 = useFlyoutItemNavigation(v2, p.closeDrawer)

	local v3 = useLocalization({ termsText = v.textKey, privacyText = v2.textKey })

	return React.createElement(
		View,
		{
			tag = "row align-x-center align-y-center gap-xxlarge size-full-500 padding-x-xlarge",
			LayoutOrder = p.layoutOrder
		},
		{
			Terms = React.createElement(
				View,
				{
					tag = "auto-xy",
					onActivated = onActivated,
					testId = "--core-ui-flyout-terms",
					LayoutOrder = 1
				},
				{
					Label = React.createElement(Text, {
						tag = "auto-xy text-label-medium content-default",
						Text = v3.termsText
					})
				}
			),
			Privacy = React.createElement(
				View,
				{
					tag = "auto-xy",
					onActivated = onActivated2,
					testId = "--core-ui-flyout-privacy",
					LayoutOrder = 2
				},
				{
					Label = React.createElement(Text, {
						tag = "auto-xy text-label-medium content-default",
						Text = v3.privacyText
					})
				}
			)
		}
	)
end

return TermsPrivacyFooter
