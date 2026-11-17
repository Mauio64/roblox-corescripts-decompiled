local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function ShareSendRow(props)
	local state, setState = React.useState("")
	local onActivated = React.useCallback(function()
		props.onActivated(state)
	end, { state, props.onActivated })

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		testId = "share-send-row"
	}, {
		MessageInput = React.createElement(TextInput, {
			isDisabled = props.isLoading,
			label = "",
			LayoutOrder = 1,
			onChanged = setState,
			onFocusGained = props.onFocusGained,
			placeholder = props.messagePlaceholder,
			size = InputSize.Medium,
			testId = "share-message-input",
			text = state,
			width = UDim.new(1, 0)
		}),
		SendButton = React.createElement(Button, {
			text = props.label,
			variant = ButtonVariant.Emphasis,
			isLoading = props.isLoading,
			LayoutOrder = 2,
			size = InputSize.Medium,
			onActivated = onActivated,
			testId = "share-send-button",
			width = UDim.new(1, 0)
		})
	})
end

return ShareSendRow
