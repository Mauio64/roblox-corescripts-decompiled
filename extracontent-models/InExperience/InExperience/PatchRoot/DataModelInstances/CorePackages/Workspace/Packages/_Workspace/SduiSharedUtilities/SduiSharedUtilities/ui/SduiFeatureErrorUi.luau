local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function SduiFeatureErrorUi(p)
	local v = useTokens()
	local v2 = useLocalization({
		errorMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		retryButtonText = "InGame.CommonUI.Button.Retry"
	})

	local createElement = React.createElement
	local v3 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v4 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Gap.Large)
		}),
		ErrorText = React.createElement(Text, {
			tag = "auto-xy text-body-medium content-default text-align-x-center",
			Text = v2.errorMessage,
			LayoutOrder = 1
		}),
		RetryButton = 0
	}
	local retryButton

	if p.onRetry then
		retryButton = React.createElement(Button, {
			text = v2.retryButtonText,
			onActivated = p.onRetry,
			LayoutOrder = 2,
			size = ButtonSize.Medium,
			variant = ButtonVariant.Emphasis
		})
	end

	v4.RetryButton = retryButton
	return createElement("Frame", v3, v4)
end

return SduiFeatureErrorUi
