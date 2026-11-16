local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local Button = Foundation.Button
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local DividerVariant = Foundation.Enums.DividerVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize

local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local FFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport
local FFlagDesktopGameJoinCardGamepadSupport = SharedFlags.FFlagDesktopGameJoinCardGamepadSupport
local v = FFlagMobileGameJoinCardGamepadSupport or FFlagDesktopGameJoinCardGamepadSupport

local function AgeCheckUpsellCTA(props)
	local v2 = useLocalization({
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		bodyText = "Feature.FAE.CheckIfYouCanJoinGame"
	})

	local createElement = React.createElement
	local v3 = { tag = "col size-full-0 auto-y", LayoutOrder = props.LayoutOrder }
	local v4 = {
		Banner = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 1 }, {
			TopDivider = React.createElement(Divider, {
				variant = DividerVariant.Default,
				LayoutOrder = 1
			}),
			BannerContent = React.createElement(
				View,
				{
					tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-y-medium",
					LayoutOrder = 2
				},
				{
					BannerIcon = React.createElement(Icon, {
						tag = "content-emphasis",
						name = IconName.LockClosed,
						size = IconSize.Large,
						variant = IconVariant.Regular
					}),
					BannerText = React.createElement(Text, {
						tag = "shrink auto-xy text-wrap text-align-x-left text-body-medium content-emphasis",
						Text = v2.bodyText
					})
				}
			)
		}),
		UnlockButton = 0
	}

	local createElement2 = React.createElement
	local ref

	if v then
		ref = props.focusRef
	end

	v4.UnlockButton = createElement2(Button, {
		ref = ref,
		text = v2.unlock,
		onActivated = props.onUnlockPressed,
		variant = ButtonVariant.Emphasis,
		inputSize = InputSize.Medium,
		width = UDim.new(1, 0),
		LayoutOrder = 2
	})
	return createElement(View, v3, v4)
end

return AgeCheckUpsellCTA
