local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function SduiFeatureErrorUi(t1: {[any]: any}) -- line: 17
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), FoundationText (copy), Button (copy), ButtonSize (copy), ButtonVariant (copy)
	local v12 = useTokens()
	local v13 = useLocalization({
		errorMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		retryButtonText = "InGame.CommonUI.Button.Retry"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v12.Gap.Large)
		}),
		ErrorText = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium content-default text-align-x-center",
			LayoutOrder = 1,
			Text = v13.errorMessage
		}),
		RetryButton = if not t1.onRetry then nil else React.createElement(Button, {
			LayoutOrder = 2,
			text = v13.retryButtonText,
			onActivated = t1.onRetry,
			size = ButtonSize.Medium,
			variant = ButtonVariant.Emphasis
		})
	})
end

return SduiFeatureErrorUi
