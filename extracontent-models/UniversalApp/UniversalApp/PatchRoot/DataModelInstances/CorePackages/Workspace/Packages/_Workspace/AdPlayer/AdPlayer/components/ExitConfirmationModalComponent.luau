local Parent = script:FindFirstAncestor("AdPlayer").Parent
local AdsDisplayOrder = require(Parent.AdGuiInteractivity).AdsDisplayOrder
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local t1 = {
	confirmationText = "CoreScripts.Ads.Label.RewardedVideoExitConfirmation"
}

local function ExitConfirmationModalComponent(t2: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), AdsDisplayOrder (copy), View (copy), StateLayerAffordance (copy), FoundationText (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy)
	local v15 = useLocalization(t1)

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = AdsDisplayOrder.Modal,
		Enabled = t2.Enabled
	}, {
		modal = React.createElement(View, {
			tag = "anchor-center-center position-center-center bg-over-media-0 radius-medium padding-x-xxlarge padding-y-xxlarge",
			Size = UDim2.fromOffset(440, 164),
			onActivated = function() -- line: 35
			end,
			stateLayer = {
				affordance = StateLayerAffordance.None
			}
		}, {
			React.createElement(FoundationText, {
				tag = "size-full-1100 position-top-center anchor-top-center text-align-x-left",
				TextScaled = true,
				Text = v15.confirmationText
			}),
			buttonContainer = React.createElement(View, {
				tag = "size-full-1200 anchor-bottom-center position-bottom-center row gap-medium flex-fill"
			}, {
				cancelExitButton = React.createElement(Button, {
					text = "Continue",
					fillBehavior = FillBehavior.Fill,
					width = UDim.new(1, 0),
					variant = ButtonVariant.Emphasis,
					onActivated = t2.onCancel
				}),
				confirmExitButton = React.createElement(Button, {
					text = "Exit",
					LayoutOrder = 2,
					fillBehavior = FillBehavior.Fill,
					width = UDim.new(1, 0),
					variant = ButtonVariant.Standard,
					onActivated = t2.onConfirm
				})
			})
		})
	})
end

return ExitConfirmationModalComponent
