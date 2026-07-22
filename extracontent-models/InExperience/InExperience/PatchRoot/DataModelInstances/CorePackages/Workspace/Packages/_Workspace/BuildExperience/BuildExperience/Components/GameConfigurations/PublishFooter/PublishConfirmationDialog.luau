local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Dialog = Foundation.Dialog
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local InputSize = Foundation.Enums.InputSize

local function PublishConfirmationDialog(t1: {[any]: any}) -- line: 31
	-- upvalues: React (copy), Dialog (copy), DialogSize (copy), View (copy), TextInput (copy), InputSize (copy), TextArea (copy), ButtonVariant (copy)
	local v13 = t1.testId or "publish-confirmation-dialog"
	local v14, v15 = React.useState(t1.defaultTitle or "")
	local v16, v17 = React.useState(t1.defaultDescription or "")

	local function onConfirm() -- line: 36
		-- upvalues: t1 (copy), v14 (copy), v16 (copy)
		t1.onConfirm(if v14 ~= "" then v14 else nil, if v16 ~= "" then v16 else nil)
	end

	return React.createElement(Dialog.Root, {
		disablePortal = t1.disablePortal == true,
		hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop,
		onClose = t1.onCancel,
		size = DialogSize.Medium,
		testId = v13
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = "Publish game?"
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Body = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y"
			}, {
				Description = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = "Your latest changes will be saved and made available to eligible players."
				}),
				TitleInput = React.createElement(TextInput, {
					LayoutOrder = 2,
					label = "Version title",
					placeholder = "Describe what changed in this version",
					text = v14,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					onChanged = v15,
					testId = `{ v13 }-title-input`
				}),
				DescriptionInput = React.createElement(TextArea, {
					LayoutOrder = 3,
					label = "Version details",
					placeholder = "Add more information about the changes",
					numLines = 4,
					text = v16,
					width = UDim.new(1, 0),
					onChanged = v17,
					testId = `{ v13 }-description-input`
				})
			})
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = "Publish",
					variant = ButtonVariant.Emphasis,
					onActivated = onConfirm
				},
				{
					text = "Cancel",
					variant = ButtonVariant.Standard,
					onActivated = t1.onCancel
				}
			}
		})
	})
end

return PublishConfirmationDialog
