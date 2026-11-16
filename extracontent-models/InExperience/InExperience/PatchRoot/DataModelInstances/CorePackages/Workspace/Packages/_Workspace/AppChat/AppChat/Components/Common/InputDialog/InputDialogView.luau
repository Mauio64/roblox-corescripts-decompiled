local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Dialog = Foundation.Dialog
local Text = Foundation.Text
local TextInput = Foundation.TextInput
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize

local function InputDialogView(props)
	local createElement = React.createElement
	local root = Dialog.Root
	local v = {
		ref = props.dialogRef,
		disablePortal = false,
		hasBackdrop = true,
		size = DialogSize.Small,
		testId = "InputDialogView"
	}

	local children = {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = props.titleText or ""
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local v2 = {
		Input = React.createElement(TextInput, {
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
	local warning

	if props.warningText then
		warning = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.warningText,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-alert",
			testId = "InputDialogView--warning"
		})
	end

	v2.Warning = warning
	children.Content = createElement2(content, { LayoutOrder = 2 }, v2)

	children.Actions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = props.cancelText,
				variant = ButtonVariant.Standard,
				onActivated = props.onCancel,
				isDisabled = props.isLoading
			},
			{
				text = props.confirmText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onConfirm,
				isDisabled = props.isOverLimit,
				isLoading = props.isLoading
			}
		}
	})
	return createElement(root, v, children)
end

return InputDialogView
