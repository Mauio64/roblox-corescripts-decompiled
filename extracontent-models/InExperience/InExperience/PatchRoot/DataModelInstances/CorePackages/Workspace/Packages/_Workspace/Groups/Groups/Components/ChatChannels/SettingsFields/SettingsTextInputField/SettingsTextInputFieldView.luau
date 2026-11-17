local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SettingsFieldBase = require(script.Parent.Parent.SettingsFieldBase)

local Dialog = Foundation.Dialog

local function SettingsTextInputFieldView(props)
	local buttons = {
		{
			text = props.cancelText,
			variant = Foundation.Enums.ButtonVariant.Standard,
			onActivated = props.onCancel,
			testId = `{props.testId}--cancel`
		},
		{
			text = props.saveText,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			isDisabled = not props.canSave,
			onActivated = props.onSave,
			testId = `{props.testId}--save`
		}
	}

	local createElement = React.createElement
	local fragment = React.Fragment
	local v = {
		Field = React.createElement(SettingsFieldBase, {
			title = props.title,
			description = props.value,
			onClick = props.onOpen,
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		}),
		Editor = 0
	}
	local editor

	if props.isEditing then
		local createElement2 = React.createElement
		local root = Dialog.Root
		local v2 = {
			ref = props.dialogRef,
			onClose = 0,
			hasBackdrop = true,
			disablePortal = false,
			testId = 0
		}
		local onClose

		if not props.hideCloseButton then
			onClose = props.onCancel
		end

		v2.onClose = onClose

		v2.testId = `{props.testId}--editor`
		editor = createElement2(root, v2, {
			Title = React.createElement(Dialog.Title, { text = props.title, LayoutOrder = 1 }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				Body = React.createElement(Foundation.View, {
					tag = "col gap-medium size-full-0 auto-y"
				}, {
					Description = React.createElement(Foundation.Text, {
						Text = props.description,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-muted",
						LayoutOrder = 1
					}),
					Input = React.createElement(
						Foundation.View,
						{ tag = "col gap-xsmall size-full-0 auto-y", LayoutOrder = 2 },
						{
							TextInput = React.createElement(Foundation.TextInput, {
								inputRef = props.inputRef,
								label = "",
								text = props.draft,
								onChanged = props.onDraftChanged,
								onReturnPressed = props.onSave,
								hasError = props.hasError,
								width = UDim.new(1, 0),
								LayoutOrder = 1,
								testId = `{props.testId}--input`
							}),
							RemainingCharacters = React.createElement(Foundation.Text, {
								Text = tostring(props.remainingCharacters),
								tag = "size-full-0 auto-y text-caption-small text-align-x-right content-muted",
								LayoutOrder = 2
							})
						}
					)
				})
			}),
			Actions = React.createElement(Foundation.ButtonGroup, {
				LayoutOrder = 3,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				buttons = buttons
			})
		})
	end

	v.Editor = editor
	return createElement(fragment, nil, v)
end

return SettingsTextInputFieldView
