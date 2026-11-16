local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function StopPlaytestButton(props)
	return React.createElement(IconButton, {
		LayoutOrder = props.layoutOrder,
		icon = IconName.StopSmall,
		isCircular = true,
		isDisabled = props.isDisabled,
		onActivated = props.onActivated,
		size = InputSize.Medium,
		testId = "build-header-stop-playtest-button",
		variant = ButtonVariant.Utility
	})
end

return StopPlaytestButton
