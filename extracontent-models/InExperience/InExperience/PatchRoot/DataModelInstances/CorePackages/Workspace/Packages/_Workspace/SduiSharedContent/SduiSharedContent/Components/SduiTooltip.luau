local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Tooltip = Foundation.Tooltip
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local v = {
	Top = PopoverSide.Top,
	Bottom = PopoverSide.Bottom,
	Left = PopoverSide.Left,
	Right = PopoverSide.Right
}

local v2 = { Start = PopoverAlign.Start, Center = PopoverAlign.Center, End = PopoverAlign.End }

local function SduiTooltip(props)
	if props.anchor == nil then
		return nil
	end

	local shortcut

	if props.shortcut and #props.shortcut > 0 then
		shortcut = props.shortcut
	end

	return React.createElement(Tooltip, {
		title = props.title or "",
		text = props.text,
		shortcut = shortcut,
		side = v[props.side or ""],
		align = v2[props.align or ""],
		LayoutOrder = props.layoutOrder
	}, props.anchor)
end

return React.memo(SduiTooltip)
