local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation")
local text = Foundation.Text
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Localization").Hooks.useLocalization

local function SduiFeatureErrorUi(p2)
	local v5 = useTokens()
	local v6 = useLocalization({
		errorMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
		retryButtonText = "InGame.CommonUI.Button.Retry"
	})

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v9 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Large)
		}),
		ErrorText = React.createElement(text, {
			tag = "auto-xy text-body-medium content-default text-align-x-center",
			Text = v6.errorMessage,
			LayoutOrder = 1
		}),
		RetryButton = 0
	}

	local v10 = if p2.onRetry then React.createElement(button, {
		text = v6.retryButtonText,
		onActivated = p2.onRetry,
		LayoutOrder = 2,
		size = buttonSize.Medium,
		variant = buttonVariant.Emphasis
	}) else nil
	v9.RetryButton = v10
	return createElement("Frame", v8, v9)
end

return SduiFeatureErrorUi
