local module = require("@luauforge/bundled/hHr")
local module2 = require("@luauforge/bundled/hHu")

local dialog = module.Dialog
local buttonVariant = module.Enums.ButtonVariant
local dialogSize = module.Enums.DialogSize

local function PurchaseWarningsDialogView(props)
	local createElement = module2.createElement
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
		Title = module2.createElement(dialog.Title, { text = props.title }),
		Body = module2.createElement(dialog.Text, { LayoutOrder = 2, Text = props.body }),
		Actions = 0
	}

	local v7 = if props.primaryText and props.onPrimaryActivated and props.secondaryText and props.onSecondaryActivated then module2.createElement(dialog.Actions, {
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
