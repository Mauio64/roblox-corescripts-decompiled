local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local ButtonGroup = Foundation.ButtonGroup
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation

local function AccountUpgradeDialogActions(props)
	local buttons = {}

	for _, button in props.buttons do
		table.insert(buttons, {
			text = button.text,
			variant = button.variant,
			onActivated = button.onActivated,
			isDisabled = button.isDisabled,
			isLoading = button.isLoading
		})
	end

	return React.createElement(ButtonGroup, {
		buttons = buttons,
		orientation = Orientation.Vertical,
		LayoutOrder = props.LayoutOrder or 3,
		testId = props.testId or "account-upgrade-dialog-actions"
	})
end

return AccountUpgradeDialogActions
