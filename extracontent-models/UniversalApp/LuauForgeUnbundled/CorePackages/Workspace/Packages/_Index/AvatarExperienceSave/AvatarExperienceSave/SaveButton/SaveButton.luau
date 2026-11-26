local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Foundation")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/SaveButton/useSaveButtonProps")

local function SaveButton(props)
	local v5 = Foundation.Hooks.useTokens()
	local text = props.text or "Save"

	local createElement = React.createElement
	local button = Foundation.Button
	local v6 = {
		text = text,
		isDisabled = props.disabled,
		size = Foundation.Enums.InputSize.Medium,
		variant = 0,
		onActivated = 0,
		width = 0,
		LayoutOrder = 0
	}
	local v7 = if props.disabled then Foundation.Enums.ButtonVariant.Standard else Foundation.Enums.ButtonVariant.Emphasis
	v6.variant = v7

	v6.onActivated = props.onActivated
	v6.width = UDim.new(0, v5.Size.Size_2300)
	v6.LayoutOrder = props.LayoutOrder
	return createElement(button, v6)
end

return SaveButton
