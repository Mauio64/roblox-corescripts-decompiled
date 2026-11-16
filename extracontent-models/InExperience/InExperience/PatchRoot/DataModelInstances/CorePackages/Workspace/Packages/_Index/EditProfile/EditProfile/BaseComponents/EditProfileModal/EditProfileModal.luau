local parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

return function(props)
	local v = useLocalization({ title = props.titleKey, saveButtonText = props.saveKey })

	return React.createElement(Dialog.Root, { onClose = props.onClose }, {
		Title = React.createElement(Dialog.Title, { text = v.title, LayoutOrder = 1 }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, props.component),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v.saveButtonText,
					variant = ButtonVariant.Emphasis,
					isLoading = props.isLoading,
					isDisabled = props.isDisabled,
					onActivated = props.onSave
				}
			}
		})
	})
end
