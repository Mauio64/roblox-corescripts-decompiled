local module = require("@luauforge/bundled/dLe")
local module2 = require("@luauforge/bundled/dLf")

local iconButton = module2.App.Button.IconButton
local images = module2.App.ImageSet.Images

local useStyle = module2.Core.Style.useStyle

local iconsmenuclothingclassicHead_on = images["icons/menu/clothing/classicHead_on"]
local iconsmenuclothingclassicHead_off = images["icons/menu/clothing/classicHead_off"]

local function HeadRefinementEntryButton(props)
	local theme = useStyle().Theme

	local createElement = module.createElement
	local v7 = if props.isSelected then iconsmenuclothingclassicHead_on else iconsmenuclothingclassicHead_off
	local v6 = {
		icon = v7,
		iconSize = module2.App.Constant.IconSize.Medium,
		iconColor3 = 0,
		iconTransparency = 0,
		showBackground = true,
		onActivated = 0,
		buttonRef = 0,
		NextSelectionUp = 0,
		NextSelectionDown = 0
	}
	local v8 = if props.isSelected then theme.IconEmphasis.Color else theme.IconDefault.Color
	v6.iconColor3 = v8
	local v9 = if props.isSelected then theme.IconEmphasis.Transparency else theme.IconDefault.Transparency
	v6.iconTransparency = v9

	function v6.onActivated()
		if props.onActivated then
			props.onActivated()
		end
	end

	v6.buttonRef = props.buttonRef
	v6.NextSelectionUp = props.nextSelectionUp
	v6.NextSelectionDown = props.nextSelectionDown
	return createElement(iconButton, v6)
end

return HeadRefinementEntryButton
