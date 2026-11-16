local module = require("@luauforge/deferred/fxP")
local module2 = require("@luauforge/deferred/fxM")

local buttonVariant = module.Enums.ButtonVariant
local dialog = module.Dialog
local dialogSize = module.Enums.DialogSize
local orientation = module.Enums.Orientation

require("@luauforge/deferred/fxK")

local module3 = require("@luauforge/deferred/fxH")

local function TransientDialog(props)
	local createElement = module2.createElement
	local root = dialog.Root
	local v5 = {
		disablePortal = false,
		hasBackdrop = true,
		onClose = props.onClose ~= nil and function()
			module3(false).clearDialog()
			props.onClose()
		end or nil,
		size = dialogSize.Small,
		testId = "transient-ui-dialog"
	}

	local v6 = {
		Title = module2.createElement(dialog.Title, {
			text = props.title,
			LayoutOrder = 1
		}),
		Content = 0,
		Actions = 0
	}

	local v7 = if props.body ~= nil then module2.createElement(dialog.Content, {
		LayoutOrder = 2
	}, {
		Body = module2.createElement(dialog.Text, { Text = props.body, LayoutOrder = 1 })
	}) else nil
	v6.Content = v7

	v6.Actions = module2.createElement(dialog.Actions, {
		orientation = orientation.Horizontal,
		LayoutOrder = 3,
		actions = {
			{
				text = props.primaryActionText,
				variant = buttonVariant.Emphasis,
				onActivated = function()
					module3(false).clearDialog()
					props.onPrimaryActivated()
				end
			},
			{
				text = props.secondaryActionText,
				variant = buttonVariant.Standard,
				onActivated = function()
					module3(false).clearDialog()
					props.onSecondaryActivated()
				end
			}
		}
	})
	return createElement(root, v5, v6)
end

return TransientDialog
