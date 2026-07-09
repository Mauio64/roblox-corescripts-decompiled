local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local Button = Foundation.Button
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local DividerVariant = Foundation.Enums.DividerVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization

local function AgeCheckUpsellCTA(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), React (copy), View (copy), Divider (copy), DividerVariant (copy), Icon (copy), IconName (copy), IconSize (copy), IconVariant (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v19 = useLocalization({
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		bodyText = "Feature.FAE.CheckIfYouCanJoinGame"
	})

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		Banner = React.createElement(View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			TopDivider = React.createElement(Divider, {
				LayoutOrder = 1,
				variant = DividerVariant.Default
			}),
			BannerContent = React.createElement(View, {
				tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-y-medium",
				LayoutOrder = 2
			}, {
				BannerIcon = React.createElement(Icon, {
					tag = "content-emphasis",
					name = IconName.LockClosed,
					size = IconSize.Large,
					variant = IconVariant.Regular
				}),
				BannerText = React.createElement(FoundationText, {
					tag = "shrink auto-xy text-wrap text-align-x-left text-body-medium content-emphasis",
					Text = v19.bodyText
				})
			})
		}),
		UnlockButton = React.createElement(Button, {
			LayoutOrder = 2,
			text = v19.unlock,
			onActivated = t1.onUnlockPressed,
			variant = ButtonVariant.Emphasis,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0)
		})
	})
end

return AgeCheckUpsellCTA
