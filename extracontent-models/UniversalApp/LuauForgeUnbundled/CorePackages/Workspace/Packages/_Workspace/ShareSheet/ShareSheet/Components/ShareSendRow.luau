local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local button = Foundation.Button
local textInput = Foundation.TextInput
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function ShareSendRow(props)
	local state, setState = React.useState("")
	local v5 = React.useCallback(function()
		props.onActivated(state)
	end, { state, props.onActivated })

	return React.createElement(
		view,
		{ tag = "col gap-medium size-full-0 auto-y", testId = "share-send-row" },
		{
			MessageInput = React.createElement(textInput, {
				isDisabled = props.isLoading,
				label = "",
				LayoutOrder = 1,
				onChanged = setState,
				onFocusGained = props.onFocusGained,
				placeholder = props.messagePlaceholder,
				size = inputSize.Medium,
				testId = "share-message-input",
				text = state,
				width = UDim.new(1, 0)
			}),
			SendButton = React.createElement(button, {
				text = props.label,
				variant = buttonVariant.Emphasis,
				isLoading = props.isLoading,
				LayoutOrder = 2,
				size = inputSize.Medium,
				onActivated = v5,
				testId = "share-send-button",
				width = UDim.new(1, 0)
			})
		}
	)
end

return ShareSendRow
