local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local view = Foundation.View
local divider = Foundation.Divider
local icon = Foundation.Icon
local enums = Foundation.Enums

local function fn() end

local v5 = { affordance = enums.StateLayerAffordance.None }

local function InfoTableCell(props)
	local v6 = (props.numColumns or 1) == 1

	local selectable = props.selectable ~= false
	local v7 = React.useMemo(function()
		if selectable then
			return { Selectable = true, SelectionOrder = props.selectionOrder }
		end

		return nil
	end, { selectable, props.selectionOrder })

	local createElement = React.createElement

	local v10 = props.onActivated

	if not v10 then
		v10 = if selectable then fn else nil
	end

	local v11 = if selectable and not props.onActivated then v5 else nil
	local v9 = {
		tag = "col size-full-0 auto-y",
		onActivated = v10,
		selection = v7,
		stateLayer = v11,
		testId = props.testId
	}

	local v13 = if not v6 then React.createElement(divider, { LayoutOrder = 1 }) else nil
	local createElement2 = React.createElement

	local v16 = { Label = props.labelComponent, ValueContainer = 0 }
	local createElement3 = React.createElement

	local v19 = { Value = props.valueComponent, ChevronIcon = 0 }
	local v20 = if props.onActivated then React.createElement(icon, {
		name = enums.IconName.ChevronSmallRight
	}) else nil
	v19.ChevronIcon = v20
	v16.ValueContainer = createElement3(view, {
		LayoutOrder = 2,
		tag = {
			["row size-0-full auto-xy fill align-x-right"] = v6,
			["row size-full-0 auto-y"] = not v6
		}
	}, v19)
	local v12 = {
		TopDivider = v13,
		LabelValueContainer = createElement2(view, {
			LayoutOrder = 2,
			tag = {
				["row size-full-0 auto-y flex-x-between gap-medium padding-y-large"] = v6,
				["col size-full-0 auto-y padding-y-medium"] = not v6
			}
		}, v16),
		BottomDivider = 0
	}

	local v21 = if not (props.isLastInSingleColumn or not v6) then React.createElement(divider, {
		LayoutOrder = 3
	}) else nil
	v12.BottomDivider = v21
	return createElement(view, v9, v12)
end

return React.memo(InfoTableCell)
