local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local iconButton = Foundation.IconButton

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function StopPlaytestButton(props)
	return React.createElement(iconButton, {
		LayoutOrder = props.layoutOrder,
		icon = iconName.StopSmall,
		isCircular = true,
		isDisabled = props.isDisabled,
		onActivated = props.onActivated,
		size = inputSize.Medium,
		testId = "build-header-stop-playtest-button",
		variant = buttonVariant.Utility
	})
end

return StopPlaytestButton
