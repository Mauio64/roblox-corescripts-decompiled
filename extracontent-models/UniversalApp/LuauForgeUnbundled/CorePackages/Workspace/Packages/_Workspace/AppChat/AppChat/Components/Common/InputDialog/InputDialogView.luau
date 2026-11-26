local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local dialog = Foundation.Dialog
local text = Foundation.Text
local textInput = Foundation.TextInput
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function InputDialogView(props)
	local createElement = React.createElement
	local root = dialog.Root
	local v5 = {
		ref = props.dialogRef,
		disablePortal = false,
		hasBackdrop = true,
		size = dialogSize.Small,
		testId = "InputDialogView"
	}

	local children = {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = props.titleText or ""
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local v7 = {
		Input = React.createElement(textInput, {
			LayoutOrder = 1,
			label = "",
			text = props.text,
			placeholder = props.placeholderText,
			hint = props.counterText,
			hasError = props.isOverLimit,
			onChanged = props.onTextChanged,
			width = UDim.new(1, 0),
			testId = "InputDialogView--input"
		}),
		Warning = 0
	}

	local v8 = if props.warningText then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.warningText,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-alert",
		testId = "InputDialogView--warning"
	}) else nil
	v7.Warning = v8
	children.Content = createElement2(content, { LayoutOrder = 2 }, v7)

	children.Actions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = props.cancelText,
				variant = buttonVariant.Standard,
				onActivated = props.onCancel,
				isDisabled = props.isLoading
			},
			{
				text = props.confirmText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onConfirm,
				isDisabled = props.isOverLimit,
				isLoading = props.isLoading
			}
		}
	})
	return createElement(root, v5, children)
end

return InputDialogView
