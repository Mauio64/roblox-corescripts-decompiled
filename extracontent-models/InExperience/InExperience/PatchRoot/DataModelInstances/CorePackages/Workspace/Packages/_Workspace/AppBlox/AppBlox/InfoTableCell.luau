local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local function fn() end

local v = { affordance = Enums.StateLayerAffordance.None }

local function InfoTableCell(props)
	local v2 = (props.numColumns or 1) == 1

	local selectable = props.selectable ~= false
	local selection = React.useMemo(function()
		if selectable then
			return { Selectable = true, SelectionOrder = props.selectionOrder }
		end

		return nil
	end, { selectable, props.selectionOrder })

	local createElement = React.createElement

	local onActivated = props.onActivated

	if not onActivated then
		onActivated = if selectable then fn else nil
	end

	local stateLayer

	if selectable and not props.onActivated then
		stateLayer = v
	end

	local v3 = {
		tag = "col size-full-0 auto-y",
		onActivated = onActivated,
		selection = selection,
		stateLayer = stateLayer,
		testId = props.testId
	}
	local topDivider

	if not v2 then
		topDivider = React.createElement(Divider, { LayoutOrder = 1 })
	end

	local createElement2 = React.createElement

	local v4 = { Label = props.labelComponent, ValueContainer = 0 }
	local createElement3 = React.createElement

	local v5 = { Value = props.valueComponent, ChevronIcon = 0 }
	local chevronIcon

	if props.onActivated then
		chevronIcon = React.createElement(Icon, { name = Enums.IconName.ChevronSmallRight })
	end

	v5.ChevronIcon = chevronIcon
	v4.ValueContainer = createElement3(View, {
		LayoutOrder = 2,
		tag = {
			["row size-0-full auto-xy fill align-x-right"] = v2,
			["row size-full-0 auto-y"] = not v2
		}
	}, v5)
	local v6 = {
		TopDivider = topDivider,
		LabelValueContainer = createElement2(View, {
			LayoutOrder = 2,
			tag = {
				["row size-full-0 auto-y flex-x-between gap-medium padding-y-large"] = v2,
				["col size-full-0 auto-y padding-y-medium"] = not v2
			}
		}, v4),
		BottomDivider = 0
	}
	local bottomDivider

	if not (props.isLastInSingleColumn or not v2) then
		bottomDivider = React.createElement(Divider, { LayoutOrder = 3 })
	end

	v6.BottomDivider = bottomDivider
	return createElement(View, v3, v6)
end

return React.memo(InfoTableCell)
