local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local useFlyoutItemNavigation = require(script.Parent.Parent.Hooks.useFlyoutItemNavigation)

local function TermsPrivacyFooter(t1: {[any]: any}) -- line: 17
	-- upvalues: FlyoutContentSettings (copy), useFlyoutItemNavigation (copy), useLocalization (copy), React (copy), View (copy), FoundationText (copy)
	local v11 = FlyoutContentSettings.ItemInfo[FlyoutContentSettings.ItemType.Terms]
	local v12 = FlyoutContentSettings.ItemInfo[FlyoutContentSettings.ItemType.Privacy]
	local v13 = useFlyoutItemNavigation(v11, t1.closeDrawer)
	local v14 = useFlyoutItemNavigation(v12, t1.closeDrawer)
	local v15 = useLocalization({
		termsText = v11.textKey,
		privacyText = v12.textKey
	})

	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-xxlarge size-full-500 padding-x-xlarge",
		LayoutOrder = t1.layoutOrder
	}, {
		Terms = React.createElement(View, {
			tag = "auto-xy",
			LayoutOrder = 1,
			onActivated = v13
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-label-medium content-default",
				Text = v15.termsText
			})
		}),
		Privacy = React.createElement(View, {
			tag = "auto-xy",
			LayoutOrder = 2,
			onActivated = v14
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-label-medium content-default",
				Text = v15.privacyText
			})
		})
	})
end

return TermsPrivacyFooter
