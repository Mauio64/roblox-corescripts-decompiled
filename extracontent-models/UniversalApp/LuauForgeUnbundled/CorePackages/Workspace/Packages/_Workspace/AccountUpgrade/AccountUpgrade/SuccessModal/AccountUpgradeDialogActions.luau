local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local buttonGroup = Foundation.ButtonGroup
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation

local function AccountUpgradeDialogActions(props)
	local v5 = {}

	for k, button in props.buttons do
		table.insert(v5, {
			text = button.text,
			variant = button.variant,
			onActivated = button.onActivated,
			isDisabled = button.isDisabled,
			isLoading = button.isLoading
		})
	end

	return React.createElement(buttonGroup, {
		buttons = v5,
		orientation = orientation.Vertical,
		LayoutOrder = props.LayoutOrder or 3,
		testId = props.testId or "account-upgrade-dialog-actions"
	})
end

return AccountUpgradeDialogActions
