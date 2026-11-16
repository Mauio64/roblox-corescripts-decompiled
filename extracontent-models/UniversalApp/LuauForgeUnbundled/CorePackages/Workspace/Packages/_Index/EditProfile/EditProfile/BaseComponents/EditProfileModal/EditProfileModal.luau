local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization

return function(props)
	local v5 = useLocalization({
		title = props.titleKey,
		saveButtonText = props.saveKey
	})

	return React.createElement(dialog.Root, { onClose = props.onClose }, {
		Title = React.createElement(dialog.Title, { text = v5.title, LayoutOrder = 1 }),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, props.component),
		Actions = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v5.saveButtonText,
					variant = buttonVariant.Emphasis,
					isLoading = props.isLoading,
					isDisabled = props.isDisabled,
					onActivated = props.onSave
				}
			}
		})
	})
end
