local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require(Parent.Localization).Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), React (copy), Dialog (copy), ButtonVariant (copy)
	local v8 = useLocalization({
		title = t1.titleKey,
		saveButtonText = t1.saveKey
	})

	return React.createElement(Dialog.Root, {
		onClose = t1.onClose
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v8.title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, t1.component),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v8.saveButtonText,
				variant = ButtonVariant.Emphasis,
				isLoading = t1.isLoading,
				isDisabled = t1.isDisabled,
				onActivated = t1.onSave
			}}
		})
	})
end
