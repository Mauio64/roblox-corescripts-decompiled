local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function PurchaseWarningsDialogView(props)
	local createElement = React.createElement
	local root = dialog.Root
	local v5 = {
		size = dialogSize.Medium,
		hasBackdrop = true,
		disablePortal = false,
		onClose = props.onClose,
		ref = props.focusRef,
		testId = props.testId
	}
	local v6 = {
		Title = React.createElement(dialog.Title, { text = props.title }),
		Body = React.createElement(dialog.Text, { LayoutOrder = 2, Text = props.body }),
		Actions = 0
	}

	local v7 = if props.primaryText and props.onPrimaryActivated and props.secondaryText and props.onSecondaryActivated then React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = props.primaryText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onPrimaryActivated
			},
			{
				text = props.secondaryText,
				variant = buttonVariant.Standard,
				onActivated = props.onSecondaryActivated
			}
		}
	}) else nil
	v6.Actions = v7
	return createElement(root, v5, v6)
end

return PurchaseWarningsDialogView
