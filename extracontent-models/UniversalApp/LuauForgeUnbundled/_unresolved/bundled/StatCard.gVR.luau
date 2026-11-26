local module = require("@luauforge/bundled/gVG")
local module2 = require("@luauforge/bundled/gVI")
local view = module2.View
local text = module2.Text
local icon = module2.Icon
local iconSize = module2.Enums.IconSize

local function StatCard(props)
	local createElement = module.createElement
	local v6 = {
		tag = "col grow gap-xsmall auto-y padding-medium radius-large bg-shift-100",
		flexItem = {
			FlexMode = Enum.UIFlexMode.Fill,
			ItemLineAlignment = Enum.ItemLineAlignment.Stretch
		},
		Size = UDim2.new(0.45, 0, 0, 0),
		LayoutOrder = props.layoutOrder
	}
	local v7 = {
		Label = module.createElement(text, {
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-muted",
			Text = props.label,
			LayoutOrder = 1
		}),
		ValueRow = 0
	}

	local createElement2 = module.createElement

	local v11 = if props.valueIconName then module.createElement(icon, {
		name = props.valueIconName,
		size = iconSize.Medium,
		LayoutOrder = 1
	}) else nil
	v7.ValueRow = createElement2(view, {
		tag = "row align-y-center gap-xsmall auto-xy",
		LayoutOrder = 2
	}, {
		ValueIcon = v11,
		Value = module.createElement(text, {
			tag = "auto-xy text-heading-medium text-align-x-left content-emphasis",
			Text = props.value,
			LayoutOrder = 2
		})
	})
	return createElement(view, v6, v7)
end

return StatCard
