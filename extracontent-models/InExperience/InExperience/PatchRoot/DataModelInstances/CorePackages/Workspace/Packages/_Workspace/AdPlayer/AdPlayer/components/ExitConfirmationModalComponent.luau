local parent = script:FindFirstAncestor("AdPlayer").Parent
local AdGuiInteractivity = require(parent.AdGuiInteractivity)
local AdsDisplayOrder = AdGuiInteractivity.AdsDisplayOrder
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local v = { confirmationText = "CoreScripts.Ads.Label.RewardedVideoExitConfirmation" }

local function ExitConfirmationModalComponent(props)
	local v2 = useLocalization(v)

	return React.createElement(
		"ScreenGui",
		{ DisplayOrder = AdsDisplayOrder.Modal, IgnoreGuiInset = true, Enabled = props.Enabled },
		{
			modal = React.createElement(View, {
				tag = "anchor-center-center position-center-center bg-over-media-0 radius-medium padding-x-xxlarge padding-y-xxlarge",
				Size = UDim2.fromOffset(440, 164),
				onActivated = function() end,
				stateLayer = { affordance = StateLayerAffordance.None }
			}, {
				React.createElement(Text, {
					tag = "size-full-1100 position-top-center anchor-top-center text-align-x-left",
					Text = v2.confirmationText,
					TextScaled = true
				}),
				buttonContainer = React.createElement(
					View,
					{
						tag = "size-full-1200 anchor-bottom-center position-bottom-center row gap-medium flex-fill"
					},
					{
						cancelExitButton = React.createElement(Button, {
							text = "Continue",
							fillBehavior = FillBehavior.Fill,
							width = UDim.new(1, 0),
							variant = ButtonVariant.Emphasis,
							onActivated = props.onCancel
						}),
						confirmExitButton = React.createElement(Button, {
							text = "Exit",
							fillBehavior = FillBehavior.Fill,
							width = UDim.new(1, 0),
							variant = ButtonVariant.Standard,
							onActivated = props.onConfirm,
							LayoutOrder = 2
						})
					}
				)
			})
		}
	)
end

return ExitConfirmationModalComponent
