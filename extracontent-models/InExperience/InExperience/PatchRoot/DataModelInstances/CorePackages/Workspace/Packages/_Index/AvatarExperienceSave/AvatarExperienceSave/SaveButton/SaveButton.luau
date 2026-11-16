local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

local parent = AvatarExperienceSave.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

require(AvatarExperienceSave.SaveButton.useSaveButtonProps)

local function SaveButton(props)
	local v = Foundation.Hooks.useTokens()
	local text = props.text or "Save"

	local createElement = React.createElement
	local button = Foundation.Button
	local v2 = {
		text = text,
		isDisabled = props.disabled,
		size = Foundation.Enums.InputSize.Medium,
		variant = 0,
		onActivated = 0,
		width = 0,
		LayoutOrder = 0
	}
	local variant

	if props.disabled then
		variant = Foundation.Enums.ButtonVariant.Standard
	else
		variant = Foundation.Enums.ButtonVariant.Emphasis
	end

	v2.variant = variant

	v2.onActivated = props.onActivated
	v2.width = UDim.new(0, v.Size.Size_2300)
	v2.LayoutOrder = props.LayoutOrder
	return createElement(button, v2)
end

return SaveButton
