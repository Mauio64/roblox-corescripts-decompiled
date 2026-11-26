local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local view = Foundation.View
local text = Foundation.Text
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization

local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")
local useFlyoutItemNavigation = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutItemNavigation")

local function TermsPrivacyFooter(p2)
	local v5 = FlyoutContentSettings.ItemInfo[FlyoutContentSettings.ItemType.Terms]
	local v6 = FlyoutContentSettings.ItemInfo[FlyoutContentSettings.ItemType.Privacy]

	local v7 = useFlyoutItemNavigation(v5, p2.closeDrawer)
	local v8 = useFlyoutItemNavigation(v6, p2.closeDrawer)

	local v9 = useLocalization({ termsText = v5.textKey, privacyText = v6.textKey })

	return React.createElement(
		view,
		{
			tag = "row align-x-center align-y-center gap-xxlarge size-full-500 padding-x-xlarge",
			LayoutOrder = p2.layoutOrder
		},
		{
			Terms = React.createElement(
				view,
				{
					tag = "auto-xy",
					onActivated = v7,
					testId = "--core-ui-flyout-terms",
					LayoutOrder = 1
				},
				{
					Label = React.createElement(text, {
						tag = "auto-xy text-label-medium content-default",
						Text = v9.termsText
					})
				}
			),
			Privacy = React.createElement(
				view,
				{
					tag = "auto-xy",
					onActivated = v8,
					testId = "--core-ui-flyout-privacy",
					LayoutOrder = 2
				},
				{
					Label = React.createElement(text, {
						tag = "auto-xy text-label-medium content-default",
						Text = v9.privacyText
					})
				}
			)
		}
	)
end

return TermsPrivacyFooter
