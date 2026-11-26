local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")

local tooltip = Foundation.Tooltip
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

local v5 = {
	Top = popoverSide.Top,
	Bottom = popoverSide.Bottom,
	Left = popoverSide.Left,
	Right = popoverSide.Right
}

local v6 = {
	Start = popoverAlign.Start,
	Center = popoverAlign.Center,
	End = popoverAlign.End
}

local function SduiTooltip(props)
	if props.anchor == nil then
		return nil
	end

	local v7 = if props.shortcut and #props.shortcut > 0 then props.shortcut else nil
	return React.createElement(tooltip, {
		title = props.title or "",
		text = props.text,
		shortcut = v7,
		side = v5[props.side or ""],
		align = v6[props.align or ""],
		LayoutOrder = props.layoutOrder
	}, props.anchor)
end

return React.memo(SduiTooltip)
