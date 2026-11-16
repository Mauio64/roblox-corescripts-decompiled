local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
require(parent.Components.Common.ActionText)
local ControlActionRow = require(parent.Components.Common.ControlActionRow)
local TouchControlIcon = require(script.Parent.TouchControlIcon)

local function TouchControlList(props)
	local v = Foundation.Hooks.useTokens()
	local showIconBackground = props.showIconBackground ~= false
	local children = {}

	for i, control in ipairs(props.controls) do
		local id = control.id
		local createElement = React.createElement
		local children2 = {
			textVariant = props.textVariant or "label-small",
			actionLabels = {
				{ label = control.label, disabled = control.disabled }
			},
			layoutOrderReversed = props.layoutOrderReversed,
			layoutOrder = i,
			iconWidth = v.Size.Size_500,
			testId = "TouchActionText-" .. control.id,
			icon = 0
		}
		local createElement2 = React.createElement
		local v2 = {
			name = control.icon,
			assetId = control.assetId,
			diameter = v.Size.Size_500,
			iconDiameter = 0,
			disabled = 0,
			showBackground = 0,
			LayoutOrder = 0,
			testId = 0
		}
		local iconDiameter

		if showIconBackground then
			iconDiameter = v.Size.Size_300
		else
			iconDiameter = v.Size.Size_500
		end

		v2.iconDiameter = iconDiameter
		v2.disabled = control.disabled
		v2.showBackground = showIconBackground
		v2.LayoutOrder = props.layoutOrderReversed and 1 or 2
		v2.testId = "TouchActionIcon-" .. control.id
		children2.icon = createElement2(TouchControlIcon, v2)
		children[id] = createElement(ControlActionRow, children2)
	end

	return React.createElement(Foundation.View, { tag = "col gap-small size-full-0 auto-y" }, children)
end

return React.memo(TouchControlList)
