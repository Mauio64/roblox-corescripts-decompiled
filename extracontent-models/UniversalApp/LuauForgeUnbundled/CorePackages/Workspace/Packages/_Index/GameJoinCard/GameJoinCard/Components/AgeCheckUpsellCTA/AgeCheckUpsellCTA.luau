local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization")

local button = Foundation.Button
local divider = Foundation.Divider
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local dividerVariant = Foundation.Enums.DividerVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local inputSize = Foundation.Enums.InputSize

local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local fFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport
local fFlagDesktopGameJoinCardGamepadSupport = SharedFlags.FFlagDesktopGameJoinCardGamepadSupport
local v5 = fFlagMobileGameJoinCardGamepadSupport or fFlagDesktopGameJoinCardGamepadSupport

local function AgeCheckUpsellCTA(props)
	local v6 = useLocalization({
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		bodyText = "Feature.FAE.CheckIfYouCanJoinGame"
	})

	local createElement = React.createElement
	local v8 = { tag = "col size-full-0 auto-y", LayoutOrder = props.LayoutOrder }
	local v9 = {
		Banner = React.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			TopDivider = React.createElement(divider, {
				variant = dividerVariant.Default,
				LayoutOrder = 1
			}),
			BannerContent = React.createElement(
				view,
				{
					tag = "row align-x-left align-y-center gap-medium size-full-0 auto-y padding-y-medium",
					LayoutOrder = 2
				},
				{
					BannerIcon = React.createElement(icon, {
						tag = "content-emphasis",
						name = iconName.LockClosed,
						size = iconSize.Large,
						variant = iconVariant.Regular
					}),
					BannerText = React.createElement(text, {
						tag = "shrink auto-xy text-wrap text-align-x-left text-body-medium content-emphasis",
						Text = v6.bodyText
					})
				}
			)
		}),
		UnlockButton = 0
	}

	local createElement2 = React.createElement
	local v12 = if v5 then props.focusRef else nil
	v9.UnlockButton = createElement2(button, {
		ref = v12,
		text = v6.unlock,
		onActivated = props.onUnlockPressed,
		variant = buttonVariant.Emphasis,
		inputSize = inputSize.Medium,
		width = UDim.new(1, 0),
		LayoutOrder = 2
	})
	return createElement(view, v8, v9)
end

return AgeCheckUpsellCTA
